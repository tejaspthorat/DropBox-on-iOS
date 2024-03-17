//
//  AuthView.swift
//  DigitalBoxBarclays
//
//  Created by Chinmay Patil on 12/03/24.
//

import SwiftUI

struct AuthView: View {
    @EnvironmentObject var authVM: AuthVM
    
    @State var emailString = "crpatil1901@gmail.com"
    @State var passwordString = ""
    @State var nameString = ""
    
    var body: some View {
        VStack {
            Text("Sign in")
                .font(.custom("BakerSignet", size: 48))
                .foregroundStyle(.white)
            VStack {
                TextField("Email", text: $emailString)
                    .padding(.horizontal)
                    .overlay {
                        HStack {
                            Spacer()
                            ZStack {
                                Button {
                                    authVM.checkUser(email: emailString)
                                } label: {
                                    Image(systemName: "arrow.forward.circle")
                                        .foregroundStyle(.black)
                                }
                                .opacity(authVM.currentState == 1 ? 1 : 0)
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .opacity(authVM.currentState == 2 ? 1 : 0)
                            }
                            .padding(.trailing)
                            .animation(.easeInOut(duration: 0.2), value: authVM.currentState)
                        }
                    }
                if authVM.currentState == 5 ||
                    authVM.currentState == 6 ||
                    authVM.currentState == 7 {
                    Divider()
//                            .frame(height: 1)
//                            .overlay(.black)
                        .padding(.vertical, 8)
                    TextField("Name", text: $nameString)
                        .padding(.horizontal)
                }
                if authVM.currentState > 2 {
                    Divider()
//                            .frame(height: 1)/
//                            .overlay(.black)
                        .padding(.vertical, 8)
                    TextField("Password", text: $passwordString)
                        .padding(.horizontal)
                        .overlay {
                            HStack {
                                Spacer()
                                ZStack {
                                    Button {
                                        if authVM.currentState == 3 {
                                            authVM.signIn(email: emailString, password: passwordString)
                                        } else if authVM.currentState == 5 {
                                            authVM.signUpWithEmail(
                                                email: emailString,
                                                password: passwordString,
                                                name: nameString
                                            )
                                        }
                                    } label: {
                                        Image(systemName: "arrow.forward.circle")
                                            .foregroundStyle(.black)
                                    }
                                    .opacity(authVM.currentState == 3 || authVM.currentState == 5 ? 1 : 0)
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle())
                                        .opacity(authVM.currentState == 4 || authVM.currentState == 6 ? 1 : 0)
                                }
                                .animation(.easeInOut(duration: 0.2), value: authVM.currentState)
                                .padding(.trailing)
                            }
                        }
                }
            }
            .padding(.vertical)
            .background(Material.regular)
            .cornerRadius(8)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 8)
//                        .stroke(.black, lineWidth: 1)
//                )
            .padding(.horizontal, 32)
        }
    }
}

#Preview {
    AuthView()
}
