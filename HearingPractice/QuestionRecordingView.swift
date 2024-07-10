import SwiftUI
import AVFoundation

struct QuestionRecordingView: View {
    @ObservedObject var audioRecorder: AudioRecorder
    let question: String
    @State private var isRecording = false
    @State private var showAlert = false
    @State private var recordingToDelete: Recording?
    @State private var audioPlayer: AVAudioPlayer?
    @State private var playingRecordingID: UUID? // Track the currently playing recording's ID
    @State private var playButtonScale: CGFloat = 1.0
    @Environment(\.presentationMode) var presentationMode // To handle dismissing the view

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.white) // Change the image color to white
                        .padding()
                        .background(Color.gray.opacity(0.5))
                        .clipShape(Circle())
                }
                .padding()
            }

            Text(isRecording ? "Recording... Tap to stop" : "Tap to start recording")
                .font(.headline)
                .padding()
            
            List {
                ForEach(audioRecorder.recordingsByQuestion[question] ?? [], id: \.id) { recording in
                    HStack {
                        Text(formattedFileName(from: recording.fileURL.lastPathComponent))
                        Spacer()
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                self.playingRecordingID = recording.id
                                self.playButtonScale = 1.2
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    self.playButtonScale = 1.0
                                }
                            }
                            self.playRecording(recording)
                        }) {
                            Image(systemName: "play.circle")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.blue)
                                .scaleEffect(self.playingRecordingID == recording.id ? playButtonScale : 1.0)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .padding(.trailing, 10)
                        Button(action: {
                            self.recordingToDelete = recording
                            self.showAlert = true
                        }) {
                            Image(systemName: "trash")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.red)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    .padding(.vertical, 5)
                }
            }
            
            Spacer()

            Button(action: {
                if isRecording {
                    self.stopRecording(for: question)
                } else {
                    self.startRecording(for: question)
                }
            }) {
                Text(isRecording ? "Stop Recording" : "Start Recording")
                    .padding()
                    .background(isRecording ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle(question)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Delete Recording"),
                message: Text("Are you sure you want to delete this recording?"),
                primaryButton: .destructive(Text("Delete")) {
                    if let recording = recordingToDelete {
                        deleteRecording(recording, for: question)
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }

    func formattedFileName(from fileName: String) -> String {
        return fileName
            .replacingOccurrences(of: "_", with: " ")
            .replacingOccurrences(of: ".m4a", with: "")
    }

    func startRecording(for question: String) {
        isRecording = true
        audioRecorder.startRecording(for: question)
    }

    func stopRecording(for question: String) {
        isRecording = false
        audioRecorder.stopRecording(for: question)
    }

    func deleteRecording(_ recording: Recording, for question: String) {
        // Remove the recording from the recordingsByQuestion dictionary
        if var recordings = audioRecorder.recordingsByQuestion[question] {
            if let index = recordings.firstIndex(where: { $0.id == recording.id }) {
                recordings.remove(at: index)
                audioRecorder.recordingsByQuestion[question] = recordings
            }
        }

        // Delete the recording file from the file system
        do {
            try FileManager.default.removeItem(at: recording.fileURL)
        } catch {
            print("Could not delete recording: \(error.localizedDescription)")
        }
    }

    func playRecording(_ recording: Recording) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: recording.fileURL)
            audioPlayer?.play()
        } catch {
            print("Could not play recording: \(error.localizedDescription)")
        }
    }
}
