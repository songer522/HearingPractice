//
//  ContentView.swift
//  HearingPractice
//
//  Created by Yang Song on 6/29/24.
//

import SwiftUI
import SwiftData
import AVFoundation

struct ContentView: View {
    @State private var selectedSounds = [String: [URL]]()
    @ObservedObject var audioRecorder = AudioRecorder()
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: AudioExerciseView(selectedSounds: $selectedSounds, questions: Array(selectedSounds.keys))) {
                    Text("Start Audio Exercises")
                        .font(.largeTitle)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: RecordingView(audioRecorder: audioRecorder)) {
                    Text("Record Sounds")
                        .font(.title)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
                
                NavigationLink(destination: ConfigurationView(audioRecorder: audioRecorder, selectedSounds: $selectedSounds)) {
                    Text("Configure Questions")
                        .font(.title)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
                
                List {
                    ForEach(selectedSounds.keys.sorted(), id: \.self) { question in
                        Section(header: Text(question)) {
                            ForEach(selectedSounds[question] ?? [], id: \.self) { sound in
                                Text(sound.lastPathComponent)
                            }
                        }
                    }
                }
                .navigationTitle("Home")
            }
        }
    }
}


struct AudioExerciseView: View {
    @Binding var selectedSounds: [String: [URL]]
    let questions: [String]
    @State private var currentQuestionIndex: Int = 0
    @State private var selectedSound: URL?
    @State private var isCorrect: Bool? = nil
    @State private var showSummary: Bool = false
    @State private var feedbackColor: Color = Color.white
    @ObservedObject var audioPlayer = AudioPlayer()
    
    var body: some View {
        VStack {
            Text(questions[currentQuestionIndex])
                .font(.title)
                .padding()
                .foregroundColor(.primary)
            
            if let sounds = selectedSounds[questions[currentQuestionIndex]], !sounds.isEmpty {
                Text("Playing: \(selectedSound?.lastPathComponent ?? "Unknown")")
                    .font(.headline)
                    .padding()
                    .foregroundColor(.primary)
                    .onAppear {
                        self.selectRandomSound()
                        self.playCurrentSound()
                    }
                
                Button(action: {
                    self.playCurrentSound()
                }) {
                    Text("Play Again")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.bottom, 20)
                
                VStack {
                    ForEach(sounds, id: \.self) { sound in
                        Button(action: {
                            self.checkAnswer(sound)
                        }) {
                            Text(sound.lastPathComponent)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .shadow(color: .gray, radius: 5, x: 0, y: 5)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding()
                
                if let isCorrect = isCorrect {
                    Text(isCorrect ? "Correct!" : "Try Again!")
                        .font(.title2)
                        .foregroundColor(isCorrect ? .green : .red)
                        .padding()
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 1.0))
                }
            } else {
                Text("No recordings selected for this question.")
                    .padding()
                    .foregroundColor(.primary)
            }
        }
        .background(feedbackColor)
        .animation(.easeInOut(duration: 0.5), value: feedbackColor)
        .navigationTitle("Audio Exercise")
        .padding()
        .fullScreenCover(isPresented: $showSummary) {
            SummaryView()
                .onDisappear {
                    resetExercise()
                }
        }
    }
    
    func selectRandomSound() {
        if let sounds = selectedSounds[questions[currentQuestionIndex]], !sounds.isEmpty {
            selectedSound = sounds.randomElement()
        }
    }
    
    func playCurrentSound() {
        if let sound = selectedSound {
            audioPlayer.playSound(soundURL: sound)
        }
    }
    
    func checkAnswer(_ answer: URL) {
        if let sound = selectedSound {
            withAnimation {
                isCorrect = (answer == sound)
                feedbackColor = isCorrect == true ? Color.green : Color.red
            }
            
            if isCorrect == true {
                audioPlayer.playSound(soundURL: answer)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.nextQuestionOrSummary()
                }
            } else {
                audioPlayer.playSound(soundURL: answer)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        self.feedbackColor = Color.white
                    }
                }
            }
        }
    }
    
    func nextQuestionOrSummary() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            selectRandomSound()
            isCorrect = nil
            feedbackColor = Color.white
            playCurrentSound()
        } else {
            showSummary = true
        }
    }
    
    func resetExercise() {
        currentQuestionIndex = 0
        selectRandomSound()
        isCorrect = nil
        feedbackColor = Color.white
        playCurrentSound()
    }
}





#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
