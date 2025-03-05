//
//  CameraView.swift
//  HassadakTesting
//
//  Created by Joury on 04/09/1446 AH.
//
import SwiftUI


struct CameraView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> CameraViewController {
        return CameraViewController()
    }
    
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
}
