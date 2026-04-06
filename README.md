# Wallify

🖼️ **Wallify** is a Flutter wallpaper app powered by the Wallhaven API.  
It lets you browse wallpapers, explore categories, save favourites, preview images in fullscreen, share wallpapers, and download them on supported platforms.

## 🧭 What the App Does

Wallify is a wallpaper discovery app with three main sections:

- 🏠 **Home tab**: shows the main wallpaper feed from Wallhaven
- 🗂️ **Category tab**: lets users browse preset categories or search with a custom keyword
- ❤️ **Favourite tab**: stores wallpapers the user saves locally for quick access later

From any wallpaper, users can open a detail screen, preview it in fullscreen, download it, share it, and on Android set it as wallpaper.

## ✨ Features

- 🔎 Browse wallpapers from Wallhaven
- 🗂️ Explore wallpapers by category
- ❤️ Save wallpapers to favourites
- 🔍 Open wallpapers in fullscreen with zoom
- 📥 Download wallpapers locally
- 🖥️ Desktop-friendly layouts for macOS and Windows

## 📱 Supported Platforms

| Platform | Support | Notes |
| --- | --- | --- |
| Android | ✅ | Supports wallpaper setting and downloading |
| iOS | ✅ | Mobile UI supported |
| macOS | ✅ | Desktop UI supported |
| Windows | ✅ | Desktop UI supported |

## ⚠️ Important Notes

- 🧱 Wallpaper setting currently works on **Android only**
- 💾 On **macOS** and **Windows**, wallpapers are downloaded and saved locally
- 🌐 The app needs internet access because wallpapers are fetched from Wallhaven

## 🛠️ Tech Stack

- Flutter
- Provider
- GoRouter
- cached_network_image
- flutter_staggered_grid_view
- connectivity_plus
- share_plus
- shared_preferences

## 📂 Project Structure

```text
lib/
  data/                 API layer and models
  infrastructure/       theme, navigation, constants, utilities
  presentation/         screens, widgets, view models
android/                Android runner
ios/                    iOS runner
macos/                  macOS runner
windows/                Windows runner
```

## 🚀 Getting Started

If you are new to Flutter, follow these steps carefully.

### 1. Install Flutter

Install Flutter from the official website:

https://docs.flutter.dev/get-started/install

After installing, confirm it works:

```bash
flutter --version
```

### 2. Open the Project

Go to the project folder:

```bash
cd /path/to/wallify
```

### 3. Install Project Dependencies

Run:

```bash
flutter pub get
```

This downloads all the packages the app needs.

## ▶️ Run the App

### 🤖 Run on Android

Requirements:
- Android Studio installed, or Android SDK tools installed
- An emulator running, or a real Android phone connected

Check devices:

```bash
flutter devices
```

Run the app:

```bash
flutter run -d android
```

If that does not work, use the exact device name shown by `flutter devices`.

### 🍎 Run on iOS

Requirements:
- A Mac
- Xcode installed
- iPhone Simulator or a real iPhone connected

Run:

```bash
flutter run -d ios
```

### 🖥️ Run on macOS

Requirements:
- A Mac
- Xcode installed
- macOS desktop support enabled in Flutter

Enable macOS support if needed:

```bash
flutter config --enable-macos-desktop
```

Run:

```bash
flutter run -d macos
```

### 🪟 Run on Windows

Requirements:
- A Windows machine
- Visual Studio installed
- In Visual Studio, install the **Desktop development with C++** workload

Enable Windows desktop support if needed:

```bash
flutter config --enable-windows-desktop
```

Run:

```bash
flutter run -d windows
```

## 📦 Build the App

These commands create installable or distributable builds.

### 🤖 Build Android APK

Use this if you want a `.apk` file you can install on an Android phone.

```bash
flutter build apk
```

Output is usually created under:

```text
build/app/outputs/flutter-apk/
```

### 🤖 Build Android App Bundle

Use this if you want to upload the app to the Google Play Store.

```bash
flutter build appbundle
```

Output is usually created under:

```text
build/app/outputs/bundle/release/
```

### 🍎 Build iOS

Use this when preparing an iPhone build.

```bash
flutter build ios
```

Then you usually continue in Xcode for signing and archive/export steps.

### 🖥️ Build macOS

Use this to create a desktop macOS build.

```bash
flutter build macos
```

Output is usually created under:

```text
build/macos/Build/Products/Release/
```

### 🪟 Build Windows

Use this to create a Windows desktop build.

```bash
flutter build windows
```

Output is usually created under:

```text
build/windows/x64/runner/Release/
```

## 🧹 Useful Commands

### Clean the project

If things break strangely, try:

```bash
flutter clean
flutter pub get
```

### Check for code issues

```bash
flutter analyze
```

### Run tests

```bash
flutter test
```

## 📝 Development Notes

- 🌍 Wallpapers are fetched from the Wallhaven search API
- ❤️ Favourites are stored locally using `shared_preferences`
- 💻 Desktop download behavior is platform-aware
- 🔐 macOS sandbox permissions can affect file access and networking during development

## 📄 License

🔒 Private project. Not published to pub.dev.
