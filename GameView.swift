//
//  GameView.swift
//  Phish Finder
//
//  Created by Ethan Ondreicka on 2/10/25.
//

import SwiftUI
import CoreHaptics
import UIKit
import AVFoundation
import Foundation

class GameProgress: ObservableObject {
    @Published var currentLevelIndex: Int {
        didSet {
            UserDefaults.standard.set(currentLevelIndex, forKey: "currentLevelIndex")
        }
    }
    
    @Published var score: Int {
        didSet {
            UserDefaults.standard.set(score, forKey: "score")
            updateRank()
        }
    }
    
    @Published var rank: String {
        didSet {
            UserDefaults.standard.set(rank, forKey: "rank")
        }
    }
    
    @Published var completedLevels: Set<Int> {
        didSet {
            UserDefaults.standard.set(Array(completedLevels), forKey: "completedLevels")
        }
    }
    
    @Published var lives: Int {
        didSet {
            UserDefaults.standard.set(lives, forKey: "lives")
        }
    }
    
    @Published var selectedLevels: [Level]
    
    @Published var isFirstPlaythrough: Bool {
        didSet {
            UserDefaults.standard.set(isFirstPlaythrough, forKey: "isFirstPlaythrough")
        }
    }
    
    init() {
        self.currentLevelIndex = UserDefaults.standard.integer(forKey: "currentLevelIndex")
        self.score = UserDefaults.standard.integer(forKey: "score")
        self.rank = UserDefaults.standard.string(forKey: "rank") ?? ""
        self.completedLevels = Set(UserDefaults.standard.array(forKey: "completedLevels") as? [Int] ?? [])
        self.lives = UserDefaults.standard.integer(forKey: "lives") == 0 ? 3 : UserDefaults.standard.integer(forKey: "lives")
        self.isFirstPlaythrough = UserDefaults.standard.object(forKey: "isFirstPlaythrough") as? Bool ?? true
        
        let easyLevels = levels.filter { $0.difficulty == .easy }.shuffled().prefix(5)
        let mediumLevels = levels.filter { $0.difficulty == .medium }.shuffled().prefix(5)
        let hardLevels = levels.filter { $0.difficulty == .hard }.shuffled().prefix(5)
        self.selectedLevels = (easyLevels + mediumLevels + hardLevels).map { $0 }
        
        updateRank()
    }
    
    private func updateRank() {
        switch score {
        case 0..<400:
            rank = "Phishing Beginner"
        case 400..<700:
            rank = "Phishing Novice"
        case 700..<1000:
            rank = "Phishing Detective"
        case 1000..<1300:
            rank = "Phishing Expert"
        case 1300...:
            rank = "Phishing Master"
        default:
            rank = "Unranked"
        }
        UserDefaults.standard.set(rank, forKey: "rank")
    }
    
    func resetProgress() {
        currentLevelIndex = 0
        score = 0
        rank = "Unranked"
        lives = 3
        
        let easyLevels = levels.filter { $0.difficulty == .easy }.shuffled().prefix(5)
        let mediumLevels = levels.filter { $0.difficulty == .medium }.shuffled().prefix(5)
        let hardLevels = levels.filter { $0.difficulty == .hard }.shuffled().prefix(5)
        self.selectedLevels = (easyLevels + mediumLevels + hardLevels).map { $0 }
        completedLevels.removeAll()
        UserDefaults.standard.removeObject(forKey: "currentLevelIndex")
        UserDefaults.standard.removeObject(forKey: "rank")
        UserDefaults.standard.removeObject(forKey: "score")
        UserDefaults.standard.removeObject(forKey: "lives")
        UserDefaults.standard.removeObject(forKey: "completedLevels")
        updateRank()
    }
}

@MainActor
class SoundManager {
    static let shared = SoundManager()
    var audioPlayer: AVAudioPlayer?
    
