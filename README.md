# Image to PDF Converter

> **Your images. One perfect PDF.**  
> Create professional PDFs from your images. Simple, secure, and completely free.

![100% Free](https://img.shields.io/badge/Price-100%25%20Free-success)
![No Ads](https://img.shields.io/badge/Ads-None-brightgreen)
![100% Offline](https://img.shields.io/badge/Offline-100%25%20Local-red)
![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)

---

## 🎨 Visual Identity & Design System

Inspired by the visual design language of **Adobe Acrobat** and **iLovePDF**, this application features a clean, trustworthy, premium white interface accented with professional PDF red.

| Token | Hex Value | Usage |
| :--- | :--- | :--- |
| **Primary Red** | `#E5322D` | Primary action buttons, badges, key conversion CTAs |
| **Primary Dark Red** | `#C72824` | Active accents, document icon fold |
| **Primary Light Red** | `#FDECEB` | Page count pills, highlighted selections |
| **Main Background** | `#FFFFFF` | Core screen backgrounds (White theme strictly) |
| **Secondary Background** | `#F7F7F7` | Cards, toolbars, modal sheets |
| **Main Typography** | `#242424` | Primary titles, readable text |
| **Secondary Typography** | `#777777` | Captions, file sizes, timestamps |
| **Borders & Dividers** | `#EAEAEA` | Subtle boundaries & separators |

> **Design Rule**: No dark theme in V1.0. No neon gradients, no blue light themes, no glassmorphism. Crisp, clear, professional document utility design.

---

## 🛡️ Core Principles & Privacy Guarantee

- **100% Free**: No subscriptions, no in-app purchases, no locked features.
- **No Advertisements**: Zero AdMob, zero tracking scripts, zero promotional popups.
- **100% Offline**: All image processing, rotation, compression, and PDF generation happen directly on your device CPU.
- **Zero Internet Permissions**: The Android manifest does not request internet access (`android.permission.INTERNET` is omitted). Your documents never leave your phone.
- **No Mandatory Login**: Open the app and start converting immediately.
- **Open Source**: MIT Licensed for complete transparency and public trust.

---

## ✨ Features

- **Batch Image Selection**: Select multiple images from device storage or snap pages using the camera.
- **Reordering & Page Organization**: Easily rearrange page order (move up / down / reorder).
- **Per-Page Rotation**: Rotate any page 90°, 180°, or 270° clockwise with instant visual preview.
- **Page Format Selection**:
  - `A4 (Standard)`
  - `US Letter`
  - `US Legal`
  - `Fit to Image` (keeps original photo dimensions)
- **Orientation Modes**: `Portrait`, `Landscape`, or `Auto Match`.
- **Page Margins**: `No Margin (0mm)`, `Small (10mm)`, or `Standard (20mm)`.
- **Smart Compression**:
  - `Original (100% Quality)`
  - `High (85% Quality)`
  - `Medium (65% Quality - Recommended)`
  - `Compact (45% Quality - Smallest Size)`
- **Grayscale / B&W Mode**: Converts color photos to crisp black-and-white documents (great for receipts & legal papers).
- **Page Numbers**: Add clean "Page X of Y" pagination at the bottom of each page.
- **Live In-App PDF Preview**: Interactive multi-page swipe, zoom, and inspection.
- **Export, Print & Share**: Export to local storage, native system share sheet, or physical printer.
- **Local History**: View recent conversions with page count and file size details.

---

## 🚀 Building & Running Locally

### Prerequisites
- [Flutter SDK](https://flutter.dev) (v3.20.0 or later)
- Android SDK (for Android APK / Bundle) or Visual Studio (for Windows Desktop) or Google Chrome (for Web)

### Getting Started
```bash
# Clone the repository
git clone https://github.com/your-username/img-to-pdf-app.git
cd img-to-pdf-app

# Install dependencies
flutter pub get

# Run tests
flutter test

# Run application
flutter run
```

### Build Release APK
```bash
flutter build apk --release
```

---

## 👨‍💻 Developed By

**AP Programming Tech™**  
*Created with care by AP Programming Tech.*

**Our Mission**: To provide everyone with a simple, reliable, and completely free PDF conversion experience.

---

## 📄 License & Trademark

© 2026 AP Programming Tech. All rights reserved.

This open source project is licensed under the [MIT License](LICENSE).
