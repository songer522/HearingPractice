import SwiftUI
import AVFoundation

class AudioPlayer: ObservableObject {
    var audioPlayer: AVAudioPlayer?
    var speechSynthesizer: AVSpeechSynthesizer

    init() {
        self.speechSynthesizer = AVSpeechSynthesizer()
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

    func speak(text: String, language: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: language)
        speechSynthesizer.speak(speechUtterance)
    }
}
