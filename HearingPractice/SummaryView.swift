//
//  SummaryView.swift
//  HearingPractice
//
//  Created by Yang Song on 6/29/24.
//

import SwiftUI

struct SummaryView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("Exercise Complete!")
                .font(.largeTitle)
                .padding()
            
            Text("Great job! You've finished the audio exercise.")
                .font(.title2)
                .padding()
            
            Button(action: {
                // Dismiss the summary view to restart the exercise
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Start Again")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
}

