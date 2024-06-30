import SwiftUI

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
                    Text(formattedFileName(from: recording.fileURL.lastPathComponent))
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

    func formattedFileName(from fileName: String) -> String {
        return fileName
            .replacingOccurrences(of: "_", with: " ")
            .replacingOccurrences(of: ".m4a", with: "")
    }
}
