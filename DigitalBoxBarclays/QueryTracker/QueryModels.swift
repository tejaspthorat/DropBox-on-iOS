//
//  Ticket.swift
//  DigitalBoxBarclays
//
//  Created by Chinmay Patil on 15/03/24.
//

import Foundation

struct DigitalBoxTicket: Codable, Equatable {
    var id: String
    var description: String
}

struct DigitalBoxChat: Codable, Identifiable, Equatable {
    var id: String
    var description: String?
    var userID: String
    var ticket: DigitalBoxTicket?
    var messages: [DigitalBoxMessage]
    var archived: Bool
}

enum MessageAuthor: Codable, Equatable {
    case user
    case agent
}

enum DigitalBoxMessageContent: Codable, Equatable {
    case text(String)
    case image(Data)
}

struct DigitalBoxMessage: Codable, Identifiable, Equatable {
    var id: String
    var author: MessageAuthor
    var content: DigitalBoxMessageContent
    var timestamp: Date
}
