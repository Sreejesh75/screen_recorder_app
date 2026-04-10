<p align="center">
  <img src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/Hive-%23FFCA28.svg?style=for-the-badge&logo=databricks&logoColor=black" alt="Hive" />
</p>

# Screen Recorder Pro 🎥

A professional, feature-rich screen and audio recording application built with Flutter. Designed with a clean architecture pattern, this application demonstrates enterprise-level state management, local database persistence, seamless native hardware integrations, and premium UX/UI interactions.

## 🌟 Key Features

* **High-Quality Screen & Audio Capture**: Natively harnesses the device's hardware encoder and microphone to strictly capture synchronized `.mp4` recordings.
* **Robust State Management**: Powered heavily by `flutter_bloc` to strictly control asynchronous stream states (Recording, Paused, Error, Uploading, Success).
* **Local Database Persistence (Hive)**: Stores your complete video history safely via a highly optimized NoSQL `hive` database ensuring instant load-times effortlessly.
* **Full CRUD & Storage Management**: Automatically manages device memory securely by physically destroying legacy video files straight from internal storage when a user taps 'Delete'.
* **Cross-Application Sharing**: Features native iOS/Android System Intent Share-Sheets (`share_plus`) that allows immediate `.mp4` sharing to external apps like WhatsApp, Telegram, or Gmail.
* **API Network Integration**: Silently handles dummy `multipart/form-data` logic using `dio` to upload recorded files to a remote webhook, including robust fallback mitigation for simulated `413 Payload Too Large` restrictions.
* **Premium UX & Micro-interactions**: Utilizes glassmorphism, dynamic animations, `Lottie` animations for confirmation dialogs, System Click Audio, and massive tactile `HapticFeedback` for physical responses.
* **Strict Permission Handling**: Employs `permission_handler` to properly request run-time Sandbox boundaries ensuring `RECORD_AUDIO` functions fluently under extreme Android 14 conditions.

---

## 🏗️ Architecture & Tech Stack

This project was built following a **Feature-First / Clean Architecture** approach to guarantee modularity and horizontal scalability.

* **Frontend Framework**: Flutter (Dart)
* **State Management**: `flutter_bloc`
* **Local Storage / DB**: `hive` & `hive_flutter`
* **Networking**: `dio`
* **Core Integrations**:
  * `flutter_screen_recording` (Video generation algorithm)
  * `share_plus` (Native system sharing)
  * `permission_handler` (OS security boundaries)
  * `lottie` (Vector animations)
  * `video_player` (Native playback parsing)

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>= 3.0.0)
- Android Studio / Xcode

### Installation
1. Clone the repository
   ```bash
   git clone <your-repository-url>
   ```
2. Fetch dependencies
   ```bash
   flutter pub get
   ```
3. Boot the application
   ```bash
   flutter run
   ```

*(Note for Android 14 Developers: Background processes running MediaProjection inherently require explicit runtime notification permission declarations inside modern manifest setups—all of which have been configured in this build.)*

---

## 📱 Screenshots & Demo

*(Optional: Add your screenshots here to show off the beautiful UI and Lottie animations on GitHub!)*
- `assets/images/logo_dart.png` has been implemented natively as the App Icon using `flutter_launcher_icons`.

---

## 📂 Folder Structure

This project employs a robust **Feature-First** approach layered over Clean Architecture principles:

```text
lib/
 ├── core/
 │    ├── constants/       # App-wide constants (colors, strings, paths)
 │    ├── network/         # Dio client config and interceptors
 │    ├── services/        # Third-party integrations (Hive, Permissions)
 │    └── theme/           # Global typography and styling
 ├── features/
 │    └── recorder/        
 │         ├── bloc/       # Business Logic Components (Events, States)
 │         ├── data/       # Repositories and Local/Remote data sources
 │         └── presentation/ # UI Screens, Widgets, and Lottie assets
 └── main.dart             # App entry point & dependency injection
```

---

## 🗺️ Roadmap / Future Ideas

- [ ] **Video Trimming & Editing**: Add a post-recording timeline to clip standard formats natively.
- [ ] **Custom Watermarks**: Allow users to append personalized images/text transparently over the footage.
- [ ] **Picture-in-Picture (PiP) Camera**: Show the native selfie camera overlay above the screen while recording.
- [ ] **Cloud Sync (Firebase/AWS)**: Optional secure cloud backup beyond the current Webhook logic.
- [ ] **Adjustable Bitrates & FPS**: A robust settings panel granting more control to professional content creators.

---

✨ *Built to showcase Senior-Level production standards in Flutter development.*
