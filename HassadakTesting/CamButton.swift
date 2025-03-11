//
//  CamButton.swift
//  Hasadekk
//
//  Created by BASHAER AZIZ on 03/09/1446 AH.
//

//import SwiftUI
//import AVFoundation
//
//struct CamButton: View {
//    @State private var showInstructions = true
//    @State private var selectedNavItem: String? = nil
//    var capturePhotoAction: () -> Void
//    let soundPlayer = SoundPlayer()
//
//    var body: some View {
//        
//        ZStack {
//            VStack {
//                Spacer()
//                
//                if showInstructions {
//                    InstructionBox(showInstructions: $showInstructions)
//                }
//                
//                Spacer()
//                
//                BottomNavBar(showInstructions: $showInstructions, selectedNavItem: $selectedNavItem, capturePhotoAction: {
//                    soundPlayer.playSound()
//                    capturePhotoAction()
//                })
//            }
//        }
//    }
//}
//
//struct InstructionBox: View {
//    @Binding var showInstructions: Bool
//    
//    var body: some View {
//        VStack(spacing: 12) {
//            InstructionRow(imageName: "adjust", text: "Adjust on wide view")
//            InstructionRow(imageName: "arrange", text: "Arrange vegetables neatly")
//            InstructionRow(imageName: "surface", text: "Use a flat surface")
//            InstructionRow(imageName: "light", text: "Ensure good lighting")
//            
//            Divider()
//            
//            Button("Done") {
//                showInstructions = false
//            }
//            .foregroundColor(Color("Green"))
//            .padding(.top, 4)
//        }
//        .padding()
//        .background(Color(.systemGray6))
//        .cornerRadius(12)
//        .shadow(radius: 5)
//        .frame(width: 280)
//    }
//}
//
//struct InstructionRow: View {
//    var imageName: String
//    var text: String
//    
//    var body: some View {
//        HStack {
//            Image(imageName)
//                .resizable()
//                .scaledToFit()
//                .frame(width: 34.31, height: 34.31)
//            
//            Text(text)
//                .font(.system(size: 16))
//                .foregroundColor(.black)
//            
//            Spacer()
//        }
//    }
//}
//
//struct BottomNavBar: View {
//    @Binding var showInstructions: Bool
//    @Binding var selectedNavItem: String?
//    var capturePhotoAction: () -> Void
//    
//    var body: some View {
//        HStack {
//            NavigationLink(destination: HistoryView(), tag: "History", selection: $selectedNavItem) {
//                            EmptyView()
//                        }
//            NavBarItem(imageName: "history", text: "History", selectedNavItem: $selectedNavItem)
//            NavBarItem(imageName: "counter", text: "Counter", selectedNavItem: $selectedNavItem, action: {
//                capturePhotoAction()  
//            })
//            NavBarItem(imageName: "Instructions", text: "Instructions", selectedNavItem: $selectedNavItem) {
//                showInstructions = true
//            }
//        }
//    }
//}
//
//struct NavBarItem: View {
//    var imageName: String
//    var text: String
//    @Binding var selectedNavItem: String?
//    var action: (() -> Void)?
//    
//    var isSelected: Bool {
//        selectedNavItem == text
//    }
//    
//    var body: some View {
//        VStack {
//            Button(action: {
//                selectedNavItem = text
//                action?()
//            }) {
//                ZStack {
//                    Circle()
//                        .fill(isSelected && text == "Counter" ? Color("Green") : Color(.systemGray5))
//                        .frame(
//                            width: text == "Counter" ? 90.63 : 71.84,
//                            height: text == "Counter" ? 90.85 : 73.34
//                        )
//                    
//                    Image(isSelected && text == "Counter" ? "white_counter" : imageName)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(
//                            width: text == "Counter" ? 55.62 : 44.88,
//                            height: text == "Counter" ? 55.58 : 44.86
//                        )
//                        .foregroundColor(isSelected && text == "Counter" ? .white : .gray)
//                }
//            }
//            
//            Text(text)
//                .font(.system(size: 14))
//                .foregroundColor(isSelected ? Color("Green") : .gray)
//        }
//        .padding(.horizontal, 22)
//    }
//}
//
//
//class SoundPlayer {
//    var player: AVAudioPlayer?
//
//    func playSound() {
//        if let soundURL = Bundle.main.url(forResource: "CounterSound", withExtension: "mp3") {
//            do {
//                player = try AVAudioPlayer(contentsOf: soundURL)
//                player?.play()
//            } catch {
//                print("Error playing sound: \(error.localizedDescription)")
//            }
//        } else {
//            print("Sound file not found!")
//        }
//    }
//}
//import SwiftUI
//import AVFoundation
//
//struct CamButton: View {
//    @State private var showInstructions = true
//    @State private var selectedNavItem: String? = nil
//    @State private var showHistoryView = false // ✅ Added for controlling HistoryView presentation
//    var capturePhotoAction: () -> Void
//    let soundPlayer = SoundPlayer()
//
//    var body: some View {
//        ZStack {
//            VStack {
//                Spacer()
//                
//                if showInstructions {
//                    InstructionBox(showInstructions: $showInstructions)
//                }
//                
//                Spacer()
//                
//                BottomNavBar(
//                    showInstructions: $showInstructions,
//                    selectedNavItem: $selectedNavItem,
//                    showHistoryView: $showHistoryView, // ✅ Pass state for History
//                    capturePhotoAction: {
//                        soundPlayer.playSound()
//                        capturePhotoAction()
//                    }
//                )
//            }
//        }
//        .fullScreenCover(isPresented: $showHistoryView) { // ✅ Show HistoryView fullscreen
//            HistoryView()
//        }
//    }
//}
//
//struct InstructionBox: View {
//    @Binding var showInstructions: Bool
//
//    var body: some View {
//        VStack(spacing: 12) {
//            InstructionRow(imageName: "adjust", text: "Adjust on wide view")
//            InstructionRow(imageName: "arrange", text: "Arrange vegetables neatly")
//            InstructionRow(imageName: "surface", text: "Use a flat surface")
//            InstructionRow(imageName: "light", text: "Ensure good lighting")
//            
//            Divider()
//            
//            Button("Done") {
//                showInstructions = false
//            }
//            .foregroundColor(Color("Green"))
//            .padding(.top, 4)
//        }
//        .padding()
//        .background(Color(.systemGray6))
//        .cornerRadius(12)
//        .shadow(radius: 5)
//        .frame(width: 280)
//    }
//}
//
//struct InstructionRow: View {
//    var imageName: String
//    var text: String
//
//    var body: some View {
//        HStack {
//            Image(imageName)
//                .resizable()
//                .scaledToFit()
//                .frame(width: 34.31, height: 34.31)
//            
//            Text(text)
//                .font(.system(size: 16))
//                .foregroundColor(.black)
//            
//            Spacer()
//        }
//    }
//}
//
//struct BottomNavBar: View {
//    @Binding var showInstructions: Bool
//    @Binding var selectedNavItem: String?
//    @Binding var showHistoryView: Bool // ✅ Added for HistoryView navigation
//    var capturePhotoAction: () -> Void
//
//    var body: some View {
//        HStack {
//            NavBarItem(imageName: "history", text: "History", selectedNavItem: $selectedNavItem) {
//                showHistoryView = true // ✅ Open HistoryView when tapped
//            }
//
//            NavBarItem(imageName: "counter", text: "Counter", selectedNavItem: $selectedNavItem, action: {
//                capturePhotoAction()
//            })
//            
//            NavBarItem(imageName: "Instructions", text: "Instructions", selectedNavItem: $selectedNavItem) {
//                showInstructions = true
//            }
//        }
//    }
//}
//
//struct NavBarItem: View {
//    var imageName: String
//    var text: String
//    @Binding var selectedNavItem: String?
//    var action: (() -> Void)?
//
//    var isSelected: Bool {
//        selectedNavItem == text
//    }
//
//    var body: some View {
//        VStack {
//            Button(action: {
//                selectedNavItem = text
//                action?()
//            }) {
//                ZStack {
//                    Circle()
//                        .fill(isSelected && text == "Counter" ? Color("Green") : Color(.systemGray5))
//                        .frame(
//                            width: text == "Counter" ? 90.63 : 71.84,
//                            height: text == "Counter" ? 90.85 : 73.34
//                        )
//                    
//                    Image(isSelected && text == "Counter" ? "white_counter" : imageName)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(
//                            width: text == "Counter" ? 55.62 : 44.88,
//                            height: text == "Counter" ? 55.58 : 44.86
//                        )
//                        .foregroundColor(isSelected && text == "Counter" ? .white : .gray)
//                }
//            }
//            
//            Text(text)
//                .font(.system(size: 14))
//                .foregroundColor(isSelected ? Color("Green") : .gray)
//        }
//        .padding(.horizontal, 22)
//    }
//}
//
//
//class SoundPlayer {
//    var player: AVAudioPlayer?
//
//    func playSound() {
//        if let soundURL = Bundle.main.url(forResource: "CounterSound", withExtension: "mp3") {
//            do {
//                player = try AVAudioPlayer(contentsOf: soundURL)
//                player?.play()
//            } catch {
//                print("Error playing sound: \(error.localizedDescription)")
//            }
//        } else {
//            print("Sound file not found!")
//        }
//    }
//}
//import SwiftUI
//import AVFoundation
//
//struct CamButton: View {
//    @State private var showInstructions = true
//    @State private var selectedNavItem: String? = nil
//    @State private var showHistoryView = false // ✅ Controls HistoryView presentation
//    @State private var detectedItemName: String = "" // ✅ Stores detected item name
//    @State private var detectedItemQTY: Int = 0 // ✅ Stores detected item count
//    @State private var captureDate: String = "" // ✅ Stores capture date
//
//    var capturePhotoAction: () -> Void
//    let soundPlayer = SoundPlayer()
//
//    var body: some View {
//        ZStack {
//            VStack {
//                Spacer()
//                
//                if showInstructions {
//                    InstructionBox(showInstructions: $showInstructions)
//                }
//                
//                Spacer()
//                
//                BottomNavBar(
//                    showInstructions: $showInstructions,
//                    selectedNavItem: $selectedNavItem,
//                    showHistoryView: $showHistoryView, // ✅ Pass state for History
//                    detectedItemName: $detectedItemName, // ✅ Pass detected data
//                    detectedItemQTY: $detectedItemQTY,
//                    captureDate: $captureDate,
//                    capturePhotoAction: {
//                        soundPlayer.playSound()
//                        capturePhotoAction()
//                    }
//                )
//            }
//        }
//        .fullScreenCover(isPresented: $showHistoryView) { // ✅ Show HistoryView fullscreen with correct data
//            HistoryView(
//                selectedItemName: detectedItemName,
//                selectedItemQTY: detectedItemQTY,
//                captureDate: captureDate
//            )
//        }
//    }
//}
//
//struct InstructionBox: View {
//    @Binding var showInstructions: Bool
//
//    var body: some View {
//        VStack(spacing: 12) {
//            InstructionRow(imageName: "adjust", text: "Adjust on wide view")
//            InstructionRow(imageName: "arrange", text: "Arrange vegetables neatly")
//            InstructionRow(imageName: "surface", text: "Use a flat surface")
//            InstructionRow(imageName: "light", text: "Ensure good lighting")
//            
//            Divider()
//            
//            Button("Done") {
//                showInstructions = false
//            }
//            .foregroundColor(Color("Green"))
//            .padding(.top, 4)
//        }
//        .padding()
//        .background(Color(.systemGray6))
//        .cornerRadius(12)
//        .shadow(radius: 5)
//        .frame(width: 280)
//    }
//}
//
//struct InstructionRow: View {
//    var imageName: String
//    var text: String
//
//    var body: some View {
//        HStack {
//            Image(imageName)
//                .resizable()
//                .scaledToFit()
//                .frame(width: 34.31, height: 34.31)
//            
//            Text(text)
//                .font(.system(size: 16))
//                .foregroundColor(.black)
//            
//            Spacer()
//        }
//    }
//}
//
//struct BottomNavBar: View {
//    @Binding var showInstructions: Bool
//    @Binding var selectedNavItem: String?
//    @Binding var showHistoryView: Bool // ✅ Added for HistoryView navigation
//    @Binding var detectedItemName: String // ✅ Receives detected object name
//    @Binding var detectedItemQTY: Int // ✅ Receives object count
//    @Binding var captureDate: String // ✅ Receives capture date
//    var capturePhotoAction: () -> Void
//
//    var body: some View {
//        HStack {
//            NavBarItem(imageName: "history", text: "History", selectedNavItem: $selectedNavItem) {
//                // ✅ Simulate detected item data (replace with real detection logic)
//                detectedItemName = "Tomato"
//                detectedItemQTY = 3
//                captureDate = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short)
//
//                showHistoryView = true // ✅ Open HistoryView when tapped
//            }
//
//            NavBarItem(imageName: "counter", text: "Counter", selectedNavItem: $selectedNavItem, action: {
//                capturePhotoAction()
//            })
//            
//            NavBarItem(imageName: "Instructions", text: "Instructions", selectedNavItem: $selectedNavItem) {
//                showInstructions = true
//            }
//        }
//    }
//}
//
//struct NavBarItem: View {
//    var imageName: String
//    var text: String
//    @Binding var selectedNavItem: String?
//    var action: (() -> Void)?
//
//    var isSelected: Bool {
//        selectedNavItem == text
//    }
//
//    var body: some View {
//        VStack {
//            Button(action: {
//                selectedNavItem = text
//                action?()
//            }) {
//                ZStack {
//                    Circle()
//                        .fill(isSelected && text == "Counter" ? Color("Green") : Color(.systemGray5))
//                        .frame(
//                            width: text == "Counter" ? 90.63 : 71.84,
//                            height: text == "Counter" ? 90.85 : 73.34
//                        )
//                    
//                    Image(isSelected && text == "Counter" ? "white_counter" : imageName)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(
//                            width: text == "Counter" ? 55.62 : 44.88,
//                            height: text == "Counter" ? 55.58 : 44.86
//                        )
//                        .foregroundColor(isSelected && text == "Counter" ? .white : .gray)
//                }
//            }
//            
//            Text(text)
//                .font(.system(size: 14))
//                .foregroundColor(isSelected ? Color("Green") : .gray)
//        }
//        .padding(.horizontal, 22)
//    }
//}
//
//class SoundPlayer {
//    var player: AVAudioPlayer?
//
//    func playSound() {
//        if let soundURL = Bundle.main.url(forResource: "CounterSound", withExtension: "mp3") {
//            do {
//                player = try AVAudioPlayer(contentsOf: soundURL)
//                player?.play()
//            } catch {
//                print("Error playing sound: \(error.localizedDescription)")
//            }
//        } else {
//            print("Sound file not found!")
//        }
//    }
//}

