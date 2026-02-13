import SwiftUI

struct WelcomeTutorialView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Spacer()
                
                // App Icon or Image
                Image(systemName: "ear.and.waveform")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                
                // Welcome Title
                Text("Welcome to Cochleo")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Description
                VStack(spacing: 20) {
                    Text("This app is designed to help cochlear implant patients practice and improve their hearing skills.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 30)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        FeatureRow(icon: "speaker.wave.3", title: "Listen & Practice", description: "Hear phrases spoken aloud and select the correct answer")
                        
                        FeatureRow(icon: "slider.horizontal.3", title: "Customize Settings", description: "Adjust speech speed, difficulty, and listening environment")
                        
                        FeatureRow(icon: "chart.bar", title: "Track Progress", description: "View your quiz results and monitor improvement over time")
                    }
                    .padding(.horizontal, 30)
                }
                
                Spacer()
                
                // Get Started Button
                Button(action: {
                    dismiss()
                }) {
                    Text("Get Started")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 30)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .interactiveDismissDisabled()
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    WelcomeTutorialView()
}
