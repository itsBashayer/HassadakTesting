//
//  ContentView.swift
//  HassadakTesting
//
//  Created by BASHAER AZIZ on 28/08/1446 AH.
//

//import SwiftUI
//
//struct ContentView: View {
//    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
//        }
//        .padding()
//    }
//}
//
//#Preview {
//    ContentView()
//}

//// ContentView.swift
//struct ContentView: View {
//    var body: some View {
//        CameraView()
//            .edgesIgnoringSafeArea(.all)
//    }
//}
import SwiftUI
import AVFoundation

struct ContentView: View {
    @StateObject private var cameraModel = CameraModel()

    var body: some View {
        VStack {
            ZStack {
                CameraView(session: cameraModel.session)
                    .ignoresSafeArea()

                if let image = cameraModel.capturedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                }
            }

            Button("Capture Image") {
                cameraModel.capturePhoto()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())

            if !cameraModel.detectedObjects.isEmpty {
                Text("Detected Objects:")
                    .font(.headline)
                    .padding(.top)

                ForEach(cameraModel.detectedObjects.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                    Text("\(key): \(value)")
                }
            }
        }
        .onAppear {
            cameraModel.startSession()
        }
    }
}