//import SwiftUI
//import AVFoundation
//
//struct CamButton: View {
//    @State private var showInstructions = true
//    @State private var selectedNavItem: String? = nil
//    @State private var showHistoryView = false // ✅ Controls HistoryView presentation
//    @State private var detectedItemName: String = "" // ✅ Stores detected item name
//    @State private var detectedItemQTY: Int = 0 // ✅ Stores detected item count
//    @State private var captureDate: String = "" // ✅ Stores capture date
//
//    var userName: String // ✅ Added userName
//    var capturePhotoAction: () -> Void
//    let soundPlayer = SoundPlayer()
//
//    var body: some View {
//        ZStack {
//            VStack {
//                Spacer()
//                
//                if showInstructions {
//                    InstructionBox(showInstructions: $showInstructions)
//                }
//                
//                Spacer()
//                
//                BottomNavBar(
//                    showInstructions: $showInstructions,
//                    selectedNavItem: $selectedNavItem,
//                    showHistoryView: $showHistoryView, // ✅ Pass state for History
//                    detectedItemName: $detectedItemName, // ✅ Pass detected data
//                    detectedItemQTY: $detectedItemQTY,
//                    captureDate: $captureDate,
//                    userName: userName, // ✅ Pass userName
//                    capturePhotoAction: {
//                        soundPlayer.playSound()
//                        capturePhotoAction()
//                    }
//                )
//            }
//        }
//        .fullScreenCover(isPresented: $showHistoryView) { // ✅ Show HistoryView fullscreen with correct data
//            HistoryView(
//                 selectedItemName: detectedItemName,
//                 selectedItemQTY: detectedItemQTY,
//                 captureDate: captureDate,
//                 userName: userName // ✅ Pass userName correctly
//             )
//        }
//    }
//}
//struct InstructionBox: View {
//    @Binding var showInstructions: Bool
//
//    var body: some View {
//        VStack(spacing: 12) {
//            InstructionRow(imageName: "adjust", text: "Adjust on wide view")
//            InstructionRow(imageName: "arrange", text: "Arrange vegetables neatly")
//            InstructionRow(imageName: "surface", text: "Use a flat surface")
//            InstructionRow(imageName: "light", text: "Ensure good lighting")
//
//            Divider()
//
//            Button("Done") {
//                showInstructions = false
//            }
//            .foregroundColor(Color("Green"))
//            .padding(.top, 4)
//        }
//        .padding()
//        .background(Color(.systemGray6))
//        .cornerRadius(12)
//        .shadow(radius: 5)
//        .frame(width: 280)
//    }
//}
//
//struct InstructionRow: View {
//    var imageName: String
//    var text: String
//
//    var body: some View {
//        HStack {
//            Image(imageName)
//                .resizable()
//                .scaledToFit()
//                .frame(width: 34.31, height: 34.31)
//
//            Text(text)
//                .font(.system(size: 16))
//                .foregroundColor(.black)
//
//            Spacer()
//        }
//    }
//}
//
//struct BottomNavBar: View {
//    @Binding var showInstructions: Bool
//    @Binding var selectedNavItem: String?
//    @Binding var showHistoryView: Bool // ✅ Added for HistoryView navigation
//    @Binding var detectedItemName: String // ✅ Receives detected object name
//    @Binding var detectedItemQTY: Int // ✅ Receives object count
//    @Binding var captureDate: String // ✅ Receives capture date
//    var userName: String // ✅ Added userName
//    var capturePhotoAction: () -> Void
//
//    var body: some View {
//        HStack {
//            NavBarItem(imageName: "history", text: "History", selectedNavItem: $selectedNavItem) {
//                // ✅ Simulate detected item data (replace with real detection logic)
//                detectedItemName = "Tomato"
//                detectedItemQTY = 3
//                captureDate = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short)
//
//                showHistoryView = true // ✅ Open HistoryView when tapped
//            }
//
//            NavBarItem(imageName: "counter", text: "Counter", selectedNavItem: $selectedNavItem, action: {
//                capturePhotoAction()
//            })
//
//            NavBarItem(imageName: "Instructions", text: "Instructions", selectedNavItem: $selectedNavItem) {
//                showInstructions = true
//            }
//        }
//    }
//}
//
//struct NavBarItem: View {
//    var imageName: String
//    var text: String
//    @Binding var selectedNavItem: String?
//    var action: (() -> Void)?
//
//    var isSelected: Bool {
//        selectedNavItem == text
//    }
//
//    var body: some View {
//        VStack {
//            Button(action: {
//                selectedNavItem = text
//                action?()
//            }) {
//                ZStack {
//                    Circle()
//                        .fill(isSelected && text == "Counter" ? Color("Green") : Color(.systemGray5))
//                        .frame(
//                            width: text == "Counter" ? 90.63 : 71.84,
//                            height: text == "Counter" ? 90.85 : 73.34
//                        )
//
//                    Image(isSelected && text == "Counter" ? "white_counter" : imageName)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(
//                            width: text == "Counter" ? 55.62 : 44.88,
//                            height: text == "Counter" ? 55.58 : 44.86
//                        )
//                        .foregroundColor(isSelected && text == "Counter" ? .white : .gray)
//                }
//            }
//
//            Text(text)
//                .font(.system(size: 14))
//                .foregroundColor(isSelected ? Color("Green") : .gray)
//        }
//        .padding(.horizontal, 22)
//    }
//}
//
//class SoundPlayer {
//    var player: AVAudioPlayer?
//
//    func playSound() {
//        if let soundURL = Bundle.main.url(forResource: "CounterSound", withExtension: "mp3") {
//            do {
//                player = try AVAudioPlayer(contentsOf: soundURL)
//                player?.play()
//            } catch {
//                print("Error playing sound: \(error.localizedDescription)")
//            }
//        } else {
//            print("Sound file not found!")
//        }
//    }
//}
import SwiftUI
import AVFoundation

