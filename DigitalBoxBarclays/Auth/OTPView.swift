//
//  OTPView.swift
//  DigitalBoxBarclays
//
//  Created by Chinmay Patil on 12/03/24.
//

import SwiftUI

struct OTPView: View {
    @EnvironmentObject var authVM: AuthVM
    @State var digits: [String] = ["", "", "", "", "", ""]
    @FocusState private var focus: Int?
    var body: some View {
        VStack {
            Text("Please Enter the 6 Digit code sent to your email ID")
                .padding(48)
                .multilineTextAlignment(.center)
                .font(.title2)
                .bold()
            HStack {
                ForEach(0 ..< 6) { i in
                    TextField("", text: $digits[i])
                        .frame(width: 50, height: 60)
                        .font(.title)
                        .fontWeight(.bold)
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(i == focus ? Color.accentColor : Color.black, lineWidth: 2)
                        )
                        .onTapGesture {
                            digits[i] = ""
                            focus = i
                        }
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .onChange(of: digits[i], initial: false) { oldValue, newValue in
                            if newValue.count > 1 {
                                digits[i] = String(newValue.last!)
                            }
                            if newValue.count == 1 {
                                if i < digits.count - 1 {
                                    focus = i + 1
                                } else {
                                    focus = nil
                                }
                            }
                        }
                        .focused($focus, equals: i)
                        .tint(.clear)
                }
            }
            .animation(.easeInOut, value: focus)
            HStack {
                Button {
                    focus = 0
                    authVM.resendOTP()
                } label: {
                    Text("Resend OTP")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .foregroundStyle(.black)
                Button {
                    authVM.confirmSignUp(digits: digits)
                } label: {
                    Text("Confirm")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .foregroundStyle(.white)
            }
            .padding(32)
        }
    }
}

#Preview {
    OTPView()
        .environmentObject(AuthVM())
}
