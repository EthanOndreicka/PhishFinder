//
//  GameOverView.swift
//  Phish Finder
//
//  Created by Ethan Ondreicka on 2/12/25.
//

import SwiftUI
import AVFoundation

struct GameOverView: View {
    var finalScore: Int
    var finalRank: String
    
    @AppStorage("soundEnabled") private var soundEnabled = true
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                backgroundBlue
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 30) {
                        Text("Game Over!")
                            .font(.custom("ChalkboardSE-Bold", size: geometry.size.height * 0.065))
                            .fontWeight(.bold)
                            .foregroundColor(Color.red)
                            .padding(.top, 20)
                        
                        VStack(spacing: 15) {
                            Text("Final Score: \(finalScore)")
                                .font(.custom("ChalkboardSE-Bold", size: geometry.size.height * 0.053))
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.top, 40)
                            
                            Text("Your Rank:")
                                .font(.custom("ChalkboardSE-Bold", size: geometry.size.height * 0.041))
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.top, 40)
                            
                            Text(finalRank)
                                .font(.custom("ChalkboardSE-Bold", size: geometry.size.height * 0.047))
                                .fontWeight(.bold)
                                .foregroundColor(.yellow)
                                .padding(.top, -10)
                        }
                        .multilineTextAlignment(.center)
                        
                        Spacer()
                        
                        NavigationLink(destination: MainMenuView().onAppear {
                            GameProgress().resetProgress()
                        }.navigationBarBackButtonHidden(true)) {
                            Text("Return to Main Menu")
                                .font(.custom("ChalkboardSE-Bold", size: geometry.size.height * 0.028))
                                .fontWeight(.bold)
                                .padding()
                                .frame(maxWidth: 480)
                                .background(darkBlue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(red: 0.15, green: 0.15, blue: 0.38), lineWidth: 6)
                                )
                        }
                        .padding(.bottom, 80)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                    .padding(.top, 80)
                }
            }
        }
        .onAppear {
            playGameOverSound()
        }
    }
    
    private func playGameOverSound() {
        if soundEnabled {
            SoundManager.shared.playSound(named: "game-over")
        }
    }
}

