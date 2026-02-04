# Mobile Parts Inventory App

A comprehensive Flutter application for managing mobile parts inventory, sales, and backups.

## 📱 Download APK
**Can't wait to try it?**
Download the latest Android release directly from this repository:
👉 **[Download app-release.apk](releases/app-release.apk)**

---

## 🚀 Features
- **Dashboard**: Professional stats overview (Total Parts, Category Value, Low Stock).
- **Inventory Management**: Add, edit, delete, and search mobile parts.
- **Categorization**: Organize parts by categories (Folders/Glass/Charging/etc).
- **Backup & Restore**: Securely export your database and restore it anytime.
- **Offline Support**: Built on SQLite for robust offline performance.

## 🛠️ Installation (For Developers)

### 1. Prerequisities
- [Flutter SDK](https://flutter.dev/docs/get-started/install) installed.
- Android device or emulator.

### 2. Clone the Repository
```bash
git clone https://github.com/mrshahbazdev/mobile-parts-inventory-app.git
cd mobile-parts-inventory-app
```

### 3. Install Dependencies
```bash
flutter pub get
```

### 4. Run the App
```bash
# For Windows
flutter run -d windows

# For Android
flutter run -d android
```

### 5. Build Release APK
```bash
# Note: Requires NDK configuration
$env:ANDROID_NDK_HOME="$env:LOCALAPPDATA\Android\Sdk\ndk\28.2.13676358"
flutter build apk --release
```

---
**Powered by Muhammad Shahbaz**
