import SwiftUI
import AVFoundation

struct CameraScannerView: View {
    @ObservedObject var viewModel = CameraScannerViewModel()
    
    var body: some View {
        ZStack {
            // Camera preview
            CameraPreview(session: viewModel.session)
                .ignoresSafeArea()
            
            // Small logo at the top
            VStack {
                Image("MixCheckLogo") // Replace with your app’s logo
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 40)
                    .padding(.top, 40)
                Spacer()
            }
        }
        .onAppear {
            viewModel.startSession()
        }
        .onDisappear {
            viewModel.stopSession()
        }
    }
}

// ViewModel handling the capture session and QR detection
class CameraScannerViewModel: NSObject, ObservableObject, AVCaptureMetadataOutputObjectsDelegate {
    @Published var detectedURL: URL? = nil
    
    let session = AVCaptureSession()
    private let metadataOutput = AVCaptureMetadataOutput()
    
    override init() {
        super.init()
        setupSession()
    }
    
    private func setupSession() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            print("Error: No camera on device.")
            return
        }
        
        guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) else {
            print("Error: Cannot create camera input.")
            return
        }
        
        // Add input
        if session.canAddInput(videoInput) {
            session.addInput(videoInput)
        }
        
        // Add output
        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        }
    }
    
    func startSession() {
        if !session.isRunning {
            session.startRunning()
        }
    }
    
    func stopSession() {
        if session.isRunning {
            session.stopRunning()
        }
    }
    
    // Delegate callback for detected metadata
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        
        guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let stringValue = metadataObject.stringValue,
              let url = URL(string: stringValue) else {
            return
        }
        
        // Stop scanning so we don’t repeatedly detect the same QR code
        stopSession()
        
        // Let SwiftUI know that we found a URL
        detectedURL = url
    }
}

struct CameraPreview: UIViewRepresentable {
    class VideoPreviewView: UIView {
        override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }
        
        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            return layer as! AVCaptureVideoPreviewLayer
        }
    }
    
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> VideoPreviewView {
        let view = VideoPreviewView()
        view.videoPreviewLayer.session = session
        view.videoPreviewLayer.videoGravity = .resizeAspectFill
        return view
    }
    
    func updateUIView(_ uiView: VideoPreviewView, context: Context) {
        // No dynamic updates needed
    }
}