struct CamButton: View {
    @State private var showInstructions = true
    @State private var selectedNavItem: String? = nil
    @State private var showHistoryView = false // ✅ Controls HistoryView presentation
    @State private var itemName: String = "" // ✅ Renamed from detectedItemName
    @State private var totalProducts: Int = 0 // ✅ Renamed from detectedItemQTY
    @State private var date: String = "" // ✅ Renamed from captureDate

    var userName: String // ✅ Added userName
    var capturePhotoAction: () -> Void
    let soundPlayer = SoundPlayer()

    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                if showInstructions {
                    InstructionBox(showInstructions: $showInstructions)
                }
                
                Spacer()
                
                BottomNavBar(
                    showInstructions: $showInstructions,
                    selectedNavItem: $selectedNavItem,
                    showHistoryView: $showHistoryView, // ✅ Pass state for History
                    itemName: $itemName, // ✅ Updated variable name
                    totalProducts: $totalProducts, // ✅ Updated variable name
                    date: $date, // ✅ Updated variable name
                    userName: userName, // ✅ Pass userName
                    capturePhotoAction: {
                        soundPlayer.playSound()
                        capturePhotoAction()
                    }
                )
            }
        }
        .fullScreenCover(isPresented: $showHistoryView) { // ✅ Show HistoryView fullscreen with correct data
            HistoryView(
                 itemName: itemName, // ✅ Updated variable name
                 totalProducts: totalProducts, // ✅ Updated variable name
                 date: date, // ✅ Updated variable name
                 userName: userName // ✅ Pass userName correctly
             )
        }
    }
}

