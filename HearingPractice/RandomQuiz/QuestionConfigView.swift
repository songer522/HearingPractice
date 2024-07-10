import SwiftUI

struct QuestionConfigView: View {
    @Binding var questions: [QuizQuestion]

    @State private var newQuestionOptions = ["", "", "", ""]
    @State private var newQuestionText = ""
    @State private var showingAlert = false
    @State private var editingIndex: Int? = nil

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text(editingIndex == nil ? "Add New Question" : "Edit Question")) {
                        TextField("Question", text: $newQuestionText)
                        ForEach(0..<newQuestionOptions.count, id: \.self) { index in
                            TextField("Option \(index + 1)", text: $newQuestionOptions[index])
                        }
                        Button(action: addOrUpdateQuestion) {
                            Text(editingIndex == nil ? "Add Question" : "Update Question")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }

                    Section(header: Text("Existing Questions")) {
                        ForEach(questions.indices, id: \.self) { index in
                            VStack(alignment: .leading) {
                                Text("Question \(index + 1): \(questions[index].options.first ?? "")")
                                    .font(.headline)
                                ForEach(questions[index].options.dropFirst(), id: \.self) { option in
                                    Text(option)
                                }
                                HStack {
                                    Button(action: {
                                        startEditing(at: index)
                                    }) {
                                        Text("Edit")
                                            .foregroundColor(.blue)
                                    }
                                    Button(action: {
                                        deleteQuestion(at: index)
                                    }) {
                                        Text("Delete")
                                            .foregroundColor(.red)
                                    }
                                }
                                .padding(.top, 5)
                            }
                            .padding(.vertical, 5)
                        }
                    }
                }
            }
            .navigationTitle("Configure Questions")
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Invalid Input"), message: Text("Please make sure all fields are filled out."), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func addOrUpdateQuestion() {
        let trimmedOptions = newQuestionOptions.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        let trimmedQuestionText = newQuestionText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedQuestionText.isEmpty, !trimmedOptions.contains("") else {
            showingAlert = true
            return
        }
        
        let newQuestion = QuizQuestion(options: [trimmedQuestionText] + trimmedOptions.shuffled())
        
        if let index = editingIndex {
            questions[index] = newQuestion
        } else {
            questions.append(newQuestion)
        }
        
        resetFields()
    }

    private func startEditing(at index: Int) {
        let question = questions[index]
        newQuestionText = question.options.first ?? ""
        newQuestionOptions = Array(question.options.dropFirst())
        editingIndex = index
    }

    private func deleteQuestion(at index: Int) {
        questions.remove(at: index)
        resetFields()
    }

    private func resetFields() {
        newQuestionText = ""
        newQuestionOptions = ["", "", "", ""]
        editingIndex = nil
    }
}
