import SwiftUI

struct QuestionConfigView: View {
    @Binding var questions: [QuizQuestion]

    @State private var newQuestionOptions = ["", "", "", ""]
    @State private var newQuestionText = ""

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Add New Question")) {
                        TextField("Question", text: $newQuestionText)
                        ForEach(0..<newQuestionOptions.count, id: \.self) { index in
                            TextField("Option \(index + 1)", text: $newQuestionOptions[index])
                        }
                        Button(action: addNewQuestion) {
                            Text("Add Question")
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
                                Button(action: {
                                    deleteQuestion(at: index)
                                }) {
                                    Text("Delete Question")
                                        .foregroundColor(.red)
                                }
                                .padding(.top, 5)
                            }
                            .padding(.vertical, 5)
                        }
                    }
                }
            }
            .navigationTitle("Configure Questions")
        }
    }

    private func addNewQuestion() {
        let trimmedOptions = newQuestionOptions.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        guard !newQuestionText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !trimmedOptions.contains("") else { return }
        
        let newQuestion = QuizQuestion(options: [newQuestionText] + trimmedOptions.shuffled())
        questions.append(newQuestion)
        newQuestionText = ""
        newQuestionOptions = ["", "", "", ""]
    }

    private func deleteQuestion(at index: Int) {
        questions.remove(at: index)
    }
}
