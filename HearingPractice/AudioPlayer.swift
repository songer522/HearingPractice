//
//  AVPlayer.swift
//  HearingPractice
//
//  Created by Yang Song on 6/29/24.
//

import SwiftUI
import AVFoundation

class AudioPlayer: ObservableObject {
    var audioPlayer: AVAudioPlayer?

    init() {
        configureAudioSession()
    }
    
    func configureAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, options: .defaultToSpeaker)
            try audioSession.setActive(true)
        } catch {
            print("Failed to set audio session category: \(error.localizedDescription)")
        }
    }

    func playSound(soundURL: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
}





