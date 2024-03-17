//
//  QueryService.swift
//  DigitalBoxBarclays
//
//  Created by Chinmay Patil on 15/03/24.
//

import Foundation

class QueryService {
    let url: String
    
    init(url: String) {
        self.url = url
    }
    
    func fetchChats() async -> [DigitalBoxChat] {
        var request = URLRequest(url: URL(string: "172.20.10.3:4000/api/v1/get-chats")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            print(data)
        }
        task.resume()
        return []
    }
}
