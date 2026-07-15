import 'package:flutter/material.dart';
import 'package:frontend/models/task.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/task_provider.dart';
import 'package:frontend/services/camera_service.dart';
import 'dart:io';

import 'package:frontend/services/location_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class NewTaskDetailsScreen extends StatefulWidget {
  final Task task;

  const NewTaskDetailsScreen({super.key, required this.task});

  @override
  State<NewTaskDetailsScreen> createState() => _NewTaskDetailsScreenState();
}

class _NewTaskDetailsScreenState extends State<NewTaskDetailsScreen> {
  final _noteController = TextEditingController();

  // Operational states
  String? _photoPath; // Holds real local image path
  String _coordinates = "Not captured yet";
  String _locationName = "Unknown Location";
  bool _isFetchingLocation = false;
  bool _isSubmitting = false;
  Position? _currentPosition;
  final CameraService cameraService = CameraService();
  final LocationService locationService = LocationService();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  // Capture an actual photo using the camera
  void _capturePhoto() async {
    try {
      final image = await cameraService.captureImage();

      if (image == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("⚠️ Image capture was canceled."),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      setState(() {
        _photoPath = image.path;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("📸 Photo attached successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      // Automatically trigger location capture right after a successful photo
      await _fetchCurrentLocation();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("❌ Failed to capture photo: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Fetch real geolocation coords (triggered automatically by _capturePhoto)
  Future<void> _fetchCurrentLocation() async {
    setState(() {
      _isFetchingLocation = true;
    });

    try {
      // 1. Capture the new LocationResult model wrapper
      final LocationResult result = await locationService.getCurrentLocation();

      if (!mounted) return;

      setState(() {
        _coordinates =
            "${result.position.latitude.toStringAsFixed(4)}° N, ${result.position.longitude.toStringAsFixed(4)}° E";
        _locationName = result.address;
        _currentPosition = result.position;
        _isFetchingLocation = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isFetchingLocation = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("❌ Error fetching location: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  // Submit Form Update

  Future<void> _submitTaskUpdate() async {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (_photoPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("⚠️ Please attach a site photo before submitting."),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "⚠️ Please fetch your current location before submitting.",
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Prepare the real file object using the path string
      // (Ensure you have 'import 'dart:io';' at the top of your file)
      final File imageFile = File(_photoPath!);

      final bool success = await taskProvider.completeTask(
        widget.task.id,
        authProvider.token!,
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        imageFile,
        _noteController.text,
      );

      // 4. Memory Guard: Ensure screen hasn't closed during network transit
      if (!mounted) return;
      setState(() => _isSubmitting = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Task updates successfully uploaded!"),
            backgroundColor: Colors.green,
          ),
        );

        // 5. Safe pop execution matching modern Flutter framework guidance
        Navigator.pop(context);
      } else {
        throw Exception("Server rejected task completion request.");
      }
    } catch (e) {
      // Graceful error recovery state reset
      if (!mounted) return;
      setState(() => _isSubmitting = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("❌ Submission Failed: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.brightness == Brightness.light
          ? Colors.grey[50]
          : Colors.grey[900],
      appBar: AppBar(
        title: const Text("Task Submission"),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Task Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: widget.task.status == "In Progress"
                    ? Colors.orange.withValues(alpha: 0.1)
                    : Colors.blueGrey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.task.status.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: widget.task.status == "In Progress"
                      ? Colors.orange
                      : Colors.blueGrey,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.task.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              widget.task.description ?? "No description provided.",
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Divider(),
            ),

            /// Section 1: Photo Attachment (Now showing the raw, real captured image!)
            const SectionTitle(text: "1. Site Photo Proof"),
            const SizedBox(height: 10),
            PhotoSection(photoPath: _photoPath, onCapturePhoto: _capturePhoto),

            const SizedBox(height: 24),

            /// Section 2: Location Validation
            const SectionTitle(text: "2. Geo-Location Validation"),
            const SizedBox(height: 10),
            LocationSection(
              locationName: _locationName,
              coordinates: _coordinates,
              isFetchingLocation: _isFetchingLocation,
              onCaptureLocation: _fetchCurrentLocation,
            ),

            const SizedBox(height: 24),

            /// Section 3: Operational Notes
            const SectionTitle(text: "3. Field Operator Notes"),
            const SizedBox(height: 10),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Enter details, issues found, or resolutions here...",
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                filled: true,
                fillColor: theme.colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: theme.colorScheme.outlineVariant.withValues(
                      alpha: 0.4,
                    ),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: theme.colorScheme.outlineVariant.withValues(
                      alpha: 0.4,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 35),

            /// Submit Actions
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitTaskUpdate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Submit Field Report",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// --- Refined Stateless Widgets ---

class SectionTitle extends StatelessWidget {
  final String text;

  const SectionTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.onSurface,
      ),
    );
  }
}

class PhotoSection extends StatelessWidget {
  final String? photoPath;
  final VoidCallback onCapturePhoto;

  const PhotoSection({
    super.key,
    required this.photoPath,
    required this.onCapturePhoto,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onCapturePhoto,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(
          color: photoPath == null
              ? theme.colorScheme.surfaceVariant.withValues(alpha: 0.3)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(
              alpha: photoPath == null ? 0.6 : 0.4,
            ),
          ),
        ),
        child: photoPath != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(File(photoPath!), fit: BoxFit.cover),
                  ),
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt_outlined,
                    size: 38,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Tap to Capture Photo",
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "JPEG format, max 10MB",
                    style: TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ),
      ),
    );
  }
}

class LocationSection extends StatelessWidget {
  final String locationName;
  final String coordinates;
  final bool isFetchingLocation;
  final VoidCallback onCaptureLocation;

  const LocationSection({
    super.key,
    required this.locationName,
    required this.coordinates,
    required this.isFetchingLocation,
    required this.onCaptureLocation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.location_on, color: Colors.red, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  locationName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "GPS: $coordinates",
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'monospace',
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
