import 'package:flutter/material.dart';

class Task {
  final int id;
  final int userId;
  final String title;
  final String description;
  final String status;
  final double latitude;
  final double longitude;

  Task({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.status,
    required this.latitude,
    required this.longitude,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    debugPrint(json.toString());

    return Task(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "title": title,
      "description": description,
      "status": status,
      "latitude": latitude,
      "longitude": longitude,
    };
  }
}
