import SwiftUI
import AVFoundation
import Vision

class CameraViewController: UIViewController {
    private let session = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var detectionOverlay: CALayer! = nil
    private var objectCounts: [String: Int] = [:]
    
    private var isPhotoCaptured = false
    private var retryCaptureButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        setupOverlayUI()
    }

    private func setupCamera() {
        session.sessionPreset = .photo

        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: camera) else { return }

        session.addInput(input)
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.layer.bounds
        view.layer.addSublayer(previewLayer)

        detectionOverlay = CALayer()
        detectionOverlay.frame = view.layer.bounds
        detectionOverlay.name = "DetectionOverlay"
        detectionOverlay.masksToBounds = true
        view.layer.addSublayer(detectionOverlay)

        session.startRunning()
    }

    private func setupOverlayUI() {
        let hostingController = UIHostingController(rootView: CamButton(capturePhotoAction: capturePhoto))
        hostingController.view.frame = view.bounds
        hostingController.view.backgroundColor = .clear
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }

    func capturePhoto() {
        guard !isPhotoCaptured else { return }
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
        isPhotoCaptured = true
        session.stopRunning()

        showRetryButton()
    }

    private func showRetryButton() {
        retryCaptureButton = UIButton(frame: CGRect(x: view.bounds.midX - 75, y: view.bounds.maxY - 150, width: 150, height: 50))
        retryCaptureButton.setTitle("Retry Capture", for: .normal)
        retryCaptureButton.backgroundColor = .red
        retryCaptureButton.layer.cornerRadius = 8
        retryCaptureButton.addTarget(self, action: #selector(retryCapture), for: .touchUpInside)
        view.addSubview(retryCaptureButton)
    }

    @objc private func retryCapture() {
        isPhotoCaptured = false
        objectCounts.removeAll()

        detectionOverlay.sublayers?.removeAll()

        session.startRunning()
        retryCaptureButton.removeFromSuperview()
    }

    private func updateCapturedImage(_ image: UIImage) {
        self.detectionOverlay.sublayers?.removeAll()
        processImage(image)
    }

    private func processImage(_ image: UIImage) {
        guard let ciImage = CIImage(image: image) else { return }

        guard let modelURL = Bundle.main.url(forResource: "ObjectDetector", withExtension: "mlmodelc"),
              let visionModel = try? VNCoreMLModel(for: MLModel(contentsOf: modelURL)) else { return }

        let request = VNCoreMLRequest(model: visionModel) { [weak self] request, _ in
            DispatchQueue.main.async {
                self?.handleResults(request.results)
            }
        }

        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        try? handler.perform([request])
    }

    private func handleResults(_ results: [Any]?) {
        DispatchQueue.main.async {
            self.detectionOverlay.sublayers?.removeAll()
            self.objectCounts.removeAll()

            guard let results = results as? [VNRecognizedObjectObservation], !results.isEmpty else {
                print("❌ No objects detected.")
                return
            }

            for result in results {
                let bestLabel = result.labels.first?.identifier ?? "Unknown"
                self.objectCounts[bestLabel, default: 0] += 1
            }

            self.displayObjectCounts()
        }
    }

    private func displayObjectCounts() {
        let countText = objectCounts.map { "\($0.key): \($0.value)" }.joined(separator: "\n")

        let countLayer = CATextLayer()
        countLayer.string = countText
        countLayer.fontSize = 24
        countLayer.foregroundColor = UIColor.white.cgColor
        countLayer.backgroundColor = UIColor.black.withAlphaComponent(0.6).cgColor
        countLayer.alignmentMode = .left
        countLayer.frame = CGRect(x: 10, y: 50, width: 300, height: 100)
        countLayer.cornerRadius = 8
        countLayer.contentsScale = UIScreen.main.scale
        detectionOverlay.addSublayer(countLayer)
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else { return }

        updateCapturedImage(image)
    }
}
