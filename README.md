# Healofy Flutter App

A modern Flutter application featuring video content with advanced playback controls and visibility detection.

## ✨ Features

- **📱 Multi-Platform Support**: iOS, Android, Web, and Desktop
- **🎥 Smart Video Player**: Auto-play with visibility detection
- **🔄 Horizontal Video Reviews**: Instagram-style video scrolling
- **⚡ Performance Optimized**: Only visible videos play to save battery
- **🎨 Modern UI**: Clean, responsive design with custom styling
- **📊 GetX State Management**: Efficient state management and API integration

## 🚀 Key Components

- **Video Reviews Section**: Horizontal scrolling videos with auto-play
- **Visibility Detection**: Uses `VisibilityDetector` for precise playback control
- **Custom Video Player**: Enhanced video player with thumbnail support
- **API Integration**: Dynamic content loading from remote API
- **Responsive Design**: Adapts to different screen sizes

## 📦 Dependencies

- `flutter`: SDK
- `video_player`: Video playback functionality  
- `get`: State management and routing
- `cached_network_image`: Image caching and loading
- `visibility_detector`: Viewport visibility detection
- `http`: API communication

## 🛠️ Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/anubhavmishra77/healofy.git
   cd healofy
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 📱 Supported Platforms

- ✅ iOS
- ✅ Android  
- ✅ Web
- ✅ macOS
- ✅ Windows
- ✅ Linux

## 🎯 Architecture

- **MVC Pattern**: Clean separation of concerns
- **GetX Bindings**: Dependency injection and lifecycle management
- **Modular Structure**: Organized codebase with clear separation

## 📂 Project Structure

```
lib/
├── bindings/          # GetX bindings
├── controllers/       # Business logic controllers
├── models/           # Data models and API responses
├── services/         # API services and data sources
├── utils/           # Utilities and constants
├── views/           # UI screens and pages
└── widgets/         # Reusable UI components
```

---

**Built with Flutter 💙**