    func playSound(named soundName: String) {
        if let player = audioPlayer, player.isPlaying {
            player.stop()
        }
        
        // trys .wav first then .mp3
        guard let soundURL = Bundle.main.url(forResource: soundName, withExtension: "wav") ??
                Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()
            if audioPlayer?.play() == false {
                print("Failed to play sound")
            } else {
                print("Playing sound ")
            }
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
}
enum Difficulty: String {
    case easy
    case medium
    case hard
    case tutorial
}

struct Level {
    let emailText: String
    let isFishing: Bool
    let toEmail: String
    let fromEmail: String
    let levelNumber: Int
    let subjectLine: String
    let emailLink: String
    let explanation: String
    let difficulty: Difficulty
}

let darkRed = Color(red: 0.99, green: 0.20, blue: 0.20)

struct GameView: View {
    @StateObject private var gameProgress = GameProgress()
    
    var body: some View {
        NavigationStack {
            if gameProgress.isFirstPlaythrough {
                TutorialView()
                    .environmentObject(gameProgress)
            } else {
                GameViewContent()
                    .environmentObject(gameProgress)
            }
        }
    }
}

struct GameViewContent: View {
    @EnvironmentObject var gameProgress: GameProgress
    @State private var userAnswerIsFishing = false
    @State private var hasAnswered = false
    @State private var isCurrentAnswerCorrect: Bool = false
    @State private var showFeedback = false
    @State private var navigateToGameOver = false
    
    private var headerColor: Color {
        switch gameProgress.selectedLevels[gameProgress.currentLevelIndex].difficulty {
        case .tutorial:
            return tutorialBlue
        case .easy:
            return lightBlue
        case .medium:
            return mediumBlue
        case .hard:
            return darkBlue
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white.edgesIgnoringSafeArea(.all)
                VStack(spacing: 20) {
                    HStack {
                        Text("Level \(gameProgress.currentLevelIndex + 1)  Score: \(gameProgress.score)")
                        Spacer()
                        Text("Lives: \(gameProgress.lives)")
                            .foregroundColor(gameProgress.lives <= 1 ? .red : .white)
                    }
                    .font(.custom("Helvetica", size: geometry.size.height * 0.045))
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(headerColor)
                    .foregroundColor(.white)
                    .padding(.top, -10)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text(gameProgress.selectedLevels[gameProgress.currentLevelIndex].subjectLine)
                            .font(.custom("Helvetica", size: geometry.size.height * 0.035))
                            .foregroundColor(.black)
                            .bold()
                        
                        Text("From: ").foregroundColor(.black) + Text(gameProgress.selectedLevels[gameProgress.currentLevelIndex].fromEmail).foregroundColor(.blue)
                        Text("To: ").foregroundColor(.black) + Text(gameProgress.selectedLevels[gameProgress.currentLevelIndex].toEmail).foregroundColor(.blue)
                    }
                    .font(.custom("Helvetica", size: geometry.size.height * 0.025))
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    ScrollView {
                        Text(gameProgress.selectedLevels[gameProgress.currentLevelIndex].emailText)
                            .font(.custom("Helvetica", size: geometry.size.height * 0.035))
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(8)
                        
                        Text(gameProgress.selectedLevels[gameProgress.currentLevelIndex].emailLink)
                            .font(.custom("Helvetica", size: geometry.size.height * 0.03))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.blue)
                            .padding(.top, -10)
                            .padding(.horizontal, 19)
                    }
                    .frame(maxHeight: 550)
                    
                    Spacer()
                    
                    HStack(spacing: 20) {
                        Button(action: {
                            if !hasAnswered {
                                userAnswerIsFishing = false
                                processAnswer()
                            }
                        }) {
                            Text("Real")
                                .font(.custom("Helvetica", size: geometry.size.height * 0.04))
                                .fontWeight(.semibold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(red: 0.02, green: 0.57, blue: 0.26), lineWidth: 6)
                                )
                        }
                        Button(action: {
                            if !hasAnswered {
                                userAnswerIsFishing = true
                                processAnswer()
                            }
                        }) {
                            Text("Fake")
                                .font(.custom("Helvetica", size: geometry.size.height * 0.04))
                                .fontWeight(.semibold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .border(darkRed, width: 2)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(red: 0.61, green: 0.14, blue: 0.13), lineWidth: 6)
                                )
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 50)
                }
                
