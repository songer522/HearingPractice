//
//  ContentView.swift
//  HearingPractice
//
//  Created by Yang Song on 6/29/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedSounds = [String: [URL]]()
    @ObservedObject var audioRecorder = AudioRecorder()
    @State private var navigateToHome = false
    @State private var selectedTab: Int = 0
    @State private var questions: [QuizQuestion] = []
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                AudioExerciseView(
                    selectedSounds: $selectedSounds,
                    questions: Array(selectedSounds.keys),
                    navigateToHome: $navigateToHome,
                    selectedTab: $selectedTab
                )
            }
            .tabItem {
                Label("Exercises", systemImage: "play.circle")
            }
            .tag(0)

            NavigationView {
                RecordingView(audioRecorder: audioRecorder)
            }
            .tabItem {
                Label("Record", systemImage: "mic.circle")
            }
            .tag(1)

            NavigationView {
                ConfigurationView(
                    audioRecorder: audioRecorder,
                    selectedSounds: $selectedSounds
                )
            }
            .tabItem {
                Label("Configure", systemImage: "gearshape")
            }
            .tag(2)
            
            NavigationView {
                RandomAudioExerciseView()
            }
            .tabItem {
                Label("Random quiz", systemImage: "play.circle")
            }
            .tag(3)
        }
    }
}


#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
