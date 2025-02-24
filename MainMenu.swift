//
//  MainMenu.swift
//  Phish Finder
//
//  Created by Ethan Ondreicka on 2/10/25.
//

import SwiftUI
import AVFoundation

let tutorialBlue = Color(red: 0.47, green: 0.60, blue: 0.84)
let lightBlue = Color(red: 0.47, green: 0.70, blue: 0.84)
let mediumBlue = Color(red: 0.36, green: 0.44, blue: 0.70)
let darkBlue = Color(red: 0.20, green: 0.20, blue: 0.48)
let backgroundBlue = Color(red: 0.01, green: 0.12, blue: 0.23)

struct MainMenuView: View {
    @AppStorage("soundEnabled") private var soundEnabled = true
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundBlue.edgesIgnoringSafeArea(.all)
                
                Image("BackGroundImage")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 350, height: 350)
                        .padding(-30)
                    
                    NavigationLink(destination: GameView().navigationBarBackButtonHidden(true)) {
                        Text("Start Finding")
                            //.font(.title2)
                            .font(.custom("ChalkboardSE-Bold", size: 30))
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(lightBlue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(red: 0.37, green: 0.55, blue: 0.70), lineWidth: 6)
                            )
                            .simultaneousGesture(TapGesture().onEnded { _ in
                                                    playSplashSound()
                                                })
                            .padding(.horizontal, 40)
                    }
                    
                    NavigationLink(destination: SettingsView().navigationBarBackButtonHidden(true)) {
                        Text("Settings")
                            .font(.custom("ChalkboardSE-Bold", size: 30))
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(mediumBlue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(red: 0.26, green: 0.34, blue: 0.60), lineWidth: 6)
                            )
                            .padding(.horizontal, 40)
                    }
                    
                    NavigationLink(destination: AboutView().navigationBarBackButtonHidden(true)) {
                        Text("About")
                            .font(.custom("ChalkboardSE-Bold", size: 30))
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(darkBlue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(red: 0.15, green: 0.15, blue: 0.38), lineWidth: 6)
                            )
                            .padding(.horizontal, 40)
                    }
                }
            }
        }
    }
    private func playSplashSound() {
        guard soundEnabled else { return }
        SoundManager.shared.playSound(named: "water-splash")
    }
}


