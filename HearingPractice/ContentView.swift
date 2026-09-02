//
//  ContentView.swift
//  HearingPractice
//
//  Created by Yang Song on 6/29/24.
//

import SwiftUI

struct ContentView: View {
    @State private var showWelcomeTutorial = false
    
    private var currentAppVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version).\(build)"
    }
    
    private var hasSeenTutorialForCurrentVersion: Bool {
        get {
            let key = "hasSeenTutorial_\(currentAppVersion)"
            return UserDefaults.standard.bool(forKey: key)
        }
    }
    
    private func markTutorialAsSeen() {
        let key = "hasSeenTutorial_\(currentAppVersion)"
        UserDefaults.standard.set(true, forKey: key)
    }
    
    var body: some View {
        RandomAudioExerciseView()
            .sheet(isPresented: $showWelcomeTutorial, onDismiss: {
                markTutorialAsSeen()
            }) {
                WelcomeTutorialView()
            }
            .onAppear {
                if !hasSeenTutorialForCurrentVersion {
                    // Show tutorial after a short delay for better UX
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showWelcomeTutorial = true
                    }
                }
            }
    }
}


#Preview {
    ContentView()
}
