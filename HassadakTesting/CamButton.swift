//
//  CamButton.swift
//  Hasadekk
//
//  Created by BASHAER AZIZ on 03/09/1446 AH.
//

import SwiftUI

struct CamButton: View {
    @State private var showInstructions = false
    @State private var selectedNavItem: String? = nil

    var onCapture: () -> Void

    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                if showInstructions {
                    InstructionBox(showInstructions: $showInstructions)
                }
                
                Spacer()
                
                BottomNavBar(showInstructions: $showInstructions, selectedNavItem: $selectedNavItem, onCapture: onCapture)
            }
        }
    }
}

struct BottomNavBar: View {
    @Binding var showInstructions: Bool
    @Binding var selectedNavItem: String?
    var onCapture: () -> Void
    
    var body: some View {
        HStack {
            NavBarItem(imageName: "history", text: "History", selectedNavItem: $selectedNavItem)
            NavBarItem(imageName: "counter", text: "Counter", selectedNavItem: $selectedNavItem, action: onCapture)
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
                        .frame(width: text == "Counter" ? 90.63 : 71.84, height: text == "Counter" ? 90.85 : 73.34)
                    
                    Image(isSelected && text == "Counter" ? "white_counter" : imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: text == "Counter" ? 55.62 : 44.88, height: text == "Counter" ? 55.58 : 44.86)
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
