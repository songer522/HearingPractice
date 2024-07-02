import SwiftUI

struct ConfigurationView: View {
    @ObservedObject var audioRecorder: AudioRecorder
    @Binding var selectedSounds: [String: [URL]]
    
    var body: some View {
        VStack {
            List {
                ForEach(Array(audioRecorder.recordingsByQuestion.keys), id: \.self) { question in
                    Section(header: Text(question)) {
                        ForEach(audioRecorder.recordingsByQuestion[question] ?? [], id: \.id) { recording in
                            HStack {
                                Text(formattedFileName(from: recording.fileURL.lastPathComponent))
                                Spacer()
                                if selectedSounds[question]?.contains(recording.fileURL) == true {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                toggleSelection(of: recording, for: question)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteQuestion)
            }
            .navigationTitle("Configure Questions")

            Button(action: resetConfiguration) {
                Text("Reset Configuration")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            Button(action: selectAllOptions) {
                Text("Select All Options")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .onAppear {
            selectedSounds = audioRecorder.loadConfiguration()
        }
    }

    func formattedFileName(from fileName: String) -> String {
        return fileName
            .replacingOccurrences(of: "_", with: " ")
            .replacingOccurrences(of: ".m4a", with: "")
    }

    func deleteQuestion(at offsets: IndexSet) {
        for index in offsets {
            let question = Array(audioRecorder.recordingsByQuestion.keys)[index]
            audioRecorder.recordingsByQuestion.removeValue(forKey: question)
            selectedSounds.removeValue(forKey: question)
        }
        audioRecorder.saveConfiguration(selectedSounds)
    }

    func toggleSelection(of recording: Recording, for question: String) {
        if var sounds = selectedSounds[question] {
            if let index = sounds.firstIndex(of: recording.fileURL) {
                sounds.remove(at: index)
            } else {
                sounds.append(recording.fileURL)
            }
            selectedSounds[question] = sounds
        } else {
            selectedSounds[question] = [recording.fileURL]
        }
        audioRecorder.saveConfiguration(selectedSounds)
    }

    func resetConfiguration() {
        selectedSounds.removeAll()
        audioRecorder.saveConfiguration(selectedSounds)
    }

    func selectAllOptions() {
        for question in audioRecorder.recordingsByQuestion.keys {
            selectedSounds[question] = audioRecorder.recordingsByQuestion[question]?.map { $0.fileURL } ?? []
        }
        audioRecorder.saveConfiguration(selectedSounds)
    }
}

extension URL: Identifiable {
    public var id: URL { self }
}
