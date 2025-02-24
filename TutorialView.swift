//
//  TutorialView.swift
//  Phish Finder
//
//  Created by Ethan Ondreicka on 2/11/25.
//

import SwiftUI

struct TutorialView: View {
    @State private var step = 1
    @State private var navigateToGame = false
    @EnvironmentObject var gameProgress: GameProgress
    
    private var tutorialLevel: Level {
        levels.first(where: { $0.difficulty == .tutorial })!
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    Color.white.opacity(0.03)
                        .edgesIgnoringSafeArea(.all)
                    // email elements
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(tutorialLevel.subjectLine)
                                .font(.custom("Helvetica", size: geometry.size.height * 0.035))
                                .foregroundColor(.black)
                                .bold()
                                .padding(4)
                                .background(step == 2 ? Color.white : Color.clear)
                                .cornerRadius(5)
                            
                            HStack {
                                Text("From: ")
                                    .foregroundColor(.black)
                                Text(tutorialLevel.fromEmail)
                                    .foregroundColor(.blue)
                                    .padding(4)
                                    .background(step == 3 ? Color.white : Color.clear)
                                    .cornerRadius(5)
                            }
                            
                            HStack {
                                Text("To: ")
                                    .foregroundColor(.black)
                                Text(tutorialLevel.toEmail)
                                    .foregroundColor(.blue)
                            }
                        }
                        .font(.custom("Helvetica", size: geometry.size.height * 0.025))
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                        
                        Spacer()
                        
                        ScrollView {
                            VStack(alignment: .leading, spacing: 10) {
                                Text(tutorialLevel.emailText)
                                    .font(.custom("Helvetica", size: geometry.size.height * 0.035))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(.black)
                                
                                Text(tutorialLevel.emailLink)
                                    .font(.custom("Helvetica", size: geometry.size.height * 0.03))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(.blue)
                            }
                            .padding()
                            .background(step == 4 ? Color.white : Color.clear)
                            .cornerRadius(8)
                        }
                        .frame(maxHeight: geometry.size.height * 0.35)
                        
                        Spacer()
                        
                        HStack(spacing: 20) {
                            Text("Real")
                                .font(.custom("Helvetica", size: geometry.size.height * 0.04))
                                .fontWeight(.semibold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(step == 5 ? Color.white : Color.green.opacity(0.3))
                                .foregroundColor(.black)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(red: 0.02, green: 0.57, blue: 0.26), lineWidth: 6)
                                )
                            
                            Text("Fake")
                                .font(.custom("Helvetica", size: geometry.size.height * 0.04))
                                .fontWeight(.semibold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(step == 5 ? Color.white : Color.red.opacity(0.3))
                                .foregroundColor(.black)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(red: 0.61, green: 0.14, blue: 0.13), lineWidth: 6)
                                )
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 50)
                    }
                    
                    // text bubbles
                    VStack {
                        if step == 1 {
                            Text("Welcome to Phish Finder! Your job is to analyze emails and decide if they're real or fake.")
                                .font(.custom("Helvetica", size: geometry.size.height * 0.03))
                                .foregroundColor(Color.black)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(radius: 3)
                                .frame(width: geometry.size.width * 0.9)
                                .position(x: geometry.size.width / 2, y: geometry.size.height / 2.2)
                            
                            Text("Tap Anywhere to Continue")
                                .font(.custom("Helvetica", size: geometry.size.height * 0.03))
                                .fontWeight(.semibold)
                                .foregroundColor(Color.gray)
                                .multilineTextAlignment(.center)
                                .padding()
                                .cornerRadius(12)
                                .shadow(radius: 3)
                                .frame(width: geometry.size.width * 0.9)
                                .position(x: geometry.size.width / 2, y: geometry.size.height / 5.2)
                        } else if step == 2 {
                            Text("Look at the subject line carefully. Scammers often use urgent or exciting messages to trick you!")
                                .font(.custom("Helvetica", size: geometry.size.height * 0.03))
                                .fontWeight(.semibold)
                                .padding()
                                .foregroundColor(Color.black)
                                .multilineTextAlignment(.center)
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(radius: 3)
                                .frame(width: geometry.size.width * 0.9)
                                .position(x: geometry.size.width / 2, y: geometry.size.height * 0.4)
                            Text("Tap Anywhere to Continue")
                                .font(.custom("Helvetica", size: geometry.size.height * 0.03))
                                .fontWeight(.semibold)
                                .foregroundColor(Color.gray)
                                .multilineTextAlignment(.center)
                                .padding()
                                .cornerRadius(12)
                                .shadow(radius: 3)
                                .frame(width: geometry.size.width * 0.9)
                                .position(x: geometry.size.width / 2, y: geometry.size.height / 5.2)
                        } else if step == 3 {
                            Text("Check the sender’s email! Fake emails may use small changes to look real.")
                                .font(.custom("Helvetica", size: geometry.size.height * 0.03))
                                .fontWeight(.semibold)
                                .foregroundColor(Color.black)
                                .padding()
                                .background(Color.white)
                                .multilineTextAlignment(.center)
                                .cornerRadius(12)
                                .shadow(radius: 3)
                                .frame(width: geometry.size.width * 0.9)
                                .position(x: geometry.size.width / 2, y: geometry.size.height * 0.45)
                            Text("Tap Anywhere to Continue")
                                .font(.custom("Helvetica", size: geometry.size.height * 0.03))
                                .fontWeight(.semibold)
                                .foregroundColor(Color.gray)
                                .multilineTextAlignment(.center)
                                .padding()
                                .cornerRadius(12)
                                .shadow(radius: 3)
                                .frame(width: geometry.size.width * 0.9)
                                .position(x: geometry.size.width / 2, y: geometry.size.height / 5.2)
                        } else if step == 4 {
                            Text("Read the email carefully. Look for grammar mistakes, odd phrases, or urgent demands.")
                                .font(.custom("Helvetica", size: geometry.size.height * 0.03))
                                .fontWeight(.semibold)
                                .foregroundColor(Color.black)
                                .padding()
                                .background(Color.white)
                                .multilineTextAlignment(.center)
                                .cornerRadius(12)
                                .shadow(radius: 3)
                                .frame(width: geometry.size.width * 0.9)
                                .position(x: geometry.size.width / 2, y: geometry.size.height * 0.65)
                            Text("Tap Anywhere to Continue")
                                .font(.custom("Helvetica", size: geometry.size.height * 0.03))
                                .fontWeight(.semibold)
                                .foregroundColor(Color.gray)
                                .multilineTextAlignment(.center)
                                .padding()
                                .cornerRadius(12)
                                .shadow(radius: 3)
                                .frame(width: geometry.size.width * 0.9)
                                .position(x: geometry.size.width / 2, y: geometry.size.height / 3.6)
                        } else if step == 5 {
                            Text("Now are you ready to determine if emails are real or fake?")
                                .font(.custom("Helvetica", size: geometry.size.height * 0.03))
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.black)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(radius: 3)
                                .frame(width: geometry.size.width * 0.9)
                                .position(x: geometry.size.width / 2, y: geometry.size.height * 0.75)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                }
                .onTapGesture {
                    if step < 5 {
                        step += 1
                    } else {
                        gameProgress.isFirstPlaythrough = false
                        navigateToGame = true
                    }
                }
                .navigationDestination(isPresented: $navigateToGame) {
                    GameViewContent()
                        .environmentObject(gameProgress)
                        .navigationBarBackButtonHidden(true)
                }
            }
        }
    }
}