                if showFeedback {
                    backgroundBlue.opacity(0.95)
                        .edgesIgnoringSafeArea(.all)
                    VStack(spacing: 20) {
                        Text(isCurrentAnswerCorrect ? "Level Complete!" : "Incorrect")
                            .font(.custom("Helvetica", size: geometry.size.height * 0.045))
                            .fontWeight(.bold)
                            .foregroundColor(isCurrentAnswerCorrect ? .green : .red)
                            .padding(10)
                        
                        Text("Explanation: \(gameProgress.selectedLevels[gameProgress.currentLevelIndex].explanation)")
                            .font(.custom("Helvetica", size: geometry.size.height * 0.035))
                            .fontWeight(.bold)
                            .padding(.top)
                            .foregroundColor(.black)
                        
                        Text("Lives Left: \(gameProgress.lives)")
                            .font(.custom("Helvetica", size: geometry.size.height * 0.03))
                            .padding(.top)
                        
                        Button(action: {
                            nextLevel()
                        }) {
                            Text(isCurrentAnswerCorrect ? "Next Level" : "Continue")
                                .font(.custom("Helvetica", size: geometry.size.height * 0.035))
                                .fontWeight(.semibold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(lightBlue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(isCurrentAnswerCorrect ? Color(red: 0.37, green: 0.55, blue: 0.70) : Color(red: 0.35, green: 0.35, blue: 0.37), lineWidth: 6)
                                )
                        }
                        .padding(.horizontal, 40)
                        
                        Button(action: {
                            gameProgress.resetProgress()
                            resetForNextAction()
                            navigateToGameOver = false
                            showFeedback = false
                        }) {
                            Text("Restart")
                                .font(.custom("Helvetica", size: geometry.size.height * 0.030))
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
                        }
                        .padding(.horizontal, 60)
                        
                        NavigationLink(destination: MainMenuView().navigationBarBackButtonHidden(true)) {
                            Text("Home")
                                .font(.custom("Helvetica", size: geometry.size.height * 0.030))
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

                        }
                        .padding(.bottom, 20)
                        .padding(.horizontal, 60)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .padding(.horizontal, 40)
                }
            }
            .navigationDestination(isPresented: $navigateToGameOver) {
                GameOverView(finalScore: gameProgress.score, finalRank: gameProgress.rank)
                    .navigationBarBackButtonHidden(true)
            }
            .onAppear {
                navigateToGameOver = false
                showFeedback = false
            }
        }
    }
    
    private func processAnswer() {
        hasAnswered = true
        isCurrentAnswerCorrect = (userAnswerIsFishing == gameProgress.selectedLevels[gameProgress.currentLevelIndex].isFishing)
        
        let soundEnabled = UserDefaults.standard.bool(forKey: "soundEnabled")
        let hapticsEnabled = UserDefaults.standard.bool(forKey: "hapticsEnabled")

        if isCurrentAnswerCorrect {
            gameProgress.score += 100
            if hapticsEnabled {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            }
            if soundEnabled {
                SoundManager.shared.playSound(named: "right_answer")
            }
        } else {
            gameProgress.lives -= 1
            if hapticsEnabled {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.error)
            }
            if soundEnabled {
                SoundManager.shared.playSound(named: "wrong_answer")
            }
        }

        // Check if last level
        if gameProgress.currentLevelIndex == gameProgress.selectedLevels.count - 1 {
            navigateToGameOver = true
        } else {
            showFeedback = true
        }
    }
    
    private func nextLevel() {
        if gameProgress.lives <= 0 {
            navigateToGameOver = true
        } else {
            gameProgress.completedLevels.insert(gameProgress.currentLevelIndex)
            gameProgress.currentLevelIndex += 1
        }
        resetForNextAction()
    }
    
    private func resetForNextAction() {
        hasAnswered = false
        userAnswerIsFishing = false
        isCurrentAnswerCorrect = false
        showFeedback = false
    }
}
