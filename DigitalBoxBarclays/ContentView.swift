//
//  ContentView.swift
//  DigitalBoxBarclays
//
//  Created by Chinmay Patil on 11/03/24.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var router = Router.shared
    @ObservedObject var authVM = AuthVM()
    @ObservedObject var errorHandler = ErrorHandlerVM.shared
    
    var body: some View {
//        NavigationStack(path: $router.navStack) {
//            Text("Root")
//                .navigationDestination(for: Routes.self) { destination in
//                    switch destination {
//                        case .auth: AuthScreen()
//                                .navigationBarBackButtonHidden()
//                        case .home: HomeView()
//                                .navigationBarBackButtonHidden()
//                        case .enterOTP: OTPView()
//                                .navigationBarBackButtonHidden()
//                    }
//                }
//        }
        Group {
            switch router.currentRoute {
                case .auth: AuthScreen()
                        .transition(.slide)
                case .home(let userID): HomeView(userID: userID)
                        .transition(.slide)
                case .enterOTP: OTPView()
                        .transition(.slide)
            }
        }
        .alert(errorHandler.error?.localizedDescription ?? "Unknown Error", isPresented: $errorHandler.isShowingError) {
                    Button("OK", role: .cancel) {
                        errorHandler.clearError()
                    }
                }
        .environmentObject(authVM)
    }
}

#Preview {
    ContentView()
}
