import AVFoundation
import SwiftUI
import Combine

class CameraViewModel: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    let session = AVCaptureSession()
    let output = AVCaptureMetadataOutput()
    var preview = AVCaptureVideoPreviewLayer()
    let barcodeScanned = PassthroughSubject<String, Never>()

    private var lastScannedCode = ""

    override init() {
        super.init()
        setup()
    }

    func resetLastScannedCode() {
        lastScannedCode = ""
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {

        guard let metadataObject = metadataObjects.first,
              let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
              let stringValue = readableObject.stringValue,
              lastScannedCode != stringValue else { return }
        lastScannedCode = stringValue
        DispatchQueue.main.async {
            self.barcodeScanned.send(stringValue)
        }
    }

    private func setup() {
        session.beginConfiguration()
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input),
              session.canAddOutput(output) else {
            // assertionFailure()
            return
        }
        session.addInput(input)
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: .global())
        output.metadataObjectTypes = [.qr, .ean13, .code128]
        session.commitConfiguration()
    }
}
