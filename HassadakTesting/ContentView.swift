
import SwiftUI

import AVFoundation
struct ContentView: View {
    @Binding var userName: String
    
    var body: some View {
        CameraView(userName: $userName)
            .edgesIgnoringSafeArea(.all)
    }
}
