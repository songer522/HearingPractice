import SwiftUI

struct ConfigurationView: View {
    @ObservedObject var audioRecorder: AudioRecorder
    @Binding var selectedSounds: [String: [URL]]
    let questions = ["Question 1", "Question 2", "Question 3"]

    var body: some View {
        VStack {
            List {
                ForEach(questions, id: \.self) { question in
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
                        }
                    }
                }
            }
            .navigationTitle("Configure Questions")
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
}
