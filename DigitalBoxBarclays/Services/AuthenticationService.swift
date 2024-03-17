//
//  AuthenticationService.swift
//  DigitalBoxBarclays
//
//  Created by Chinmay Patil on 12/03/24.
//

import Foundation
import AWSCognitoAuthPlugin
import Amplify

enum AuthResult {
    case success
    case failure
    case confirmationLeft
}

class AuthenticationService {
    var unsubscribeToken = Amplify.Hub.listen(to: .auth) { payload in
        switch payload.eventName {
        case HubPayload.EventName.Auth.signedIn:
            print("User signed in")
                Task {
                    guard let userID = try? await Amplify.Auth.getCurrentUser().userId else {
                        DispatchQueue.main.async {
                            Router.shared.setRoute(.auth)
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        Router.shared.setRoute(.home(userID: userID))
                        return
                    }
                }

        case HubPayload.EventName.Auth.signedOut:
            print("User signed out")
                DispatchQueue.main.async {
                    Router.shared.setRoute(.auth)
                }

        case HubPayload.EventName.Auth.userDeleted:
            print("User deleted")
                DispatchQueue.main.async {
                    Router.shared.setRoute(.auth)
                }
                
        default:
            break
        }
    }
    
    var userID: String? {
        get async {
            return try? await Amplify.Auth.getCurrentUser().userId
        }
    }
    
    func signUpWithEmail(email: String, password: String, name: String) async throws -> AuthResult {
        let userAttributes = [AuthUserAttribute(.email, value: email), AuthUserAttribute(.name, value: name)]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        let signUpResult = try await Amplify.Auth.signUp(
            username: email,
            password: password,
            options: options
        )
        if case let .confirmUser(deliveryDetails, _, userId) = signUpResult.nextStep {
            print("Delivery details \(String(describing: deliveryDetails)) for userId: \(String(describing: userId))")
            return .confirmationLeft
        } else {
            print("SignUp Complete")
            return .success
        }
    }
    
    func confirmSignUp(for email: String, with confirmationCode: String) async throws {
        let confirmSignUpResult = try await Amplify.Auth.confirmSignUp(
            for: email,
            confirmationCode: confirmationCode
        )
        print("Confirm sign up result completed: \(confirmSignUpResult.isSignUpComplete)")
        if confirmSignUpResult.isSignUpComplete {
            guard let userID = await self.userID else { return }
            Router.shared.setRoute(.home(userID: userID))
        }
    }
    
    func sendConfirmationCode(for email: String) async throws {
        let _ = try await Amplify.Auth.sendVerificationCode(forUserAttributeKey: .email)
    }
    
    func signInWithEmail(email: String, password: String) async throws -> AuthResult {
        let result = try await Amplify.Auth.signIn(
            username: email,
            password: password
        )
        switch result.nextStep {
            case .confirmSignUp(_):
                Task { try await self.sendConfirmationCode(for: email) }
                return .confirmationLeft
            case .done:
                return .success
            default:
                print("NEXT AUTH STEP: \(result.nextStep)")
                return .failure
        }
    }
    
    func checkUser(email: String) async throws -> Bool {
        do {
            let _ = try await Amplify.Auth.signIn(
                username: email,
                password: ""
            )
            return true
        } catch let error as AuthError {
            if error.errorDescription == "Incorrect username or password." {
                return true
            } else {
                print("Caught AuthError while checking user: \(error)")
            }
        }
        return false
    }
    
    func fetchCurrentAuthSession() async throws -> Bool {
        let session = try await Amplify.Auth.fetchAuthSession()
        return session.isSignedIn
    }
    
    func logOut() async {
        let _ = await Amplify.Auth.signOut()
    }
}
