//
//  CameraView.swift
//  HassadakTesting
//
//  Created by Joury on 05/09/1446 AH.
//
import SwiftUI
import AVFoundation

struct CameraView: View {
    var session: AVCaptureSession

    var body: some View {
        CameraPreview(session: session)
            .ignoresSafeArea()
    }
}

struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> CameraPreviewView {
        let view = CameraPreviewView()
        view.videoPreviewLayer.session = session
        view.videoPreviewLayer.videoGravity = .resizeAspectFill
        return view
    }

    func updateUIView(_ uiView: CameraPreviewView, context: Context) {}

    class CameraPreviewView: UIView {
        override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }

        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            return layer as! AVCaptureVideoPreviewLayer
        }
    }
}
