import 'package:flutter/material.dart';
import 'package:frontend/models/task.dart';

class NewTaskDetailsScreen extends StatefulWidget {
  final Task task;

  const NewTaskDetailsScreen({super.key, required this.task});

  @override
  State<NewTaskDetailsScreen> createState() => _NewTaskDetailsScreenState();
}



class _NewTaskDetailsScreenState extends State<NewTaskDetailsScreen> {
  final _noteController = TextEditingController();
  
  // Simulated operational states
  String? _photoPath; // Will hold local image path when integrated with image_picker
  String _coordinates = "Not captured yet";
  String _locationName = "Unknown Location";
  bool _isFetchingLocation = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  // 📸 Simulates taking a photo (Plug 'image_picker' here later!)
  void _simulateCapturePhoto() {
    
    setState(() {
      
      _photoPath = "captured_site_photo.jpg"; // Mock path
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("📸 Photo captured successfully!")),
    );
  }

  // 📍 Simulates fetching geolocation coords (Plug 'geolocator' here later!)
  Future<void> _simulateFetchLocation() async {
    setState(() => _isFetchingLocation = true);
    await Future.delayed(const Duration(milliseconds: 800)); // Smooth loading feel
    setState(() {
      _coordinates = "26.2285° N, 50.5860° E"; // Mock GPS coordinates (e.g., Manama, Bahrain)
      _locationName = "Seef District Office, Block 428";
      _isFetchingLocation = false;
    });
  }

  // 🚀 Form submission
  void _submitTaskUpdate() {
    if (_photoPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("⚠️ Please attach a site photo before submitting."),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    
    // Simulate API delay
    Future.delayed(const Duration(seconds: 1), () {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Task updates successfully uploaded!"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context); // Go back to Home
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.brightness == Brightness.light ? Colors.grey[50] : Colors.grey[900],
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
            /// Task Badge & Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: widget.task.status == "In Progress" 
                    ? Colors.orange.withOpacity(0.1) 
                    : Colors.blueGrey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.task.status.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: widget.task.status == "In Progress" ? Colors.orange : Colors.blueGrey,
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
              style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface.withOpacity(0.6)),
            ),
            
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Divider(),
            ),

            /// Section: Photo Attachment
            _buildSectionTitle(theme, "1. Site Photo Proof"),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _simulateCapturePhoto,
              child: Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.outlineVariant.withOpacity(0.4),
                    style: _photoPath == null ? BorderStyle.solid : BorderStyle.solid,
                  ),
                ),
                child: _photoPath != null
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              color: Colors.blueGrey[100],
                              child: const Center(
                                child: Icon(Icons.image, size: 50, color: Colors.blueGrey),
                              ),
                            ),
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
                              child: const Icon(Icons.edit, color: Colors.white, size: 16),
                            ),
                          ),
                          const Center(
                            child: Card(
                              color: Colors.black87,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                child: Text(
                                  "Photo Attached (Simulator)",
                                  style: TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt_outlined, size: 38, color: theme.colorScheme.primary),
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
            ),

            const SizedBox(height: 24),

            /// Section: Location & Coordinates Capture
            _buildSectionTitle(theme, "2. Geo-Location Validation"),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
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
                          _locationName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "GPS: $_coordinates",
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'monospace',
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _isFetchingLocation ? null : _simulateFetchLocation,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    child: _isFetchingLocation
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text("Capture"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// Section: Operational Note
            _buildSectionTitle(theme, "3. Field Operator Notes"),
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
                  borderSide: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.4)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.4)),
                ),
              ),
            ),

            const SizedBox(height: 35),

            /// Submit Action
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
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String text) {
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