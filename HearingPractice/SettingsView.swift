//
//  SettingsView.swift
//  HearingPractice
//
//  Created by Yang Song on 6/29/24.
//

import SwiftUI

struct SettingsView: View {
    @Binding var selectedSounds: [String]
    let allSounds = ["sound1", "sound2", "sound3", "sound4", "sound5"]

    var body: some View {
        Form {
            Section(header: Text("Select Sounds")) {
                ForEach(allSounds, id: \.self) { sound in
                    Toggle(isOn: Binding(
                        get: { self.selectedSounds.contains(sound) },
                        set: { newValue in
                            if newValue {
                                self.selectedSounds.append(sound)
                            } else {
                                self.selectedSounds.removeAll { $0 == sound }
                            }
                        }
                    )) {
                        Text(sound.capitalized)
                    }
                }
            }
        }
        .navigationTitle("Settings")
    }
}
