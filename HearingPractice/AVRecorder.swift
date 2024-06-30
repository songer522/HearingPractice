//
//  AVRecorder.swift
//  HearingPractice
//
//  Created by Yang Song on 6/29/24.
//
import SwiftUI
import AVFoundation
import Speech

class AudioRecorder: ObservableObject {
    var audioRecorder: AVAudioRecorder?
       @Published var isRecording = false
       @Published var recordingsByQuestion = [String: [Recording]]()
       
       init() {
           requestSpeechRecognitionPermission()
           loadAllRecordings()
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
        let recordingURL = getDocumentsDirectory().appendingPathComponent(recordingName)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
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
                self.renameRecording(url: url, newName: transcribedText)
                self.loadRecordings(for: question)
            }
        }

        func renameRecording(url: URL, newName: String) {
            let newFileName = newName.replacingOccurrences(of: " ", with: "_") + ".m4a"
            let newURL = getDocumentsDirectory().appendingPathComponent(newFileName)

            do {
                try FileManager.default.moveItem(at: url, to: newURL)
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
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
            for url in fileURLs {
                if url.pathExtension == "m4a" {
                    let recording = Recording(fileURL: url)
                    let question = "Unsorted" // Or derive this from the file name if needed
                    if recordingsByQuestion[question] != nil {
                        recordingsByQuestion[question]?.append(recording)
                    } else {
                        recordingsByQuestion[question] = [recording]
                    }
                }
            }
        } catch {
            print("Could not load recordings: \(error.localizedDescription)")
        }
    }
    
    func loadRecordings(for question: String) {
        var recordings = [Recording]()
        let documentsDirectory = getDocumentsDirectory()
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
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
            for url in fileURLs {
                if url.pathExtension == "m4a" {
                    try FileManager.default.removeItem(at: url)
                }
            }
            loadAllRecordings()
        } catch {
            print("Could not delete recordings: \(error.localizedDescription)")
        }
    }
    
    func transcribeAudio(url: URL, completion: @escaping (String?) -> Void) {
          let recognizer = SFSpeechRecognizer()
          let request = SFSpeechURLRecognitionRequest(url: url)

          recognizer?.recognitionTask(with: request) { result, error in
              guard let result = result, result.isFinal else {
                  completion(nil)
                  return
              }
              completion(result.bestTranscription.formattedString)
          }
      }
}


struct Recording: Identifiable {
    let id = UUID()
    let fileURL: URL
}


struct RecordingView: View {
    @ObservedObject var audioRecorder: AudioRecorder
    @State private var selectedQuestion = "Question 1"
    let questions = ["Question 1", "Question 2", "Question 3"]
    
    var body: some View {
        VStack {
            Picker("Select Question", selection: $selectedQuestion) {
                ForEach(questions, id: \.self) { question in
                    Text(question).tag(question)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            if audioRecorder.isRecording {
                Button(action: {
                    self.audioRecorder.stopRecording(for: selectedQuestion)
                }) {
                    Text("Stop Recording")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            } else {
                Button(action: {
                    self.audioRecorder.startRecording(for: selectedQuestion)
                }) {
                    Text("Start Recording")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            
            List {
                ForEach(audioRecorder.recordingsByQuestion[selectedQuestion] ?? [], id: \.id) { recording in
                    Text(recording.fileURL.lastPathComponent)
                }
            }
            
            Button(action: {
                self.audioRecorder.deleteAllRecordings()
            }) {
                Text("Delete All Recordings")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
        }
        .navigationTitle("Recordings")
    }
}


