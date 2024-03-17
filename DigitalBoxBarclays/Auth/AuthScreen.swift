//
//  AuthScreen.swift
//  DigitalBoxBarclays
//
//  Created by Chinmay Patil on 12/03/24.
//

import SwiftUI

struct AuthScreen: View {
    @EnvironmentObject var authVM: AuthVM
    
    var body: some View {
        ZStack {
            Color.cyan
                .ignoresSafeArea()
                .opacity(authVM.currentState == 0 ? 0 : 1)
            LaunchView()
                .opacity(authVM.currentState == 0 ? 1 : 0)
            AuthView()
                .opacity(authVM.currentState > 0 ? 1 : 0)
        }
        .animation(.snappy(duration: 0.8), value: authVM.currentState)
    }
}

#Preview {
    AuthScreen()
        .environmentObject(AuthVM())
}
