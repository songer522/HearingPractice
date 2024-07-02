import SwiftUI

struct RecordingView: View {
    @ObservedObject var audioRecorder: AudioRecorder
    @State private var newQuestion = ""
    @State private var selectedQuestion: String?
    @State private var showDeleteAllAlert = false // State for showing the delete all recordings alert
    @State private var selectedLanguage: String = "en-US" // Default language
    let supportedLanguages = ["en-US", "es-ES", "fr-FR", "zh-CN"] // Add more languages as needed

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

            Picker("Select Language", selection: $selectedLanguage) {
                ForEach(supportedLanguages, id: \.self) { language in
                    Text(language).tag(language)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .onChange(of: selectedLanguage) { newValue in
                audioRecorder.selectedLanguage = newValue
            }

            List {
                ForEach(Array(audioRecorder.recordingsByQuestion.keys.sorted()), id: \.self) { question in
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
        .onDisappear {
            let selectedSounds = audioRecorder.recordingsByQuestion.mapValues { $0.map { $0.fileURL } }
            audioRecorder.saveConfiguration(selectedSounds)
        }
    }

    func addQuestion() {
        guard !newQuestion.isEmpty else { return }
        audioRecorder.recordingsByQuestion[newQuestion] = []
        newQuestion = ""
        let selectedSounds = audioRecorder.recordingsByQuestion.mapValues { $0.map { $0.fileURL } }
        audioRecorder.saveConfiguration(selectedSounds)
    }

    func deleteQuestion(_ question: String) {
        audioRecorder.recordingsByQuestion.removeValue(forKey: question)
        let selectedSounds = audioRecorder.recordingsByQuestion.mapValues { $0.map { $0.fileURL } }
        audioRecorder.saveConfiguration(selectedSounds)
        // Optionally delete associated recordings from storage if necessary
        let questionDirectory = audioRecorder.getDocumentsDirectory().appendingPathComponent(question)
        do {
            try FileManager.default.removeItem(at: questionDirectory)
        } catch {
            print("Could not delete question directory: \(error.localizedDescription)")
        }
    }
}

extension String: Identifiable {
    public var id: String { self }
}
