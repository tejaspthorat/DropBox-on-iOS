//
//  LaunchView.swift
//  DigitalBoxBarclays
//
//  Created by Chinmay Patil on 11/03/24.
//

import SwiftUI

struct LaunchView: View {
    @EnvironmentObject var authVM: AuthVM
    
    var body: some View {
        VStack {
            Spacer()
            Image(.barclaysLogo)
                .resizable()
                .scaledToFit()
                .padding(.all, 32)
                .scaleEffect(authVM.currentState == 0 ? 1 : 25)
            Spacer()
            Button {
                authVM.begin()
            } label: {
                Text("Get Started")
                    .padding()
                    .padding(.horizontal, 8)
                    .background(Color.black)
                    .clipShape(Capsule())
            }
            .padding(.top, 32)
            .foregroundStyle(Color.white)
            Text("The best place for all your Pounds, Dollars, Rupees and more.")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.top, 32)
        }
    }
}

#Preview {
    LaunchView()
        .environmentObject(AuthVM())
}
