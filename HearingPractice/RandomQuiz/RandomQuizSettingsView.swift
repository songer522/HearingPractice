import SwiftUI

struct RandomQuizSettingsView: View {
    @Binding var selectedCategory: Category
    @Binding var numberOfOptions: Int
    @Binding var speechSpeed: SpeechSpeed
    @Binding var numberOfQuestions: Int
    @Binding var environment: ListeningEnvironment
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Quiz Settings")) {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(Category.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    
                    Picker("Number of Options", selection: $numberOfOptions) {
                        ForEach([2, 3, 4, 5, 6], id: \.self) { number in
                            Text("\(number) options").tag(number)
                        }
                    }
                    
                    Picker("Number of Questions", selection: $numberOfQuestions) {
                        ForEach([10, 25, 50], id: \.self) { number in
                            Text("\(number) questions").tag(number)
                        }
                    }
                    
                    Picker("Speech Speed", selection: $speechSpeed) {
                        ForEach(SpeechSpeed.allCases, id: \.self) { speed in
                            Text(speed.rawValue).tag(speed)
                        }
                    }
                    
                    Picker("Environment", selection: $environment) {
                        ForEach(ListeningEnvironment.allCases, id: \.self) { env in
                            Text(env.rawValue).tag(env)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    RandomQuizSettingsView(selectedCategory: .constant(.food), numberOfOptions: .constant(4), speechSpeed: .constant(.normal), numberOfQuestions: .constant(25), environment: .constant(.quiet))
}
