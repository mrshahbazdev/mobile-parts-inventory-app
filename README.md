# Mobile Parts Inventory App

**Free Mobile Parts Inventory Management System | Flutter Android App with Offline Database**

A comprehensive, offline-first Flutter application for mobile phone repair shops and parts dealers to efficiently manage inventory, track stock levels, organize parts by categories, and backup data. Built with SQLite for robust offline performance on Android and Windows.

**Keywords**: Mobile parts inventory, phone repair shop app, inventory management system, Flutter inventory app, offline inventory tracker, mobile parts database, stock management, Android inventory app, parts catalog, repair shop software

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
