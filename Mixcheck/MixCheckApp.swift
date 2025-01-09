import SwiftUI

@main
struct MixCheckApp: App {
    @State private var showSplash = true
    
    var body: some Scene {
        WindowGroup {
            if showSplash {
                // SplashView includes an animated GIF that disappears after 2 seconds.
                SplashView {
                    // Once the splash ends, go to the main scanner.
                    showSplash = false
                }
            } else {
                // Our main scanner with the WebView overlay logic
                ScannerWithWebOverlay()
            }
        }
    }
}