import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5

    var body: some View {
        if isActive {
            ContentView() // Replace with your main content view
        } else {
            VStack {
                if let _ = UIImage(named: "appstore") {
                    Image("appstore") // Use the exact name of your app icon image in assets
                        .resizable()
                        .frame(width: 100, height: 100)
                        .scaleEffect(size)
                        .opacity(opacity)
                        .clipShape(Circle())
                        .onAppear {
                            withAnimation(.easeIn(duration: 1.2)) {
                                self.size = 1.0
                                self.opacity = 1.0
                            }
                        }
                } else {
                    Text("AppIcon not found")
                        .foregroundColor(.red)
                }
                Text("Alicia❤️❤️😘😘")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}
