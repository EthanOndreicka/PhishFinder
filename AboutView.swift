//
//  AboutView.swift
//  Phish Finder
//
//  Created by Ethan Ondreicka on 2/10/25.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
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
                    Image("White-Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                        .padding(.bottom, -10)
                    
                    Text("About This App")
                        .font(.custom("ChalkboardSE-Bold", size: 28))
                        .foregroundColor(.white)
                    
                    Text("This app was made to gamify the process of phishing training. It is a fun app that can help you practice your detection skills in a fun and engaging way. This app was inspired by my Cyber Security Professor Dominic Foti and his PhD thesis. \n\n------")
                        .font(.custom("ArialRoundedMTBold ", size: 21))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 7)
                    
                    Text("Thank you to MaryJo Garcia for play testing this app and inspiring me to create new features.")
                        .font(.custom("ArialRoundedMTBold ", size: 21))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .padding(.vertical, -20)

                    
                    Text("Created by Ethan Ondreicka")
                        .font(.custom("Menlo-Bold", size: 15))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 10)
                    
                   
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Back")
                            .font(.custom("ChalkboardSE-Bold", size: 25))
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
                            .padding(.bottom, 20)
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.top, -40)
            }
        }
    }
}

