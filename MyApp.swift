import SwiftUI

@main
struct Phish_FinderApp: App {
    init() {
            UserDefaults.standard.register(defaults: [
                "soundEnabled": true,
                "hapticsEnabled": true
            ])
    }
    var body: some Scene {
        WindowGroup {
            StartUpView()
        }
    }
}
