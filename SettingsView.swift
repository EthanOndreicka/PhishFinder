//
//  SettingsView.swift
//  Phish Finder
//
//  Created by Ethan Ondreicka on 2/10/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("soundEnabled") private var soundEnabled = true
    @AppStorage("hapticsEnabled") private var hapticsEnabled = true
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                backgroundBlue.edgesIgnoringSafeArea(.all)
                
                Image("BackGroundImage")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 30) {
                    Text("Settings")
                        .font(.custom("ChalkboardSE-Bold", size: 40))
                        .foregroundColor(.white)
                    
                    // Sound Toggle
                    Toggle(isOn: $soundEnabled) {
                        Text("Sound")
                            .font(.custom("ChalkboardSE-Bold", size: 30))
                            .foregroundColor(.white)
                    }
                    .toggleStyle(SwitchToggleStyle(tint: lightBlue))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(mediumBlue)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(red: 0.26, green: 0.34, blue: 0.60), lineWidth: 6)
                    )
                    .padding(.horizontal, 40)
                    
                    // Haptics Toggle
                    Toggle(isOn: $hapticsEnabled) {
                        Text("Haptics")
                            .font(.custom("ChalkboardSE-Bold", size: 30))
                            .foregroundColor(.white)
                    }
                    .toggleStyle(SwitchToggleStyle(tint: lightBlue))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(mediumBlue)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(red: 0.26, green: 0.34, blue: 0.60), lineWidth: 6)
                    )
                    .padding(.horizontal, 40)
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Back")
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
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.top, 40)
            }
        }
    }
}