struct InstructionBox: View {
    @Binding var showInstructions: Bool

    var body: some View {
        VStack(spacing: 12) {
            InstructionRow(imageName: "adjust", text: "Adjust on wide view")
            InstructionRow(imageName: "arrange", text: "Arrange vegetables neatly")
            InstructionRow(imageName: "surface", text: "Use a flat surface")
            InstructionRow(imageName: "light", text: "Ensure good lighting")

            Divider()

            Button("Done") {
                showInstructions = false
            }
            .foregroundColor(Color("Green"))
            .padding(.top, 4)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(radius: 5)
        .frame(width: 280)
    }
}

struct InstructionRow: View {
    var imageName: String
    var text: String

    var body: some View {
        HStack {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 34.31, height: 34.31)

            Text(text)
                .font(.system(size: 16))
                .foregroundColor(.black)

            Spacer()
        }
    }
}

struct BottomNavBar: View {
    @Binding var showInstructions: Bool
    @Binding var selectedNavItem: String?
    @Binding var showHistoryView: Bool // ✅ Added for HistoryView navigation
    @Binding var itemName: String // ✅ Updated variable name
    @Binding var totalProducts: Int // ✅ Updated variable name
    @Binding var date: String // ✅ Updated variable name
    var userName: String // ✅ Added userName
    var capturePhotoAction: () -> Void

