import Foundation
import AVFoundation
import Speech
import SwiftUI

class AudioRecorder: ObservableObject {
    var audioRecorder: AVAudioRecorder?
    @Published var isRecording = false
    @Published var recordingsByQuestion = [String: [Recording]]()
    @Published var showDuplicateNameAlert = false
    @Published var duplicateNameErrorMessage = ""
    @Published var selectedLanguage: String = "en-US" // Default language

    init() {
        requestSpeechRecognitionPermission()
        loadAllRecordings()
        loadConfiguration()
    }

    func requestSpeechRecognitionPermission() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized:
                    print("Speech recognition authorized")
                case .denied, .restricted, .notDetermined:
                    print("Speech recognition not authorized")
                @unknown default:
                    print("Unknown speech recognition status")
                }
            }
        }
    }

    func startRecording(for question: String) {
        let recordingName = UUID().uuidString + ".m4a"
        let recordingURL = getDocumentsDirectory().appendingPathComponent(question).appendingPathComponent(recordingName)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            try FileManager.default.createDirectory(at: recordingURL.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
            audioRecorder = try AVAudioRecorder(url: recordingURL, settings: settings)
            audioRecorder?.record()
            isRecording = true
        } catch {
            print("Could not start recording: \(error.localizedDescription)")
        }
    }
    
    func stopRecording(for question: String) {
        audioRecorder?.stop()
        isRecording = false

        guard let url = audioRecorder?.url else { return }
        
        transcribeAudio(url: url) { [weak self] transcribedText in
            guard let self = self, let transcribedText = transcribedText else { return }
            self.renameRecording(url: url, newName: transcribedText, for: question)
            self.loadRecordings(for: question)
        }
    }

    func transcribeAudio(url: URL, completion: @escaping (String?) -> Void) {
        guard let recognizer = SFSpeechRecognizer(locale: Locale(identifier: selectedLanguage)) else {
            print("Speech recognition not available for locale: \(selectedLanguage)")
            completion(nil)
            return
        }
        let request = SFSpeechURLRecognitionRequest(url: url)

        recognizer.recognitionTask(with: request) { result, error in
            guard let result = result, result.isFinal else {
                completion(nil)
                return
            }
            completion(result.bestTranscription.formattedString)
        }
    }

    func renameRecording(url: URL, newName: String, for question: String) {
        let newFileName = newName.replacingOccurrences(of: " ", with: "_") + ".m4a"
        let newURL = getDocumentsDirectory().appendingPathComponent(question).appendingPathComponent(newFileName)
        
        // Check if the file already exists
        if FileManager.default.fileExists(atPath: newURL.path) {
            DispatchQueue.main.async {
                self.duplicateNameErrorMessage = "A recording with the name \"\(newFileName)\" already exists."
                self.showDuplicateNameAlert = true
            }
            // Delete the original file
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                print("Could not delete original file: \(error.localizedDescription)")
            }
            return
        }

        do {
            try FileManager.default.moveItem(at: url, to: newURL)
            var recordings = recordingsByQuestion[question] ?? []
            recordings.append(Recording(fileURL: newURL))
            recordingsByQuestion[question] = recordings
        } catch {
            print("Could not rename file: \(error.localizedDescription)")
        }
    }

    func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    func loadAllRecordings() {
        recordingsByQuestion.removeAll()
        let documentsDirectory = getDocumentsDirectory()
        do {
            let questionDirectories = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
            for questionDirectory in questionDirectories {
                if questionDirectory.hasDirectoryPath {
                    let question = questionDirectory.lastPathComponent
                    let fileURLs = try FileManager.default.contentsOfDirectory(at: questionDirectory, includingPropertiesForKeys: nil)
                    for url in fileURLs {
                        if url.pathExtension == "m4a" {
                            let recording = Recording(fileURL: url)
                            if recordingsByQuestion[question] != nil {
                                recordingsByQuestion[question]?.append(recording)
                            } else {
                                recordingsByQuestion[question] = [recording]
                            }
                        }
                    }
                }
            }
        } catch {
            print("Could not load recordings: \(error.localizedDescription)")
        }
    }
    
    func loadRecordings(for question: String) {
        let documentsDirectory = getDocumentsDirectory().appendingPathComponent(question)
        var recordings = [Recording]()
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
            for url in fileURLs {
                if url.pathExtension == "m4a" {
                    let recording = Recording(fileURL: url)
                    recordings.append(recording)
                }
            }
            recordingsByQuestion[question] = recordings
        } catch {
            print("Could not load recordings: \(error.localizedDescription)")
        }
    }

    func deleteAllRecordings() {
        let documentsDirectory = getDocumentsDirectory()
        do {
            let questionDirectories = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
            for questionDirectory in questionDirectories {
                try FileManager.default.removeItem(at: questionDirectory)
            }
            loadAllRecordings()
        } catch {
            print("Could not delete recordings: \(error.localizedDescription)")
        }
    }

    func saveConfiguration(_ selectedSounds: [String: [URL]]) {
        let configuration = selectedSounds.mapValues { $0.map { $0.absoluteString } }
        UserDefaults.standard.set(configuration, forKey: "selectedSounds")
    }

    func loadConfiguration() -> [String: [URL]] {
        guard let configuration = UserDefaults.standard.dictionary(forKey: "selectedSounds") as? [String: [String]] else {
            return [:]
        }
        return configuration.mapValues { $0.compactMap { URL(string: $0) } }
    }
}
