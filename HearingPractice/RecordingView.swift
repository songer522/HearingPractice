import SwiftUI

struct RecordingView: View {
    @ObservedObject var audioRecorder: AudioRecorder
    @State private var newQuestion = ""
    @State private var selectedQuestion: String?
    @State private var showDeleteAllAlert = false // State for showing the delete all recordings alert

    var body: some View {
        VStack {
            HStack {
                TextField("Enter new question", text: $newQuestion)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: addQuestion) {
                    Text("Add Question")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }

            List {
                ForEach(Array(audioRecorder.recordingsByQuestion.keys), id: \.self) { question in
                    HStack {
                        Text(question)
                        Spacer()
                        Button(action: {
                            selectedQuestion = question
                        }) {
                            Text("Configure")
                                .padding(5)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                        }
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            deleteQuestion(question)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }

            if audioRecorder.isRecording, let question = selectedQuestion {
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
            }

            Button(action: {
                self.showDeleteAllAlert = true
            }) {
                Text("Delete All Recordings")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
            .alert(isPresented: $showDeleteAllAlert) {
                Alert(
                    title: Text("Delete All Recordings"),
                    message: Text("Are you sure you want to delete all recordings? This action cannot be undone."),
                    primaryButton: .destructive(Text("Delete")) {
                        self.audioRecorder.deleteAllRecordings()
                    },
                    secondaryButton: .cancel()
                )
            }

            Spacer()
        }
        .navigationTitle("Recordings")
        .sheet(item: $selectedQuestion) { question in
            QuestionRecordingView(audioRecorder: audioRecorder, question: question)
        }
    }

    func addQuestion() {
        guard !newQuestion.isEmpty else { return }
        audioRecorder.recordingsByQuestion[newQuestion] = []
        newQuestion = ""
    }

    func deleteQuestion(_ question: String) {
        audioRecorder.recordingsByQuestion.removeValue(forKey: question)
        // Optionally delete associated recordings from storage if necessary
    }
}

extension String: Identifiable {
    public var id: String { self }
}
