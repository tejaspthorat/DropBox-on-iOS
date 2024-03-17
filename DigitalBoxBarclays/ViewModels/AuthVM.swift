//
//  AuthVM.swift
//  DigitalBoxBarclays
//
//  Created by Chinmay Patil on 12/03/24.
//

import Foundation

@MainActor
class AuthVM: ObservableObject {
    @Published var currentState = 0
    
    var email: String?
    
    
    let authService = AuthenticationService()
    
    // 0 - Initial / Get Started
    // 1 - Email Display
    // 2 - Checking if user exists
    // 3 - Existing User, Show Password Field
    // 4 - Checking password
    // 5 - New User, Show Password and Name
    // 6 - Createing User
    // 7 - Logged In
    
    init() {
        Task {
            do {
                let isSignedIn = try await authService.fetchCurrentAuthSession()
                if isSignedIn {
                    guard let userID = await authService.userID else { return }
                    Router.shared.setRoute(.home(userID: userID))
                }
            } catch {
                ErrorHandlerVM.shared.showError(error)
            }
        }
    }
    
    func begin() {
        currentState = 1
    }
    
    func checkUser(email: String) {
        currentState = 2
        Task {
            do {
                let result = try await self.authService.checkUser(email: email)
                if result {
                    self.currentState = 3
                } else {
                    self.currentState = 5
                }
            } catch {
                ErrorHandlerVM.shared.showError(error)
                currentState = 1
            }
        }
    }
    
    func signIn(email: String, password: String) {
        currentState += 1
        Task {
            do {
                let result = try await authService.signInWithEmail(email: email, password: password)
                print("Sign In Result in VM: \(result)")
                switch result {
                        
                    case .success:
                        self.currentState = 0
                        
                    case .failure:
                        self.currentState = 1
                        
                    case .confirmationLeft:
                        Router.shared.setRoute(.enterOTP)
                        self.currentState = 1
                        self.email = email
                        
                }
            } catch {
                ErrorHandlerVM.shared.showError(error)
                currentState = 1
            }
        }
    }
    
    func signUpWithEmail(email: String, password: String, name: String) {
        currentState += 1
        Task {
            do {
                let result = try await authService.signUpWithEmail(email: email, password: password, name: name)
                self.email = email
                print("Sign Up Result in VM: \(result)")
                switch result {
                        
                    case .success:
                        self.currentState = 0
                    case .failure:
                        self.currentState = 1
                    case .confirmationLeft:
                        Router.shared.setRoute(.enterOTP)
                        self.currentState = 1
                }
            } catch {
                ErrorHandlerVM.shared.showError(error)
                currentState = 1
            }
        }
    }
    
    func confirmSignUp(digits: [String] ) {
        guard let email = self.email else { print("Unexpected Error"); return }
        var OTP = ""
        for digit in digits {
            OTP += digit
        }
        guard OTP.count == 6 else { print("Invalid OTP"); return }
        Task {
            do { try await authService.confirmSignUp(for: email, with: OTP) } catch {
                ErrorHandlerVM.shared.showError(error)
            }
        }
    }
    
    func logOut() {
        Task {
            await authService.logOut()
        }
    }
    
    func resendOTP() {
        guard let email = self.email else { print("Unexpected Error"); return }
        Task {
            do { try await authService.sendConfirmationCode(for: email) } catch {
                ErrorHandlerVM.shared.showError(error)
            }
        }
        
    }
    
}
