import AVFoundation
import SwiftUI

struct ContentView: View {
    @State private var camera = CameraSession()
    @State private var accessDenied = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            if accessDenied {
                Text("設定アプリでカメラへのアクセスを許可してください")
                    .foregroundStyle(.white)
                    .padding()
            } else {
                CameraPreview(session: camera.session)
                    .ignoresSafeArea()
            }
        }
        .task {
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            accessDenied = !granted
            if granted {
                camera.start()
            }
        }
    }
}
