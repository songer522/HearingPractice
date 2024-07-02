//
//  ContentView.swift
//  HearingPractice
//
//  Created by Yang Song on 6/29/24.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    @State private var selectedSounds = [String: [URL]]()
    @ObservedObject var audioRecorder = AudioRecorder()
    @State private var navigateToHome = false

    var body: some View {
        TabView {
            NavigationView {
                AudioExerciseView(
                    selectedSounds: $selectedSounds,
                    questions: Array(selectedSounds.keys),
                    navigateToHome: $navigateToHome
                )
            }
            .tabItem {
                Label("Exercises", systemImage: "play.circle")
            }

            NavigationView {
                RecordingView(audioRecorder: audioRecorder)
            }
            .tabItem {
                Label("Record", systemImage: "mic.circle")
            }

            NavigationView {
                ConfigurationView(
                    audioRecorder: audioRecorder,
                    selectedSounds: $selectedSounds
                )
            }
            .tabItem {
                Label("Configure", systemImage: "gearshape")
            }
        }
    }
}


#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
