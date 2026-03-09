# voice_solar
hackathon project

## Configure Permissions (For Voice Input)

The app uses the device microphone for the AI agent.

* **macOS (Testing locally as a desktop app):** Ensure you grant Microphone permissions if prompted by macOS when you click the microphone icon.
* **iOS:** Ensure keys are listed in `ios/Runner/Info.plist`.
* **Android:** Ensure `<uses-permission android:name="android.permission.RECORD_AUDIO"/>` is in `android/app/src/main/AndroidManifest.xml`.
* **Windows (Testing locally as a desktop app):** Ensure your application has permission to access the microphone. 
  1. Open the Windows **Settings** app
  2. Navigate to **Privacy & security** > **Microphone** 
  3. Ensure "Microphone access" and "Let desktop apps access your microphone" are both toggled to **On**.
