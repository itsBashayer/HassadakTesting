//
//  CameraViewController.swift
//  HassadakTesting
//
//  Created by Joury on 04/09/1446 AH.
//
//import SwiftUI
//import AVFoundation
//import Vision
//
//// CameraViewController.swift
//class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
//    private let session = AVCaptureSession()
//    private let videoOutput = AVCaptureVideoDataOutput()
//    private var previewLayer: AVCaptureVideoPreviewLayer!
//    private var requests = [VNRequest]()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupCamera()
//        setupVision()
//    }
//    
//    private func setupCamera() {
//        session.sessionPreset = .high
//        
//        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
//              let input = try? AVCaptureDeviceInput(device: camera) else { return }
//        
//        session.addInput(input)
//        
//        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
//        session.addOutput(videoOutput)
//        
//        previewLayer = AVCaptureVideoPreviewLayer(session: session)
//        previewLayer.videoGravity = .resizeAspectFill
//        previewLayer.frame = view.layer.bounds
//        view.layer.addSublayer(previewLayer)
//        
//        session.startRunning()
//    }
//    
//    private func setupVision() {
//        guard let modelURL = Bundle.main.url(forResource: "ObjectDetector", withExtension: "mlmodelc"),
//              let visionModel = try? VNCoreMLModel(for: MLModel(contentsOf: modelURL)) else { return }
//        
//        let request = VNCoreMLRequest(model: visionModel) { [weak self] request, _ in
//            DispatchQueue.main.async {
//                self?.handleResults(request.results)
//            }
//        }
//        request.imageCropAndScaleOption = .scaleFill
//        self.requests = [request]
//    }
//    
//    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
//        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
//        do {
//            try handler.perform(requests)
//        } catch {
//            print("Failed to perform Vision request: \(error)")
//        }
//    }
//    
//    private func handleResults(_ results: [Any]?) {
//        guard let results = results as? [VNRecognizedObjectObservation] else { return }
//        
//        for result in results {
//            let bestLabel = result.labels.first?.identifier ?? "Unknown"
//            let confidence = result.labels.first?.confidence ?? 0.0
//            print("Detected: \(bestLabel) with confidence \(confidence)")
//        }
//    }
//}
//import SwiftUI
//import AVFoundation
//import Vision
//
//// CameraViewController.swift
//class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
//    private let session = AVCaptureSession()
//    private let videoOutput = AVCaptureVideoDataOutput()
//    private var previewLayer: AVCaptureVideoPreviewLayer!
//    private var requests = [VNRequest]()
//    private var detectionOverlay: CALayer! = nil // Layer for drawing detection results
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupCamera()
//        setupVision()
//    }
//    
//    private func setupCamera() {
//        session.sessionPreset = .high
//        
//        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
//              let input = try? AVCaptureDeviceInput(device: camera) else { return }
//        
//        session.addInput(input)
//        
//        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
//        session.addOutput(videoOutput)
//        
//        previewLayer = AVCaptureVideoPreviewLayer(session: session)
//        previewLayer.videoGravity = .resizeAspectFill
//        previewLayer.frame = view.layer.bounds
//        view.layer.addSublayer(previewLayer)
//        
//        detectionOverlay = CALayer()
//        detectionOverlay.frame = view.layer.bounds
//        detectionOverlay.name = "DetectionOverlay"
//        detectionOverlay.masksToBounds = true
//        view.layer.addSublayer(detectionOverlay)
//        
//        session.startRunning()
//    }
//    
//    private func setupVision() {
//        guard let modelURL = Bundle.main.url(forResource: "ObjectDetector", withExtension: "mlmodelc"),
//              let visionModel = try? VNCoreMLModel(for: MLModel(contentsOf: modelURL)) else { return }
//        
//        let request = VNCoreMLRequest(model: visionModel) { [weak self] request, _ in
//            DispatchQueue.main.async {
//                self?.handleResults(request.results)
//            }
//        }
//        request.imageCropAndScaleOption = .scaleFill
//        self.requests = [request]
//    }
//    
//    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
//        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
//        do {
//            try handler.perform(requests)
//        } catch {
//            print("Failed to perform Vision request: \(error)")
//        }
//    }
//    
//    private func handleResults(_ results: [Any]?) {
//        DispatchQueue.main.async {
//            self.detectionOverlay.sublayers?.removeAll()
//            
//            guard let results = results as? [VNRecognizedObjectObservation], !results.isEmpty else {
//                print("❌ No objects detected.")
//                return
//            }
//            
//            for result in results {
//                let bestLabel = result.labels.first?.identifier ?? "Unknown"
//                let confidence = result.labels.first?.confidence ?? 0.0
//                let boundingBox = result.boundingBox
//                
//                let convertedRect = self.transformBoundingBox(boundingBox)
//                let shapeLayer = self.createBoundingBox(rect: convertedRect)
//                self.detectionOverlay.addSublayer(shapeLayer)
//                
//                let textLayer = self.createTextLayer(text: "\(bestLabel)\nConfidence: \(String(format: "%.2f", confidence))", rect: convertedRect)
//                self.detectionOverlay.addSublayer(textLayer)
//            }
//        }
//    }
//    
//    private func transformBoundingBox(_ boundingBox: CGRect) -> CGRect {
//        let width = detectionOverlay.bounds.width
//        let height = detectionOverlay.bounds.height
//        
//        let newX = boundingBox.origin.x * width
//        let newY = (1 - boundingBox.origin.y - boundingBox.height) * height
//        let newWidth = boundingBox.width * width
//        let newHeight = boundingBox.height * height
//        
//        return CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
//    }
//    
//    private func createBoundingBox(rect: CGRect) -> CALayer {
//        let boxLayer = CALayer()
//        boxLayer.frame = rect
//        boxLayer.borderColor = UIColor.red.cgColor
//        boxLayer.borderWidth = 4.0
//        boxLayer.cornerRadius = 4.0
//        boxLayer.masksToBounds = true
//        return boxLayer
//    }
//    
//    private func createTextLayer(text: String, rect: CGRect) -> CATextLayer {
//        let textLayer = CATextLayer()
//        textLayer.name = "Object Label"
//        let formattedString = NSMutableAttributedString(string: text)
//        let largeFont = UIFont(name: "Helvetica", size: 24.0)!
//        formattedString.addAttributes([NSAttributedString.Key.font: largeFont], range: NSRange(location: 0, length: text.count))
//        textLayer.string = formattedString
//        textLayer.bounds = CGRect(x: 0, y: 0, width: rect.width, height: rect.height * 0.25)
//        textLayer.position = CGPoint(x: rect.midX, y: rect.midY - rect.height * 0.6)
//        textLayer.shadowOpacity = 0.7
//        textLayer.shadowOffset = CGSize(width: 2, height: 2)
//        textLayer.foregroundColor = UIColor.black.cgColor
//        textLayer.contentsScale = 2.0
//        textLayer.alignmentMode = .center
//        textLayer.cornerRadius = 5
//        textLayer.masksToBounds = true
//        return textLayer
//    }
//}

