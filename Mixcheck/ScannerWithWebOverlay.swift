import SwiftUI
import WebKit

struct ScannerWithWebOverlay: View {
    @StateObject var viewModel = CameraScannerViewModel()
    @State private var showWebView = false
    @State private var currentURL: URL?
    
    var body: some View {
        ZStack {
            // Underneath: the camera feed
            CameraPreview(session: viewModel.session)
                .ignoresSafeArea()
            
            // Small logo at top
            VStack {
                Image("MixCheckLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 40)
                    .padding(.top, 40)
                Spacer()
            }
            
            // WebView overlay (if showWebView is true)
            if showWebView, let url = currentURL {
                WebView(url: url)
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity)
            }
        }
        .onAppear {
            viewModel.startSession()
        }
        .onDisappear {
            viewModel.stopSession()
        }
        // React to changes in the ViewModel's detectedURL
        .onReceive(viewModel.$detectedURL) { url in
            guard let url = url else { return }
            currentURL = url
            showWebView = true
            
            // Show WebView for 4 seconds, then dismiss
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                showWebView = false
                currentURL = nil
                // Resume scanning
                viewModel.startSession()
            }
        }
    }
}

// A simple SwiftUI WebView
struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // No dynamic updates
    }
}