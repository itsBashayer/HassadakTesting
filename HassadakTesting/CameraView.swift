//
//  CameraView.swift
//  HassadakTesting
//
//  Created by Joury on 04/09/1446 AH.
//
import SwiftUI

// CameraView.swift
struct CameraView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> CameraViewController {
        let controller = CameraViewController()
        return controller
    }
    
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
}
