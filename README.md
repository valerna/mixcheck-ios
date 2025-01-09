MixCheck
MixCheck is a simple iOS application for verifying the validity of music licenses at cheer competitions. The app:

Shows a Splash Screen with an animated GIF.
Immediately opens a camera-based QR code scanner with a small logo at the top.
Detects a QR code, opens a WebView for 4 seconds, and returns to scanning.
Table of Contents
Features
Requirements
Installation & Setup
Usage
Folder Structure
Troubleshooting & Common Issues
License
Features
Splash Screen
Displays an animated GIF on app launch for a brief duration.

Camera-Based QR Code Scanning
Utilizes the device camera to scan QR codes, specifically those pointing to mixcheck.app URLs.

Temporary WebView
When a valid QR code is detected, the app opens its corresponding URL in a WebView for 4 seconds, then returns to the camera feed.

Minimal UI Overlay
A small logo is displayed at the top of the camera preview, giving a clean look without distracting from the scanning function.

Requirements
Xcode 14+
iOS 14+ (SwiftUI minimum recommended version; can be adapted for iOS 13 with some modifications)
Swift 5.5+
A device (or simulator) with camera access; scanning requires a real iOS device to test effectively.
Installation & Setup
Clone the repository

bash
Copy code
git clone https://github.com/valerna/mixcheck-ios.git
cd MixCheck
Open in Xcode
Open the .xcodeproj or .xcworkspace file in Xcode.

Add the splash.gif file

Drag and drop splash.gif into your Xcode project’s file navigator.
Make sure the file is added to the app target (Build Phases → Copy Bundle Resources).
Add the MixCheckLogo (small logo displayed on camera screen)

In Assets.xcassets, add an image named MixCheckLogo.
Alternatively, replace Image("MixCheckLogo") in the source code with your own asset name.
Review Info.plist

Confirm NSCameraUsageDescription is set:
xml
Copy code
<key>NSCameraUsageDescription</key>
<string>This app requires camera access to scan QR codes.</string>
Build & Run

Select your iOS device or iOS Simulator in Xcode’s scheme selector.
Press Run (or ⌘R).
Note: QR code scanning requires a real device for proper testing.
Usage
Launch the App

On launch, the splash GIF will play for 2 seconds.
Scan a QR Code

After the splash, the camera feed appears.
Point the camera at a QR code.
Once detected, the corresponding URL is loaded in a WebView overlay for 4 seconds.
Verification Flow

Each scanned QR code links to a page on mixcheck.app.
The page indicates whether a presented music license is valid or not.
After 4 seconds, the overlay closes, and the camera resumes scanning.