# MYRA — Android AI Voice Assistant 🎤

**Production-ready AI voice companion app** built with **Kotlin + Gemini Live WebSocket**.

## 🎯 Features

✅ **Gemini Live WebSocket** — Real-time voice AI via native audio streaming  
✅ **Native PCM Audio** — 16kHz mic input, 24kHz speaker output  
✅ **Personality Modes** — GF/Professional/Assistant with Hinglish support  
✅ **Voice Options** — 8 prebuilt voices (Aoede, Charon, Kore, Fenrir, Puck, Leda, Orus, Zephyr)  
✅ **Animated Orb UI** — 7-layer canvas animation with state-based visual feedback  
✅ **Phone Integration** — Call detection, incoming call announcements, SMS/WhatsApp  
✅ **Command Parsing** — Hinglish + English voice commands → app actions  
✅ **Prime Contacts** — Multiple quick-dial contacts with voice commands  
✅ **Overlay Service** — Floating orb on home screen (double power button)  
✅ **Accessibility Service** — App automation, click, type, scroll  
✅ **Settings UI** — API key, model, voice, personality, prime contacts  

## 🚀 Quick Start

### Prerequisites
- **Android Studio** (latest)
- **Kotlin** 1.9+
- **Gradle** 8.x
- **Google Gemini API Key** (get from [AI Studio](https://aistudio.google.com))
- **Min SDK 26** (Android 8.0), **Target SDK 34**

### Setup

1. **Clone the repo:**
   ```bash
   git clone https://github.com/thezeeshan000/myra-ai-voice-assistant.git
   cd myra-ai-voice-assistant
   ```

2. **Open in Android Studio:**
   - File → Open → select repo folder
   - Let Gradle sync

3. **Build & Run:**
   ```bash
   ./gradlew build
   ./gradlew installDebug
   ```

4. **First Launch:**
   - Grant all permissions (mic, contacts, phone, camera, etc.)
   - Go to **Settings**
   - Paste your **Gemini API Key**
   - Enter your **Name**
   - Select **AI Model**, **Voice**, **Personality**
   - Enable **Accessibility Service** (tap the accessibility status)
   - Tap **SAVE** → restart app

5. **Test:**
   - App greets you in native voice
   - Say: "YouTube kholo" → YouTube opens
   - Say: "call [contact name]" → call initiated
   - Long press mic → MYRA stops speaking
   - Double press power button → overlay orb appears

## 📁 Project Structure

```
app/src/main/
├── java/com/myra/assistant/
│   ├── ai/
│   │   ├── GeminiLiveClient.kt      ← WebSocket, session renewal, keepalive
│   │   ├── AudioEngine.kt           ← AudioRecord (16kHz) + AudioTrack (24kHz)
│   │   └── CommandParser.kt         ← Voice text → AppCommand
│   ├── model/
│   │   └── AppCommand.kt            ← data class for commands
│   ├── service/
│   │   ├── AccessibilityHelperService.kt
│   │   ├── CallMonitorService.kt
│   │   ├── MyraOverlayService.kt
│   │   ├── PowerButtonReceiver.kt
│   │   └── BootReceiver.kt
│   ├── ui/
│   │   ├── main/
│   │   │   ├── MainActivity.kt
│   │   │   ├── OrbAnimationView.kt  ← Custom Canvas orb
│   │   │   └── UiComponents.kt      ← WaveformView, ChatAdapter
│   │   └── settings/
│   │       └── SettingsActivity.kt
│   ├── viewmodel/
│   │   └── MainViewModel.kt         ← Phone actions, prime contacts
│   └── MyraApp.kt                   ← Application class
└── res/
    ├── layout/
    ├── drawable/
    ├── values/
    └── xml/
```

## 🎙️ Voice Commands

| Command | Action |
|---------|--------|
| "YouTube kholo" | Open YouTube |
| "[Name] ko call karo" | Call contact |
| "[Name] ko message karo" | Send SMS |
| "close friend ko call karo" | Call prime contact #0 |
| "meri jaan ko message karo" | Message prime contact #0 |
| "volume badhao" | Volume up |
| "WiFi on/off" | Toggle WiFi |
| "torch on" | Flashlight on |

## ⚙️ Architecture

**MVVM Pattern:**
- **ViewModel** → `MainViewModel.kt` (phone actions, contact lookup)
- **LiveData** → `commandResult`, observables
- **Repository** → `SharedPreferences` (user prefs, prime contacts)
- **View** → MainActivity, SettingsActivity

**WebSocket Flow:**
```
GeminiLiveClient (WebSocket) → setup message (model, voice, system prompt)
                             → send mic audio (16kHz PCM)
                             → receive speaker audio (24kHz PCM) → AudioEngine
                             → transcript buffers → ChatAdapter
```

**Audio Pipeline:**
```
Microphone (16kHz) → AudioRecord → RMS calculation → waveform animation
                  → CommandParser (if no MYRA speaking)
                  → send to Gemini via WebSocket

Gemini Response (24kHz PCM) → AudioEngine queue → AudioTrack → Speaker
                            → orb animation (state=SPEAKING)
```

## 🔧 Build & Deploy

### Local APK Build
```bash
./gradlew clean
./gradlew build
# APK: app/build/outputs/apk/debug/app-debug.apk
```

### GitHub Actions (Automatic)
On every push to `main`, `.github/workflows/build_apk.yml` automatically:
1. Checks out code
2. Sets up Android SDK
3. Builds release APK
4. Uploads to GitHub Actions artifacts

Download APK from: **Actions → Latest Run → Artifacts → app-release.apk**

## 🔐 Permissions

**Dangerous Permissions (request at runtime):**
- `RECORD_AUDIO` — Microphone
- `READ_CONTACTS` — Contact lookup
- `CALL_PHONE` — Make calls
- `SEND_SMS` — Send SMS
- `READ_PHONE_STATE` — Incoming call detection
- `ANSWER_PHONE_CALLS` — Accept/reject calls
- `CAMERA` — Flashlight

**System Permissions:**
- `INTERNET` — Gemini WebSocket
- `SYSTEM_ALERT_WINDOW` — Overlay orb
- `FOREGROUND_SERVICE` — Services
- `MODIFY_AUDIO_SETTINGS` — Volume control

**Accessibility Service:**
- Must be enabled manually in Settings → Accessibility

## 🎨 UI Theme

**Colors:**
- **Primary:** `#FF1744` (red)
- **Secondary:** `#D500F9` (purple)
- **Background:** `#050505` (dark)
- **Text:** `#EEEEEE` (light grey)

**Components:**
- Dark futuristic theme
- Rounded corners (16dp)
- Monospace font for stats (time, battery, RAM)
- Red overlay fade when MYRA speaks

## 📊 Status Bar

Top bar shows:
- Left: Battery %, RAM usage
- Center: "MYRA" logo + "AI COMPANION"
- Right: Time (HH:MM), Settings button

## 🎯 Orb Animation States

| State | Visual |
|-------|--------|
| **IDLE** | Slow pulse, glow, red-purple colors |
| **LISTENING** | Rotation rings + wave rings, red |
| **SPEAKING** | Purple color, fast waves, particles orbiting |
| **THINKING** | Cyan spinning arc (loading) |
| **ACTIVE** | All rings rotating, particles orbiting |

## 🐛 Troubleshooting

**App crashes on startup:**
- Check API key is set in Settings
- Ensure all permissions granted
- Check internet connection

**No microphone input:**
- Grant `RECORD_AUDIO` permission
- Check device mic isn't muted

**Commands not executing:**
- Enable Accessibility Service (Settings → Accessibility)
- Check command text matches parser patterns
- View logs: `adb logcat | grep GeminiLiveClient`

**Overlay not appearing:**
- Enable `SYSTEM_ALERT_WINDOW` permission (Settings → Apps)
- Double press power button within 600ms

## 📝 Configuration

**SharedPreferences keys:**
```kotlin
api_key              // Gemini API key
user_name            // User's name
gemini_model         // Model string
gemini_voice         // Voice name (Aoede, etc.)
personality_mode     // GF, Professional, Assistant
prime_contacts_json  // JSON array of prime contacts
```

## 🔗 API References

- [Gemini Live API](https://ai.google.dev/docs/gemini_api_spec)
- [Android Media](https://developer.android.com/reference/android/media)
- [Android Accessibility](https://developer.android.com/guide/topics/ui/accessibility)
- [OkHttp WebSocket](https://square.github.io/okhttp/)

## 📄 License

MIT License — Free for personal & educational use.

## 👤 Author

**Zeeshan** — [@thezeeshan000](https://github.com/thezeeshan000)

---

**MYRA v1.0** — *Your AI Voice Companion* 💖