//final
//import SwiftUI
//import AVFoundation
//import Vision
//
//// CameraViewController.swift
//class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
//    private let session = AVCaptureSession()
//    private let videoOutput = AVCaptureVideoDataOutput()
//    private var previewLayer: AVCaptureVideoPreviewLayer!
//    private var requests = [VNRequest]()
//    private var detectionOverlay: CALayer! = nil // Layer for drawing detection results
//    private var objectCounts: [String: Int] = [:] // Dictionary to store object counts
//    private var detectedObjects: Set<String> = [] // Set to store unique object instances
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupCamera()
//        setupVision()
//    }
//    
//    private func setupCamera() {
//        session.sessionPreset = .high
//        
//        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
//              let input = try? AVCaptureDeviceInput(device: camera) else { return }
//        
//        session.addInput(input)
//        
//        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
//        session.addOutput(videoOutput)
//        
//        previewLayer = AVCaptureVideoPreviewLayer(session: session)
//        previewLayer.videoGravity = .resizeAspectFill
//        previewLayer.frame = view.layer.bounds
//        view.layer.addSublayer(previewLayer)
//        
//        detectionOverlay = CALayer()
//        detectionOverlay.frame = view.layer.bounds
//        detectionOverlay.name = "DetectionOverlay"
//        detectionOverlay.masksToBounds = true
//        view.layer.addSublayer(detectionOverlay)
//        
//        session.startRunning()
//    }
//    
//    private func setupVision() {
//        guard let modelURL = Bundle.main.url(forResource: "ObjectDetector", withExtension: "mlmodelc"),
//              let visionModel = try? VNCoreMLModel(for: MLModel(contentsOf: modelURL)) else { return }
//        
//        let request = VNCoreMLRequest(model: visionModel) { [weak self] request, _ in
//            DispatchQueue.main.async {
//                self?.handleResults(request.results)
//            }
//        }
//        request.imageCropAndScaleOption = .scaleFill
//        self.requests = [request]
//    }
//    
//    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
//        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
//        do {
//            try handler.perform(requests)
//        } catch {
//            print("Failed to perform Vision request: \(error)")
//        }
//    }
//    
//    private func handleResults(_ results: [Any]?) {
//        DispatchQueue.main.async {
//            self.objectCounts.removeAll()
//            self.detectedObjects.removeAll()
//            
//            guard let results = results as? [VNRecognizedObjectObservation], !results.isEmpty else {
//                print("❌ No objects detected.")
//                return
//            }
//            
//            for result in results {
//                let bestLabel = result.labels.first?.identifier ?? "Unknown"
//                let confidence = result.labels.first?.confidence ?? 0.0
//                
//                // Generate a unique key for the detected object based on its position
//                let objectKey = "\(bestLabel)_\(Int(result.boundingBox.minX * 1000))_\(Int(result.boundingBox.minY * 1000))"
//                
//                // Avoid double-counting the same object in different frames
//                if !self.detectedObjects.contains(objectKey) {
//                    self.detectedObjects.insert(objectKey)
//                    self.objectCounts[bestLabel, default: 0] += 1
//                }
//            }
//            
//            self.displayObjectCounts()
//        }
//    }
//    
//    private func displayObjectCounts() {
//        let countText = objectCounts.map { "\($0.key): \($0.value)" }.joined(separator: "\n")
//        
//        let countLayer = CATextLayer()
//        countLayer.string = countText
//        countLayer.fontSize = 24
//        countLayer.foregroundColor = UIColor.white.cgColor
//        countLayer.backgroundColor = UIColor.black.withAlphaComponent(0.6).cgColor
//        countLayer.alignmentMode = .left
//        countLayer.frame = CGRect(x: 10, y: 50, width: 300, height: 100)
//        countLayer.cornerRadius = 8
//        countLayer.contentsScale = UIScreen.main.scale
//        detectionOverlay.addSublayer(countLayer)
//    }
//}
//import SwiftUI
//import AVFoundation
//import Vision
//
//// CameraViewController.swift
//class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
//    private let session = AVCaptureSession()
//    private let videoOutput = AVCaptureVideoDataOutput()
//    private var previewLayer: AVCaptureVideoPreviewLayer!
//    private var requests = [VNRequest]()
//    private var detectionOverlay: CALayer! = nil // Layer for drawing detection results
//    private var objectCounts: [String: Int] = [:] // Dictionary to store object counts
//    private var trackedObjects = Set<String>() // Store currently detected objects
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupCamera()
//        setupVision()
//    }
//    
//    private func setupCamera() {
//        session.sessionPreset = .high
//        
//        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
//              let input = try? AVCaptureDeviceInput(device: camera) else { return }
//        
//        session.addInput(input)
//        
//        videoOutput.alwaysDiscardsLateVideoFrames = false // Ensure all frames are processed
//        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
//        session.addOutput(videoOutput)
//        
//        previewLayer = AVCaptureVideoPreviewLayer(session: session)
//        previewLayer.videoGravity = .resizeAspectFill
//        previewLayer.frame = view.layer.bounds
//        view.layer.addSublayer(previewLayer)
//        
//        detectionOverlay = CALayer()
//        detectionOverlay.frame = view.layer.bounds
//        detectionOverlay.name = "DetectionOverlay"
//        detectionOverlay.masksToBounds = true
//        view.layer.addSublayer(detectionOverlay)
//        
//        session.startRunning()
//    }
//    
//    private func setupVision() {
//        guard let modelURL = Bundle.main.url(forResource: "ObjectDetector", withExtension: "mlmodelc"),
//              let visionModel = try? VNCoreMLModel(for: MLModel(contentsOf: modelURL)) else { return }
//        
//        let request = VNCoreMLRequest(model: visionModel) { [weak self] request, _ in
//            DispatchQueue.main.async {
//                self?.handleResults(request.results)
//            }
//        }
//        request.imageCropAndScaleOption = .scaleFill
//        self.requests = [request]
//    }
//    
//    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
//        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
//        do {
//            try handler.perform(requests)
//        } catch {
//            print("Failed to perform Vision request: \(error)")
//        }
//    }
//    
////    private func handleResults(_ results: [Any]?) {
////        DispatchQueue.main.async {
////            self.detectionOverlay.sublayers?.removeAll() // Clear previous detections
////            self.objectCounts.removeAll()
////            
////            guard let results = results as? [VNRecognizedObjectObservation], !results.isEmpty else {
////                print("❌ No objects detected.")
////                return
////            }
////            
////            for result in results {
////                let bestLabel = result.labels.first?.identifier ?? "Unknown"
////                let confidence = result.labels.first?.confidence ?? 0.75 // Adaptive confidence threshold
////                
////                if confidence >= 0.75 { // Ensures accurate detections
////                    let convertedRect = self.transformBoundingBox(result.boundingBox)
////                    let shapeLayer = self.createBoundingBox(rect: convertedRect)
////                    self.detectionOverlay.addSublayer(shapeLayer)
////                    
////                    self.objectCounts[bestLabel, default: 0] += 1
////                }
////            }
////            
////            self.displayObjectCounts()
////        }
////    }
//    
//    private func handleResults(_ results: [Any]?) {
//        DispatchQueue.main.async {
//            self.detectionOverlay.sublayers?.removeAll() // Clear previous detections (except counting text)
//            
//            guard let results = results as? [VNRecognizedObjectObservation], !results.isEmpty else {
//                print("❌ No objects detected.")
//                self.objectCounts.removeAll() // Reset count if no objects are found
//                self.displayObjectCounts()
//                return
//            }
//
//            var newCounts: [String: Int] = [:] // Temporary dictionary for current frame
//            var newTrackedObjects = Set<String>() // Track current frame's objects
//
//            for result in results {
//                let bestLabel = result.labels.first?.identifier ?? "Unknown"
//                let confidence = result.labels.first?.confidence ?? 0.75
//
//                if confidence >= 0.75 {
//                    let convertedRect = self.transformBoundingBox(result.boundingBox)
//                    
//                    let objectKey = "\(bestLabel)_\(convertedRect.origin.x)_\(convertedRect.origin.y)"
//                    newTrackedObjects.insert(objectKey) // Store detected object position
//
//                    // Count only if it's a new detection (not already counted in last frame)
//                    if !self.trackedObjects.contains(objectKey) {
//                        newCounts[bestLabel, default: 0] += 1
//                    }
//                }
//            }
//
//            // Update tracked objects
//            self.trackedObjects = newTrackedObjects
//
//            // Update counts
//            self.objectCounts = newCounts // Only count new objects per frame
//
//            self.displayObjectCounts()
//        }
//    }
//
//    
//    private func transformBoundingBox(_ boundingBox: CGRect) -> CGRect {
//        let width = detectionOverlay.bounds.width
//        let height = detectionOverlay.bounds.height
//        
//        let newX = boundingBox.origin.x * width
//        let newY = (1 - boundingBox.origin.y - boundingBox.height) * height
//        let newWidth = boundingBox.width * width
//        let newHeight = boundingBox.height * height
//        
//        return CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
//    }
//    
//    private func createBoundingBox(rect: CGRect) -> CAShapeLayer {
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.frame = rect
//        shapeLayer.path = UIBezierPath(roundedRect: rect, cornerRadius: 8).cgPath
//        shapeLayer.strokeColor = UIColor.red.cgColor
//        shapeLayer.fillColor = UIColor.clear.cgColor
//        shapeLayer.lineWidth = 3.0
//        return shapeLayer
//    }
//    
//    private func displayObjectCounts() {
//        let countText = objectCounts.map { "\($0.key): \($0.value)" }.joined(separator: "\n")
//        
//        let countLayer = CATextLayer()
//        countLayer.string = countText
//        countLayer.fontSize = 24
//        countLayer.foregroundColor = UIColor.white.cgColor
//        countLayer.backgroundColor = UIColor.black.withAlphaComponent(0.6).cgColor
//        countLayer.alignmentMode = .left
//        countLayer.frame = CGRect(x: 10, y: 50, width: 300, height: 100)
//        countLayer.cornerRadius = 8
//        countLayer.contentsScale = UIScreen.main.scale
//        detectionOverlay.addSublayer(countLayer)
//    }
//}
import Vision
import CoreML

class ObjectDetectorView {
    private let model: VNCoreMLModel

    init() {
        do {
            guard let modelURL = Bundle.main.url(forResource: "ObjectDetector", withExtension: "mlmodelc") else {
                fatalError("❌ Failed to load ML model file")
            }
            let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
            self.model = visionModel
        } catch {
            fatalError("❌ CoreML Model Loading Failed: \(error)")
        }
    }

    func detectObjects(in image: CGImage, completion: @escaping ([String: Int]) -> Void) {
        let request = VNCoreMLRequest(model: model) { request, _ in
            var objectCounts = [String: Int]()

            if let results = request.results as? [VNRecognizedObjectObservation] {
                for result in results {
                    let bestLabel = result.labels.first?.identifier ?? "Unknown"
                    objectCounts[bestLabel, default: 0] += 1
                }
            }

            completion(objectCounts)
        }

        let handler = VNImageRequestHandler(cgImage: image, options: [:])
        do {
            try handler.perform([request])
        } catch {
            print("❌ Vision request failed: \(error)")
            completion([:])
        }
    }
}
