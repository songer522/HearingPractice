import SwiftUI
import AVFoundation

struct QuestionRecordingView: View {
    @ObservedObject var audioRecorder: AudioRecorder
    let question: String
    @State private var isRecording = false
    @State private var showAlertType: AlertType?
    @State private var recordingToDelete: Recording?
    @Environment(\.presentationMode) var presentationMode // To handle dismissing the view

    enum AlertType: Identifiable {
        case delete, duplicateName

        var id: Int {
            hashValue
        }
    }

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
                            self.recordingToDelete = recording
                            self.showAlertType = .delete
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
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
        .alert(item: $showAlertType) { alertType in
            switch alertType {
            case .delete:
                return Alert(
                    title: Text("Delete Recording"),
                    message: Text("Are you sure you want to delete this recording?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let recording = recordingToDelete {
                            deleteRecording(recording, for: question)
                        }
                    },
                    secondaryButton: .cancel()
                )
            case .duplicateName:
                return Alert(
                    title: Text("Duplicate Recording Name"),
                    message: Text(audioRecorder.duplicateNameErrorMessage),
                    dismissButton: .default(Text("OK")) {
                        audioRecorder.showDuplicateNameAlert = false
                        audioRecorder.duplicateNameErrorMessage = ""
                    }
                )
            }
        }
        .onReceive(audioRecorder.$showDuplicateNameAlert) { show in
            if show {
                self.showAlertType = .duplicateName
            }
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
}
