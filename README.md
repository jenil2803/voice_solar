# Voice Solar ☀️

**Voice Solar** is an intelligent solar plant monitoring system that transforms raw sensor data into actionable insights using AI. Built for the **HakaMined Hackathon 2026**, it demonstrates the power of AI in renewable energy management.

## 🚀 Features

- **AI-Powered Insights**: Analyzes plant performance and generates natural language summaries
- **Real-Time Monitoring**: Tracks key metrics like power generation, voltage, and current
- **Smart Alerts**: Detects anomalies and notifies users of potential issues
- **Voice-Enabled**: Future-ready for voice command integration
- **Modern UI**: Clean, responsive interface with dark mode support

## 🛠️ Tech Stack

### Backend
- **Framework**: FastAPI
- **Database**: MongoDB (via Motor)
- **AI**: Custom Python logic for data analysis

### Frontend
- **Framework**: Flutter
- **State Management**: Riverpod
- **Routing**: GoRouter
- **HTTP**: Dio

## 📂 Project Structure

```
voice_solar/
├── Backend/              # FastAPI backend services
│   ├── main.py           # API entry point
│   ├── services/         # Business logic
│   └── models/           # Data models
├── cook/                 # Flutter frontend
│   ├── lib/
│   │   ├── pages/        # UI screens
│   │   ├── services/     # API clients
│   │   └── widgets/      # Reusable components
│   └── pubspec.yaml      # Dependencies
└── README.md             # Project documentation
```

## 🔌 API Endpoints

### Authentication
- `POST /user/login/` - User login
- `POST /user/register/` - User registration

### Dashboard
- `GET /dashboard?period={period}` - Get plant performance data

### Inverters
- `GET /inverters/` - List all inverters
- `GET /inverters/{id}/` - Get inverter details

### Sensors
- `GET /sensors/` - List all sensors
- `GET /sensors/{id}/` - Get sensor details

## 🏃 Getting Started

### Prerequisites
- Python 3.8+
- Flutter 3.0+
- MongoDB instance

### Configure Permissions (For Voice Input)
The app uses the device microphone for the AI agent.
* **macOS (Testing locally as a desktop app):** Ensure you grant Microphone permissions if prompted by macOS when you click the microphone icon.
* **iOS:** Ensure keys are listed in `ios/Runner/Info.plist`.
* **Android:** Ensure `<uses-permission android:name="android.permission.RECORD_AUDIO"/>` is in `android/app/src/main/AndroidManifest.xml`.
* **Windows (Testing locally as a desktop app):** Ensure your application has permission to access the microphone. 
  1. Open the Windows **Settings** app
  2. Navigate to **Privacy & security** > **Microphone** 
  3. Ensure "Microphone access" and "Let desktop apps access your microphone" are both toggled to **On**.

### Backend Setup

1. Navigate to the backend directory:
   ```bash
   cd Backend
   ```

2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

3. Run the server:
   ```bash
   uvicorn main:app --reload
   ```

### Frontend Setup

1. Navigate to the frontend directory:
   ```bash
   cd cook
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the application:
   ```bash
   flutter run
   ```
