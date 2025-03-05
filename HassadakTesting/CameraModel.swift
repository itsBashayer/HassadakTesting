//
//  CameraView.swift
//  HassadakTesting
//
//  Created by Joury on 04/09/1446 AH.
//


//// CameraView.swift
//struct CameraView: UIViewControllerRepresentable {
//    func makeUIViewController(context: Context) -> CameraViewController {
//        let controller = CameraViewController()
//        return controller
//    }
//    
//    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
//}
import AVFoundation
import SwiftUI

class CameraModel: NSObject, ObservableObject {
    let session = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    private let objectDetector = ObjectDetectorView() // ✅ Use the correct class name

    @Published var capturedImage: UIImage?
    @Published var detectedObjects: [String: Int] = [:]

    override init() {
        super.init()
        setupSession()
    }

    private func setupSession() {
        session.sessionPreset = .photo

        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: camera) else {
            print("❌ Failed to access camera")
            return
        }

        session.addInput(input)
        session.addOutput(photoOutput)
    }

    func startSession() {
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
        }
    }

    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
}

extension CameraModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(),
              let uiImage = UIImage(data: imageData) else {
            print("❌ Failed to capture image")
            return
        }

        DispatchQueue.main.async {
            self.capturedImage = uiImage
        }

        processImage(uiImage)
    }

    private func processImage(_ image: UIImage) {
        guard let cgImage = image.cgImage else { return }

        objectDetector.detectObjects(in: cgImage) { results in
            DispatchQueue.main.async {
                self.detectedObjects = results
            }
        }
    }
}
