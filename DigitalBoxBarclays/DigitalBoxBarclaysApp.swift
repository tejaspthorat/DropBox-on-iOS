//
//  DigitalBoxBarclaysApp.swift
//  DigitalBoxBarclays
//
//  Created by Chinmay Patil on 11/03/24.
//

import Amplify
import AWSAPIPlugin
import AWSCognitoAuthPlugin
import AWSDataStorePlugin
import AWSS3StoragePlugin
import SwiftUI
import UIKit

@main
struct DigitalBoxBarclaysApp: App {
    
    init() {
        do {
            try Amplify.add(plugin: AWSAPIPlugin(modelRegistration: AmplifyModels()))
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSS3StoragePlugin())
            try Amplify.configure()
            print("Amplify configured with Auth, Storage and DataStore plugins")
        } catch {
            print("Could not initialize Amplify: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
