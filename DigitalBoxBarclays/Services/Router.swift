//
//  Router.swift
//  DigitalBoxBarclays
//
//  Created by Chinmay Patil on 11/03/24.
//

import SwiftUI

public enum Routes {
    case auth
    case home(userID: String)
    case enterOTP
}


//class Router: ObservableObject {
//    static var shared = Router()
//    private init() {}
//    @Published var navStack = NavigationPath()
//    
//    func push(_ route: Routes) {
//        print("Pushing \(route)")
//        navStack.append(route)
//    }
//    
//    func pop() {
//        navStack.removeLast()
//    }
//    
//    func popToRoot() {
//        navStack = NavigationPath()
//    }
//    
//}

class Router: ObservableObject {
    static var shared = Router()
    private init() {}
    @Published var currentRoute = Routes.auth
    
    func setRoute(_ route: Routes) {
        print("Pushing \(route)")
        currentRoute = route
    }
    
}
