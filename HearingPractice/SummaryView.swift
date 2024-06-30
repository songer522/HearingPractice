import SwiftUI

struct SummaryView: View {
    let correctAnswers: Int
    let totalQuestions: Int
    @Environment(\.presentationMode) var presentationMode
    var onStartOver: () -> Void
    @Binding var navigateToHome: Bool

    var body: some View {
        VStack {
            Text("Summary")
                .font(.largeTitle)
                .padding()
            
            Text("Correct Answers: \(correctAnswers) / \(totalQuestions)")
                .font(.title)
                .padding()
            
            Text(String(format: "Correct Percentage: %.2f%%", correctPercentage))
                .font(.title)
                .padding()
            
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss() // Dismiss the summary view
                    self.navigateToHome = true // Trigger navigation to home screen
                }) {
                    Text("Exit to Home Screen")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
                
                Button(action: {
                    self.onStartOver() // Call the onStartOver closure to reset the exercise
                    self.presentationMode.wrappedValue.dismiss() // Dismiss the summary view
                }) {
                    Text("Start Over")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
                .padding(.leading, 20)
            }
        }
    }
    
    var correctPercentage: Double {
        guard totalQuestions > 0 else { return 0.0 }
        return (Double(correctAnswers) / Double(totalQuestions)) * 100
    }
}
