//
//  CamButton.swift
//  Hasadekk
//
//  Created by BASHAER AZIZ on 03/09/1446 AH.
//
import SwiftUI

struct CamButton: View {
    @State private var showInstructions = true
    @State private var selectedNavItem: String? = nil
    var capturePhotoAction: () -> Void

    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                if showInstructions {
                    InstructionBox(showInstructions: $showInstructions)
                }
                
                Spacer()
                
                BottomNavBar(showInstructions: $showInstructions, selectedNavItem: $selectedNavItem, capturePhotoAction: capturePhotoAction) 
            }
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
    var capturePhotoAction: () -> Void
    
    var body: some View {
        HStack {
            NavBarItem(imageName: "history", text: "History", selectedNavItem: $selectedNavItem)
            NavBarItem(imageName: "counter", text: "Counter", selectedNavItem: $selectedNavItem, action: capturePhotoAction)
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
