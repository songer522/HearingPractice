import SwiftUI
import AVFoundation

struct AudioExerciseView: View {
    @Binding var selectedSounds: [String: [URL]]
    let questions: [String]
    @State private var currentQuestionIndex: Int = 0
    @State private var selectedSound: URL?
    @State private var isCorrect: Bool? = nil
    @State private var showSummary: Bool = false
    @State private var feedbackColor: Color = Color.clear
    @State private var correctAnswers: Int = 0 // Track correct answers
    @State private var correctRecordingName: String? = nil // Track the correct recording name
    @State private var isPlayingRepeatedly = false // Track if the sound is being played repeatedly
    @ObservedObject var audioPlayer = AudioPlayer()
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @Binding var navigateToHome: Bool

    var body: some View {
        VStack {
            if questions.isEmpty {
                Text("No questions loaded.")
                    .font(.title)
                    .padding()
                    .foregroundColor(.primary)
            } else {
                Text("Question \(currentQuestionIndex + 1) / \(questions.count)")
                    .font(.title)
                    .padding()
                    .foregroundColor(.primary)

                if let sounds = selectedSounds[questions[currentQuestionIndex]], !sounds.isEmpty {
                    Button(action: {
                        self.playCurrentSound()
                    }) {
                        Text("Play Again")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 20)
                    .onAppear {
                        self.selectRandomSound()
                        self.playCurrentSound()
                    }

                    VStack {
                        ForEach(sounds, id: \.self) { sound in
                            Button(action: {
                                self.checkAnswer(sound)
                            }) {
                                Text(formattedFileName(from: sound.lastPathComponent))
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .shadow(color: .gray, radius: 5, x: 0, y: 5)
                            }
                            .padding(.horizontal)
                            .disabled(isPlayingRepeatedly) // Disable the button if playing repeatedly
                        }
                    }
                    .padding()

                    if let isCorrect = isCorrect {
                        Text(isCorrect ? "Correct!" : "\(correctRecordingName ?? "")")
                            .font(.title2)
                            .foregroundColor(isCorrect ? feedbackColor : feedbackColor)
                            .padding()
                            .transition(.opacity)
                            .animation(.easeInOut(duration: 1.0))
                    }
                } else {
                    Text("No recordings selected for this question.")
                        .padding()
                        .foregroundColor(.primary)
                }

                Spacer()

                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Exit to Home Screen")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.bottom, 20)
            }
        }
        .background(feedbackColor)
        .animation(.easeInOut(duration: 0.5), value: feedbackColor)
        .navigationTitle("Audio Exercise")
        .padding()
        .fullScreenCover(isPresented: $showSummary) {
            SummaryView(correctAnswers: correctAnswers, totalQuestions: questions.count, onStartOver: resetExercise, navigateToHome: $navigateToHome)
                .onDisappear {
                    resetExercise()
                }
        }
    }

    func selectRandomSound() {
        if let sounds = selectedSounds[questions[currentQuestionIndex]], !sounds.isEmpty {
            selectedSound = sounds.randomElement()
            print("Selected sound: \(selectedSound?.lastPathComponent ?? "None")")
        }
    }

    func playCurrentSound() {
        if let sound = selectedSound {
            print("Playing sound: \(sound.lastPathComponent)")
            audioPlayer.playSound(soundURL: sound)
        }
    }

    func checkAnswer(_ answer: URL) {
        if let sound = selectedSound {
            withAnimation {
                isCorrect = (answer == sound)
                feedbackColor = (isCorrect == true ? (colorScheme == .dark ? Color.green.opacity(0.7) : Color.green) : (colorScheme == .dark ? Color.red.opacity(0.7) : Color.red))
                correctRecordingName = formattedFileName(from: sound.lastPathComponent)
                print("Answer checked: \(isCorrect == true ? "Correct" : "Incorrect")")
            }

            if isCorrect == true {
                correctAnswers += 1 // Increment correct answers if the answer is correct
                print("Correct Answers incremented: \(correctAnswers)")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.nextQuestionOrSummary()
                }
            } else {
                isPlayingRepeatedly = true
                playSoundRepeatedly(soundURL: sound, times: 3) {
                    isPlayingRepeatedly = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.nextQuestionOrSummary()
                    }
                }
            }
        }
    }

    func playSoundRepeatedly(soundURL: URL, times: Int, completion: @escaping () -> Void) {
        guard times > 0 else {
            completion()
            return
        }

        print("Repeating sound: \(soundURL.lastPathComponent), times left: \(times)")
        audioPlayer.playSound(soundURL: soundURL)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.playSoundRepeatedly(soundURL: soundURL, times: times - 1, completion: completion)
        }
    }

    func nextQuestionOrSummary() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            selectRandomSound()
            isCorrect = nil
            feedbackColor = Color.clear
            correctRecordingName = nil
            playCurrentSound()
        } else {
            showSummary = true
        }
    }

    func resetExercise() {
        currentQuestionIndex = 0
        correctAnswers = 0 // Reset correct answers
        selectRandomSound()
        isCorrect = nil
        feedbackColor = Color.clear
        correctRecordingName = nil
        playCurrentSound()
    }

    func formattedFileName(from fileName: String) -> String {
        return fileName
            .replacingOccurrences(of: "_", with: " ")
            .replacingOccurrences(of: ".m4a", with: "")
    }
}