    var body: some View {
        HStack {
            NavBarItem(imageName: "history", text: "History", selectedNavItem: $selectedNavItem) {
                // ✅ Simulate detected item data (replace with real detection logic)
                itemName = "Tomato"
                totalProducts = 3
                date = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short)

                showHistoryView = true // ✅ Open HistoryView when tapped
            }

            NavBarItem(imageName: "counter", text: "Counter", selectedNavItem: $selectedNavItem, action: {
                capturePhotoAction()
            })

            NavBarItem(imageName: "Instructions", text: "Instructions", selectedNavItem: $selectedNavItem) {
                showInstructions = true
            }
        }
    }
}

struct NavBarItem: View {
    var imageName: String
    var text: String
    @Binding var selectedNavItem: String?
    var action: (() -> Void)?

    var isSelected: Bool {
        selectedNavItem == text
    }

    var body: some View {
        VStack {
            Button(action: {
                selectedNavItem = text
                action?()
            }) {
                ZStack {
                    Circle()
                        .fill(isSelected && text == "Counter" ? Color("Green") : Color(.systemGray5))
                        .frame(
                            width: text == "Counter" ? 90.63 : 71.84,
                            height: text == "Counter" ? 90.85 : 73.34
                        )

                    Image(isSelected && text == "Counter" ? "white_counter" : imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: text == "Counter" ? 55.62 : 44.88,
                            height: text == "Counter" ? 55.58 : 44.86
                        )
                        .foregroundColor(isSelected && text == "Counter" ? .white : .gray)
                }
            }

            Text(text)
                .font(.system(size: 14))
                .foregroundColor(isSelected ? Color("Green") : .gray)
        }
        .padding(.horizontal, 22)
    }
}

class SoundPlayer {
    var player: AVAudioPlayer?

    func playSound() {
        if let soundURL = Bundle.main.url(forResource: "CounterSound", withExtension: "mp3") {
            do {
                player = try AVAudioPlayer(contentsOf: soundURL)
                player?.play()
            } catch {
                print("Error playing sound: \(error.localizedDescription)")
            }
        } else {
            print("Sound file not found!")
        }
    }
}
