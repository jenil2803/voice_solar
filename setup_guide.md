# Voice Solar — Project Setup Guide

This guide provides step-by-step instructions to set up and run the Voice Solar project locally without encountering errors. The project consists of a Python FastAPI backend and a Flutter frontend.

---

## Prerequisites

Before starting, ensure you have the following installed on your system:
1. **Python 3.9+**
2. **Flutter SDK** (Version 3.19.0 or higher recommended)
3. **Git**
4. An active **MongoDB Atlas** account (if using your own database) or access to the provided cluster.
5. An **OpenRouter API Key** or **Google Gemini API Key** for the AI Agent features.

---

## 1. Backend Setup (FastAPI)

The backend manages the AI Agent logic and connects to the MongoDB database.

### Step 1.1: Clone the Repository
```bash
git clone <repository_url>
cd voice_solar/Backend
```

### Step 1.2: Set Up the Virtual Environment
It is highly recommended to use a virtual environment to avoid dependency conflicts. We strongly recommend using **Python 3.9**.

```bash
# Remove any existing venv if pulling from a different OS
rm -rf venv

# Create a new virtual environment
python3 -m venv venv

# Activate the virtual environment
# On macOS/Linux:
source venv/bin/activate
# On Windows:
# venv\Scripts\activate
```

### Step 1.3: Install Dependencies
```bash
pip install --upgrade pip
pip install -r requirements.txt
```

### Step 1.4: Configure Environment Variables
Create a `.env` file in the `Backend/` directory:

```env
# Example .env file
GEMINI_API_KEY=your_google_gemini_api_key_here
OPENROUTER_API_KEY=your_openrouter_api_key_here
```
*(Note: The database connection URL is currently handled in `config/database.py`. If you are using your own DB, update `MONGO_URL` there).*

### 🔴 CRITICAL STEP: MongoDB IP Whitelist
If you encounter a `[SSL: TLSV1_ALERT_INTERNAL_ERROR]` or `ServerSelectionTimeoutError` when starting the backend, **MongoDB Atlas is blocking your IP address.**

1. Log in to [MongoDB Atlas](https://cloud.mongodb.com/).
2. Navigate to **Security > Network Access** on the left menu.
3. Click **+ Add IP Address**.
4. Click **Add Current IP Address** (or allow `0.0.0.0/0` for testing purposes).
5. Click **Confirm** and wait 1–2 minutes for the status to turn "Active".

### Step 1.5: Run the Backend Server
```bash
uvicorn main:app --reload
```
The backend should now be running at `http://127.0.0.1:8000`. Leave this terminal process running.

---

## 2. Frontend Setup (Flutter)

The frontend is a Flutter application that interacts with the user via text and voice commands.

### Step 2.1: Navigate to the Frontend Directory
Open a *new* terminal window/tab:
```bash
cd voice_solar/cook
```

### Step 2.2: Install Dependencies
```bash
flutter clean
flutter pub get
```

### Step 2.3: Configure Permissions (For Voice Input)
The app uses the device microphone for the AI agent.

- **macOS (Testing locally as a desktop app):**
  Ensure you grant Microphone permissions if prompted by macOS when you click the microphone icon.
- **iOS:** Ensure `NSMicrophoneUsageDescription` and `NSSpeechRecognitionUsageDescription` are listed in `ios/Runner/Info.plist`.
- **Android:** Ensure `<uses-permission android:name="android.permission.RECORD_AUDIO"/>` is in `android/app/src/main/AndroidManifest.xml`.

### Step 2.4: Run the Application
You can run the app on macOS, iOS Simulator, Android Emulator, or Chrome:

```bash
flutter run
```
*Select your desired target device when prompted by flutter.*

---

## 3. Testing the Application

1. Once the Flutter app launches, click the **AI Assistant** (sparkle icon) button to open the agent dialog.
2. Click the **Microphone icon** to allow permissions and start speaking, e.g., *"Show me inverter 3"*.
3. The app will capture your voice, send the command to the local FastAPI backend on port `8000`, process the intent via the LLM, and navigate to the deep-linked detail page.

---

## Troubleshooting Common Errors

| Error Message | Cause | Solution |
| :--- | :--- | :--- |
| `[Errno 48] Address already in use` | Port 8000 is occupied. | Run `lsof -i :8000` to find the PID, then `kill -9 <PID>` to stop the old server. |
| `SSL handshake failed` / `TLSV1_ALERT_INTERNAL_ERROR` | IP not allowed by Database. | Add your current Wi-Fi IP to the MongoDB Atlas Network Access whitelist. |
| `ModuleNotFoundError: No module named 'motor'` | Virtual environment not activated. | Ensure you run `source venv/bin/activate` *before* running `uvicorn main:app`. |
| `Failed host lookup: 'pub.dev'` | Local DNS or internet issue. | Check your internet connection or restart the terminal; DNS resolution failed temporarily. |
