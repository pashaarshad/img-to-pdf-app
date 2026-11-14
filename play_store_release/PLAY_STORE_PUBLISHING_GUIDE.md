# Google Play Store Publishing Guide

**App Name**: Image to PDF Converter  
**Package Name**: `com.approgrammingtech.imgtopdf`  
**Developer**: AP Programming Tech™  
**Version**: 1.0.0 (Version Code: 1)  
**Bundle File**: `ImageToPdf_v1.0.0_release.aab`  

---

## 1. Release Files & Location

Everything you need for publishing is prepared in the `play_store_release/` directory:

| File | Purpose |
| :--- | :--- |
| `ImageToPdf_v1.0.0_release.aab` | The signed production App Bundle to upload to Google Play Console. |
| `upload-keystore.jks` | Your private release upload keystore (keep this safe!). |
| `KEYSTORE_CREDENTIALS.txt` | Key alias, store password, and algorithm reference. |

---

## 2. Store Listing Information

You can copy and paste these pre-formatted descriptions directly into Google Play Console:

### App Title (max 30 characters)
```
Image to PDF Converter
```

### Short Description (max 80 characters)
```
Convert photos to PDF offline. 100% free, private & fast with zero ads.
```

### Full Description (max 4000 characters)
```
Image to PDF Converter by AP Programming Tech is a powerful, lightweight, and 100% privacy-focused utility designed to convert your pictures, scans, receipts, and photos into high-quality PDF documents.

Your images. One perfect PDF.

100% FREE & PRIVATE
• Completely free: No subscriptions, no hidden fees, no feature paywalls.
• Zero Ads: Enjoy a clean, distraction-free interface without advertisements or popups.
• 100% Offline: All image processing and PDF creation happen directly on your device CPU. No internet connection is needed and your files never leave your phone.
• No Account Required: Open the app and start converting immediately—no login or registration.

KEY FEATURES
• Multi-Image Selection: Pick multiple photos from your gallery or capture documents with your camera.
• Page Reordering: Easily rearrange page order with move up/down controls.
• 90° Page Rotation: Rotate individual pages or all pages clockwise for the ideal orientation.
• Standard Page Formats: Choose from A4 (Standard), US Letter, US Legal, or Fit to Image.
• Flexible Orientations: Portrait, Landscape, or Auto Match based on your picture dimensions.
• Custom Margins: No Margin (0mm), Small Margin (10mm), or Standard (20mm).
• Quality & Compression Control: Choose Original (100%), High (85%), Medium (65%), or Compact (45%) to optimize file size.
• Grayscale / Black & White Mode: Convert color photos into crisp monochrome documents—perfect for receipts, contracts, and notes.
• Page Numbers: Add clean "Page X of Y" pagination at the bottom of every page.
• Interactive PDF Viewer: Zoom, inspect, and review your multi-page PDF before saving.
• Easy Sharing & Printing: Share directly to WhatsApp, Gmail, Drive, or print wirelessly with one tap.
• Local History: Access and manage previously converted PDFs offline on your device.

ABOUT THE DEVELOPER
Developed with care by AP Programming Tech™.
Our mission is to provide everyone with a simple, reliable, and genuinely free PDF conversion experience.

Open Source Project – MIT License.
© 2026 AP Programming Tech. All rights reserved.
```

---

## 3. Play Console Policy & Content Declarations

When filling out the **Policy > App content** section in Google Play Console, select these exact answers:

1. **Privacy Policy**:
   - Provide a URL hosting your privacy notice (or GitHub repository README link).
   - Key point: App does not collect, transmit, or share any user data.
2. **Ads**:
   - Select: **"No, my app does not contain ads"**.
3. **App Access**:
   - Select: **"All functionality is available without restrictions"** (no login required).
4. **Target Audience and Content**:
   - Target age: **13 and older** (or 18+ depending on preference).
5. **Data Safety Form**:
   - Does your app collect or share user data? Select: **"No"**.
   - (All PDF processing is 100% on-device).
6. **Financial Features**:
   - Select: **"My app does not provide any financial features"**.
7. **Category & Tags**:
   - Category: **Productivity** / **Tools**.
   - Tags: *PDF, Productivity, Tools, Scanner, Converter*.

---

## 4. Uploading the App Bundle (.AAB)

1. Sign in to [Google Play Console](https://play.google.com/console).
2. Click **Create app**:
   - Name: `Image to PDF Converter`
   - Default language: English
   - App or game: **App**
   - Free or paid: **Free**
3. In the left navigation, go to **Release > Production** (or **Testing > Closed testing** if testing with 14/20 testers).
4. Click **Create new release**.
5. Under **App bundles**, upload:
   `d:\img-to-pdf-app\play_store_release\ImageToPdf_v1.0.0_release.aab`
6. Release name: `1.0.0 (1)`
7. Release notes:
   ```
   Initial official release of Image to PDF Converter by AP Programming Tech.
   - 100% Free, Offline, Open Source & Zero Ads.
   - Batch image selection, reordering, and rotation.
   - Custom layouts: A4, Letter, Margins, Compression & Grayscale.
   - On-device PDF generation, viewer, and share integration.
   ```
8. Click **Next**, review the checks, and click **Save and publish**!
