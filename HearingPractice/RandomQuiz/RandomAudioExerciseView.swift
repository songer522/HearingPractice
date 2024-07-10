import SwiftUI

struct RandomAudioExerciseView: View {
    @State private var questions: [QuizQuestion] = []
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswer: String?
    @State private var showAlert = false
    @State private var score = 0
    @State private var lastPlayedPhrase: String?
    
    @ObservedObject private var audioPlayer = AudioPlayer()

    var body: some View {
        VStack {
            if currentQuestionIndex < questions.count {
                let currentQuestion = questions[currentQuestionIndex]
                
                Text("Question \(currentQuestionIndex + 1)")
                    .font(.largeTitle)
                    .padding()

                Button(action: {
                    playPhrase(from: currentQuestion)
                }) {
                    Text("Play Phrase")
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

                ForEach(currentQuestion.options, id: \.self) { option in
                    Button(action: {
                        selectedAnswer = option
                        checkAnswer()
                    }) {
                        Text(option)
                            .font(.title2)
                            .padding()
                            .background(selectedAnswer == option ? Color.gray : Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 2)
                            )
                    }
                    .padding(.vertical, 5)
                }

                Spacer()
            } else {
                Text("Quiz Completed")
                    .font(.largeTitle)
                    .padding()
                Text("Your Score: \(score) / \(questions.count)")
                    .font(.title)
                    .padding()
                Button(action: {
                    resetQuiz()
                }) {
                    Text("Restart Quiz")
                        .font(.title)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        .onAppear(perform: loadQuestions)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Correct!"), message: Text("Good job!"), dismissButton: .default(Text("Next")) {
                nextQuestion()
            })
        }
    }

    func loadQuestions() {
        questions = [
            QuizQuestion(options: ["The cat is sleeping", "The dog is barking", "The bird is flying", "The fish is swimming"]),
            QuizQuestion(options: ["I like apples", "I like bananas", "I like grapes", "I like oranges"]),
            QuizQuestion(options: ["The car is fast", "The bike is slow", "The train is on time", "The plane is delayed"]),
            QuizQuestion(options: ["She is reading a book", "He is writing a letter", "They are watching TV", "We are playing a game"]),
            QuizQuestion(options: ["The sun is shining", "The moon is bright", "The stars are twinkling", "The clouds are fluffy"]),
            QuizQuestion(options: ["The flowers are blooming", "The trees are tall", "The grass is green", "The leaves are falling"]),
            QuizQuestion(options: ["The pizza is hot", "The ice cream is cold", "The soup is warm", "The salad is fresh"]),
            QuizQuestion(options: ["The music is loud", "The movie is interesting", "The book is thrilling", "The game is fun"]),
            QuizQuestion(options: ["The house is big", "The apartment is cozy", "The garden is beautiful", "The kitchen is clean"]),
            QuizQuestion(options: ["The ocean is deep", "The river is flowing", "The lake is calm", "The waterfall is loud"]),
            QuizQuestion(options: ["The teacher is kind", "The student is attentive", "The class is quiet", "The lesson is important"]),
            QuizQuestion(options: ["The city is busy", "The village is peaceful", "The town is growing", "The neighborhood is friendly"]),
            QuizQuestion(options: ["The shop is open", "The market is crowded", "The mall is huge", "The store is closed"]),
            QuizQuestion(options: ["The computer is new", "The phone is old", "The tablet is fast", "The laptop is slow"]),
            QuizQuestion(options: ["The cat is purring", "The dog is running", "The bird is chirping", "The fish is jumping"]),
            QuizQuestion(options: ["The clock is ticking", "The alarm is ringing", "The bell is chiming", "The watch is beeping"]),
            QuizQuestion(options: ["The doctor is helping", "The nurse is caring", "The patient is resting", "The hospital is busy"]),
            QuizQuestion(options: ["The sun is setting", "The moon is rising", "The stars are shining", "The night is calm"]),
            QuizQuestion(options: ["The child is laughing", "The baby is crying", "The parent is smiling", "The family is happy"]),
            QuizQuestion(options: ["The cake is sweet", "The chocolate is rich", "The candy is colorful", "The cookie is delicious"]),
            QuizQuestion(options: ["The bus is late", "The train is early", "The taxi is waiting", "The bike is parked"]),
            QuizQuestion(options: ["The beach is sandy", "The mountain is high", "The forest is dense", "The desert is dry"]),
            QuizQuestion(options: ["The athlete is strong", "The team is winning", "The coach is guiding", "The game is exciting"]),
            QuizQuestion(options: ["The chair is comfortable", "The table is sturdy", "The sofa is soft", "The bed is cozy"]),
            QuizQuestion(options: ["The pasta is tasty", "The rice is fluffy", "The bread is fresh", "The cheese is melted"]),
            // Add more questions as needed
        ]
    }

    func playPhrase(from question: QuizQuestion) {
        if lastPlayedPhrase == nil {
            lastPlayedPhrase = question.options.randomElement()
        }
        if let phrase = lastPlayedPhrase {
            audioPlayer.speak(text: phrase, language: "en-US")
        }
    }

    func checkAnswer() {
        if selectedAnswer == lastPlayedPhrase {
            score += 1
            showAlert = true
        } else {
            nextQuestion()
        }
    }

    func nextQuestion() {
        selectedAnswer = nil
        lastPlayedPhrase = nil
        currentQuestionIndex += 1
    }

    func resetQuiz() {
        currentQuestionIndex = 0
        score = 0
        lastPlayedPhrase = nil
        loadQuestions()
    }
}
