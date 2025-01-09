import SwiftUI
import WebKit

struct SplashView: View {
    // Called once the splash should end
    var onSplashEnd: () -> Void
    
    var body: some View {
        ZStack {
            GIFView(gifName: "splash") // "splash.gif" in your project bundle
                .onAppear {
                    // Delay for 2 seconds, then call onSplashEnd()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        onSplashEnd()
                    }
                }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct GIFView: UIViewRepresentable {
    let gifName: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        
        if let path = Bundle.main.path(forResource: gifName, ofType: "gif") {
            let data = try? Data(contentsOf: URL(fileURLWithPath: path))
            webView.load(
                data ?? Data(),
                mimeType: "image/gif",
                characterEncodingName: "UTF-8",
                baseURL: URL(fileURLWithPath: path)
            )
        }
        
        webView.isUserInteractionEnabled = false
        webView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = false
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // No update needed here
    }
}