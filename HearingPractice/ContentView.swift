//
//  ContentView.swift
//  HearingPractice
//
//  Created by Yang Song on 6/29/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedSounds = [String: [URL]]()
    @ObservedObject var audioRecorder = AudioRecorder()
    @State private var navigateToHome = false

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: AudioExerciseView(selectedSounds: $selectedSounds, questions: Array(selectedSounds.keys), navigateToHome: $navigateToHome), isActive: $navigateToHome) {
                    Text("Start Audio Exercises")
                        .font(.largeTitle)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 20)

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
                
                Spacer()
            }
            .navigationTitle("Home")
            .padding()
        }
    }
}



#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
