# FieldOps

A mobile field task management application that allows users to view assigned tasks, update task status, capture completion evidence, and submit location data.

## Features

- User authentication with JWT
- Persistent login session using secure storage
- View assigned tasks
- Start and complete tasks
- Capture images using device camera
- Collect GPS coordinates during task completion
- Upload task completion data using multipart requests
- Image compression before upload

## Tech Stack

### Frontend
- Flutter
- Dart
- Provider (State Management)
- Dio (HTTP Client)
- Flutter Secure Storage
- Camera Plugin
- Geolocator

### Backend
- Node.js
- Express.js
- JWT Authentication
- Multer (File Upload Handling)

## Project Structure

### Frontend

lib/
├── models/
├── providers/
├── repositories/
├── services/
├── screens/
└── core/


### Backend

backend/
├── controllers/
├── routes/
├── middleware/
├── data/
└── uploads/



## Running the Project

### Backend

Navigate to backend:

```bash
cd backend

Install dependencies:
npm install

Start server:
npm start

The server runs on:

http://localhost:3000


Flutter

Install packages:
flutter pub get

Run application:
flutter run

Android Local Development
When running the backend locally with a physical Android device:
adb reverse tcp:3000 tcp:3000

Notes
The backend currently stores active tokens in memory for session validation.
Restarting the backend clears active sessions.

Environment or .env variables:
PORT=3000
JWT_SECRET=my_fieldops_secret