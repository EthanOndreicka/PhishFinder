import SwiftUI
import AVFoundation

struct StartUpView: View {
    @State private var isActive = false
    
    var body: some View {
        VStack {
            if isActive {
                MainMenuView()
            } else {
                VStack {
                    Image("Self-Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                        .padding(-30)
                }
                .onAppear {
                    SoundManager.shared.playSound(named: "startup-sound")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation {
                            self.isActive = true
                        }
                    }
                }
            }
        }
    }
    
}


