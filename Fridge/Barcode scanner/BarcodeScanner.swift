import SwiftUI
import AVFoundation

struct BarcodeScanner: View, BarcodeScannerParameters {
    let viewModel: CameraViewModel

    var body: some View {
        ZStack {
            CameraPreview(viewModel: viewModel)
            RoundedRectangle(cornerRadius: codeRectangleCornerRadius)
                .stroke(Color.white, lineWidth: codeRectangleWidth)
                .frame(width: recognizableAreaWidth, height: recognizableAreaHeight)
        }
        .onDisappear() {
            viewModel.session.stopRunning()
            viewModel.resetLastScannedCode()
        }
    }
}

struct CameraPreview: UIViewRepresentable, BarcodeScannerParameters {
    private var viewModel: CameraViewModel

    init(viewModel: CameraViewModel) {
        self.viewModel = viewModel
    }

    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        viewModel.preview = AVCaptureVideoPreviewLayer(session: viewModel.session)
        viewModel.preview.frame = view.frame
        viewModel.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(viewModel.preview)
        viewModel.session.startRunning()
        viewModel.output.rectOfInterest = viewModel.preview.metadataOutputRectConverted(fromLayerRect: recognizableAreaRect)
        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) { }
}

struct BarcodeScanner_Previews: PreviewProvider {
    @State static var code: String? = ""

    static var previews: some View {
        BarcodeScanner(viewModel: CameraViewModel())
    }
}
