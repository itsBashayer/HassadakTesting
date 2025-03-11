import SwiftUI

struct OnboardingView: View {
    @State private var selection = 0 // Track the current page
    @State private var isActive = false // Control navigation
    
    let onboardingData = [
        ("onboarding1", ""),
        ("onboarding2", ""),
        ("onboarding3", "Please add your name")
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                TabView(selection: $selection) {
                    ForEach(0..<onboardingData.count, id: \.self) { index in
                        OnboardingScreen(
                            imageName: onboardingData[index].0,
                            description: onboardingData[index].1,
                            selection: $selection,
                            isActive: $isActive
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .ignoresSafeArea()
            }
            .navigationDestination(isPresented: $isActive) {
                ContentView()
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}

struct OnboardingScreen: View {
    var imageName: String
    var description: String
    @Binding var selection: Int // Track onboarding page
    @Binding var isActive: Bool // Navigation control
    @State private var userName: String = "" // Store user name input
    
    var body: some View {
        ZStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .clipped()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text(description)
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundColor(.white)
                    .padding()
                
                if imageName == "onboarding3" {
                    TextField("Enter your name", text: $userName)
                        .font(.system(size: 16))
                        .padding(10)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                        .frame(height: 40)
                        .frame(width: 294)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 1)
                        )
                        .padding(.bottom, 140)
                        .autocapitalization(.words)
                        .disableAutocorrection(false)
                        .padding(.horizontal)
                    
//                    Button(action: {
//                        if !userName.isEmpty {
//                            UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
//                            isActive = true
//                        }
//                    }) {
//                        Text("Start")
//                            .fontWeight(.bold)
//                            .foregroundColor(Color("green1"))
//                            .font(.body)
//                            .frame(width: 260, height: 46)
//                            .background(userName.isEmpty ? Color.white : Color.white)
//                            .cornerRadius(12)
//                            .padding(60)
//                    }
//                    .disabled(userName.isEmpty) // Disable the button if name is empty
                    Button(action: {
                        if !userName.isEmpty {
                            isActive = true
                        }
                    }) {
                        NavigationLink(
                            destination: HistoryView(
                                selectedItemName: "",
                                selectedItemQTY: 0,
                                captureDate: "",
                                userName: userName // ✅ Pass userName to HistoryView
                            ),
                            isActive: $isActive
                        ) {
                            Text("Start")
                                .fontWeight(.bold)
                                .foregroundColor(Color("green1"))
                                .font(.body)
                                .frame(width: 260, height: 46)
                                .background(userName.isEmpty ? Color.white : Color.white)
                                .cornerRadius(12)
                                .padding(60)
                        }
                    }
                    .disabled(userName.isEmpty) // Disable button if name is empty

                } else {
                    Spacer()
                }
            }
        }
        .background(Color.clear)
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    OnboardingView()
}
