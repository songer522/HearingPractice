import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var iconScale = 0.5
    @State private var iconOpacity = 0.0
    @State private var titleOpacity = 0.0
    @State private var titleOffset: CGFloat = 20
    @State private var waveOffset: CGFloat = 0

    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                // Gradient background
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.4)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Spacer()
                    
                    // Icon with pulsing effect
                    ZStack {
                        // Outer glow circle
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 140, height: 140)
                            .scaleEffect(iconScale * 1.2)
                        
                        // Main icon container
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 120, height: 120)
                            
                            if let _ = UIImage(named: "appstore") {
                                Image("appstore")
                                    .resizable()
                                    .frame(width: 110, height: 110)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "ear.and.waveform")
                                    .font(.system(size: 60))
                                    .foregroundColor(.blue)
                            }
                        }
                        .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
                    }
                    .scaleEffect(iconScale)
                    .opacity(iconOpacity)
                    
                    // App title with animation
                    VStack(spacing: 8) {
                        Text("Cochleo")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Improve Your Listening Skills")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .opacity(titleOpacity)
                    .offset(y: titleOffset)
                    
                    Spacer()
                    Spacer()
                }
            }
            .onAppear {
                // Animate icon
                withAnimation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0)) {
                    iconScale = 1.0
                    iconOpacity = 1.0
                }
                
                // Animate title after icon
                withAnimation(.easeOut(duration: 0.6).delay(0.3)) {
                    titleOpacity = 1.0
                    titleOffset = 0
                }
                
                // Transition to main view
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
