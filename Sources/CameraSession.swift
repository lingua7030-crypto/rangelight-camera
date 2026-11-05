import AVFoundation

final class CameraSession {
    let session = AVCaptureSession()
    private let queue = DispatchQueue(label: "camera.session")
    private var isConfigured = false

    func start() {
        queue.async { [self] in
            if !isConfigured {
                configure()
            }
            if isConfigured && !session.isRunning {
                session.startRunning()
            }
        }
    }

    private func configure() {
        guard
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
            let input = try? AVCaptureDeviceInput(device: device)
        else { return }

        session.beginConfiguration()
        defer { session.commitConfiguration() }

        session.sessionPreset = .photo
        guard session.canAddInput(input) else { return }
        session.addInput(input)
        isConfigured = true
    }
}
