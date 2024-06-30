import SwiftUI

struct QuestionRecordingView: View {
    @ObservedObject var audioRecorder: AudioRecorder
    let question: String

    var body: some View {
        VStack {
            if audioRecorder.isRecording {
                Button(action: {
                    self.audioRecorder.stopRecording(for: question)
                }) {
                    Text("Stop Recording")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            } else {
                Button(action: {
                    self.audioRecorder.startRecording(for: question)
                }) {
                    Text("Start Recording")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }

            List {
                ForEach(audioRecorder.recordingsByQuestion[question] ?? [], id: \.id) { recording in
                    HStack {
                        Text(formattedFileName(from: recording.fileURL.lastPathComponent))
                        Spacer()
                        Button(action: {
                            deleteRecording(recording)
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                }
            }

            Spacer()
        }
        .navigationTitle(question)
    }

    func formattedFileName(from fileName: String) -> String {
        return fileName
            .replacingOccurrences(of: "_", with: " ")
            .replacingOccurrences(of: ".m4a", with: "")
    }

    func deleteRecording(_ recording: Recording) {
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
}
