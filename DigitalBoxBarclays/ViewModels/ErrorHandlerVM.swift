//
//  ErrorHandlerVM.swift
//  DigitalBoxBarclays
//
//  Created by Chinmay Patil on 13/03/24.
//

import SwiftUI

@MainActor
class ErrorHandlerVM: ObservableObject {
    @Published var error: Error?
    @Published var isShowingError = false
    
    private init() {}
    
    static let shared = ErrorHandlerVM()
    
    func showError(_ error: Error) {
        self.error = error
        self.isShowingError = true
    }
    
    func clearError() {
        self.error = nil
        self.isShowingError = false
    }

}
