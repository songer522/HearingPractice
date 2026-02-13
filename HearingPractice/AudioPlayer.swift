import SwiftUI
import AVFoundation

class AudioPlayer: ObservableObject {
    var audioPlayer: AVAudioPlayer?
    var backgroundNoisePlayer: AVAudioPlayer?
    var speechSynthesizer: AVSpeechSynthesizer

    init() {
        self.speechSynthesizer = AVSpeechSynthesizer()
        configureAudioSession()
    }
    
    func configureAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default)
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

    func speak(text: String, language: String, rate: Float = 0.45, pitchMultiplier: Float = 1.2, volume: Float = 1.0) {
            let speechUtterance = AVSpeechUtterance(string: text)
            speechUtterance.voice = AVSpeechSynthesisVoice(language: language)
            speechUtterance.rate = rate
            speechUtterance.pitchMultiplier = pitchMultiplier
            speechUtterance.volume = volume
            speechSynthesizer.speak(speechUtterance)
        }
    
    func startBackgroundNoise() {
        let noiseBuffer = generateWhiteNoise()
        
        do {
            backgroundNoisePlayer = try AVAudioPlayer(data: noiseBuffer)
            backgroundNoisePlayer?.numberOfLoops = -1 // Loop indefinitely
            backgroundNoisePlayer?.volume = 1.0
            backgroundNoisePlayer?.prepareToPlay()
            let success = backgroundNoisePlayer?.play()
            print("Background noise started: \(success ?? false)")
            print("Background noise is playing: \(backgroundNoisePlayer?.isPlaying ?? false)")
        } catch {
            print("Error playing background noise: \(error.localizedDescription)")
        }
    }
    
    func stopBackgroundNoise() {
        print("Stopping background noise")
        backgroundNoisePlayer?.stop()
        backgroundNoisePlayer = nil
    }
    
    private func generateWhiteNoise() -> Data {
        // Generate 2 seconds of white noise at 44100 Hz
        let sampleRate = 44100
        let duration = 2.0
        let frameCount = Int(Double(sampleRate) * duration)
        
        var whiteNoise: [Int16] = []
        
        // Generate white noise with higher amplitude
        for _ in 0..<frameCount {
            let sample = Int16.random(in: -10000...10000)
            whiteNoise.append(sample)
        }
        
        // Create WAV header and data
        var wavData = Data()
        
        // RIFF header
        wavData.append(contentsOf: "RIFF".utf8)
        let fileSize = UInt32(36 + whiteNoise.count * 2)
        wavData.append(contentsOf: withUnsafeBytes(of: fileSize.littleEndian) { Data($0) })
        wavData.append(contentsOf: "WAVE".utf8)
        
        // fmt chunk
        wavData.append(contentsOf: "fmt ".utf8)
        wavData.append(contentsOf: withUnsafeBytes(of: UInt32(16).littleEndian) { Data($0) })
        wavData.append(contentsOf: withUnsafeBytes(of: UInt16(1).littleEndian) { Data($0) }) // PCM
        wavData.append(contentsOf: withUnsafeBytes(of: UInt16(1).littleEndian) { Data($0) }) // Mono
        wavData.append(contentsOf: withUnsafeBytes(of: UInt32(sampleRate).littleEndian) { Data($0) })
        wavData.append(contentsOf: withUnsafeBytes(of: UInt32(sampleRate * 2).littleEndian) { Data($0) }) // Byte rate
        wavData.append(contentsOf: withUnsafeBytes(of: UInt16(2).littleEndian) { Data($0) }) // Block align
        wavData.append(contentsOf: withUnsafeBytes(of: UInt16(16).littleEndian) { Data($0) }) // Bits per sample
        
        // data chunk
        wavData.append(contentsOf: "data".utf8)
        wavData.append(contentsOf: withUnsafeBytes(of: UInt32(whiteNoise.count * 2).littleEndian) { Data($0) })
        for sample in whiteNoise {
            wavData.append(contentsOf: withUnsafeBytes(of: sample.littleEndian) { Data($0) })
        }
        
        return wavData
    }
}
