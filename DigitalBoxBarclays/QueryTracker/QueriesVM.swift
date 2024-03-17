//
//  QueriesVM.swift
//  DigitalBoxBarclays
//
//  Created by Chinmay Patil on 15/03/24.
//

import Foundation

class QueriesVM: ObservableObject {
    
    @Published var archivedChats: [DigitalBoxChat] = []
    @Published var chats: [DigitalBoxChat] = []
    @Published var tickets: [DigitalBoxTicket] = []
    @Published var appointment: [Date] = []
    
    init() {
        chats = Array(generateSampleChats(archived: false)[0 ..< 2])
        archivedChats = [generateSampleChats(archived: true)[2]]
    }
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in letters.randomElement()! })
    }
    
    func sendMessage(chat: DigitalBoxChat, message: DigitalBoxMessage) {
        for index in 0..<chats.count {
            if chats[index].id == chat.id {
                chats[index].messages.append(message)
                break
            }
        }
    }

    // Function to generate sample chats
    func generateSampleChats(archived: Bool) -> [DigitalBoxChat] {
        var chats = [DigitalBoxChat]()

        // Sample scenarios
        let scenarios: [(description: String, messages: [(author: MessageAuthor, content: DigitalBoxMessageContent)])] = [
            (
                description: "I am unable to log in to my online banking account.",
                messages: [
                    (author: .user, content: .text("I am unable to log in to my online banking account. Can you help me?")),
                    (author: .agent, content: .text("Sure, let me assist you with that. Have you tried resetting your password?")),
                    (author: .user, content: .text("Yes, I've tried resetting my password, but it's still not working.")),
                    (author: .agent, content: .text("Let me check your account details. Could you please provide me with your username?")),
                    (author: .user, content: .text("My username is johndoe123.")),
                    (author: .agent, content: .text("Thank you. I'm checking your account now.")),
                    (author: .agent, content: .text("It seems like there was an issue with your account. I've fixed it now. Please try logging in again.")),
                    (author: .user, content: .text("Thank you, it's working now!")),
                ]
            ),
            (
                description: "I need assistance with transferring funds between my accounts.",
                messages: [
                    (author: .user, content: .text("I need assistance with transferring funds between my accounts.")),
                    (author: .agent, content: .text("Of course, I can help you with that. Could you please provide me with the account numbers and the amount you'd like to transfer?")),
                    (author: .user, content: .text("I want to transfer $1000 from my savings account to my checking account.")),
                    (author: .agent, content: .text("Got it. Let me process the transfer for you.")),
                    (author: .agent, content: .text("The transfer has been completed successfully. Is there anything else I can assist you with?")),
                    (author: .user, content: .text("No, that's all. Thank you for your help!")),
                ]
            ),
            (
                description: "I have a question about the investment options available.",
                messages: [
                    (author: .user, content: .text("I have a question about the investment options available.")),
                    (author: .agent, content: .text("Sure, I can provide you with information about our investment options. What specifically would you like to know?")),
                    (author: .user, content: .text("I'm interested in long-term investment options with low risk. Do you have any recommendations?")),
                    (author: .agent, content: .text("Yes, we have several options that might fit your criteria. Let me gather some details for you.")),
                    (author: .agent, content: .text("Here are some investment options that match your requirements. Would you like more information about any specific option?")),
                    (author: .user, content: .text("Yes, I'd like more information about option A, please.")),
                    (author: .agent, content: .text("Certainly. Here are the details of option A...")),
                ]
            ),
        ]

        // Generating chats based on scenarios
        for scenario in scenarios {
            let chatID = UUID().uuidString
            var messages = [DigitalBoxMessage]()
            for (index, message) in scenario.messages.enumerated() {
                let messageID = UUID().uuidString
                let timestamp = Date().addingTimeInterval(Double(index) * -300) // Messages spaced 5 minutes apart
                let digitalBoxMessage = DigitalBoxMessage(id: messageID, author: message.author, content: message.content, timestamp: timestamp)
                messages.append(digitalBoxMessage)
            }
            let chat = DigitalBoxChat(id: chatID, description: scenario.description, userID: UUID().uuidString, ticket: nil, messages: messages, archived: archived)
            chats.append(chat)
        }

        return chats
    }
}
