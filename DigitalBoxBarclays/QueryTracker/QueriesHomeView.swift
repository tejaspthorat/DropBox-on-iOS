//
//  QueriesHomeView.swift
//  DigitalBoxBarclays
//
//  Created by Chinmay Patil on 15/03/24.
//

import SwiftUI

struct QueriesHomeView: View {
    
    @EnvironmentObject var queriesVM: QueriesVM
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        // Book an Appointment
                    } label: {
                        Label("New Appointment", systemImage: "calendar.badge.plus")
                        //                        .frame(maxWidth: .infinity)
                    }
                    //                .buttonStyle(.bordered)
                    Button {
                        // Raise a Ticket
                    } label: {
                        Label("Raise Ticket", systemImage: "exclamationmark.bubble")
                        //                        .frame(maxWidth: .infinity)
                    }
                    //                .buttonStyle(.bordered)
                    Button {
                        // Chat with AI
                    } label: {
                        Label("New chat with ClayBot", systemImage: "text.bubble")
                        //                        .frame(maxWidth: .infinity)
                    }
                    //                .buttonStyle(.bordered)
                    Button {
                        // Chat with Human
                    } label: {
                        Label("Chat with a representative", systemImage: "person.2")
                        //                        .frame(maxWidth: .infinity)
                    }
                    //                .buttonStyle(.bordered)
                }
                Section("Active Chats") {
                    ForEach(queriesVM.chats) { chat in
                        NavigationLink {
                            ChatView(chat: chat)
                        } label: {
                            Text(chat.description ?? "Chat")
                        }
                    }
                }
                Section("Archived Chats") {
                    ForEach(queriesVM.archivedChats) { chat in
                        NavigationLink {
                            ChatView(chat: chat)
                        } label: {
                            Text(chat.description ?? "Chat")
                        }
                    }
                }
            }
        }
    }
}

struct ChatView: View {
    var chat: DigitalBoxChat
    @EnvironmentObject var queriesVM: QueriesVM
    @State var textbox: String = ""
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView {
                VStack {
                    ForEach(chat.messages) { message in
                        switch message.content {
                            case .text(let text):
                                TextMessageView(message: text, author: message.author)
                                    .id(message.id)
                            case .image(_):
                                Text("Some Image")
                                    .id(message.id)
                        }
                    }
                }
                .padding(.horizontal)
                .animation(.easeInOut, value: queriesVM.chats)
            }
            .onAppear {
                withAnimation {
                    scrollProxy.scrollTo(chat.messages.last?.id)
                }
            }
            .onChange(of: chat.messages.count) {
                withAnimation {
                    scrollProxy.scrollTo(chat.messages.last?.id)
                }
            }
        }
        HStack {
            TextField(chat.archived ? "This chat is archived" : "Type a message", text: $textbox)
                .textFieldStyle(.roundedBorder)
                .disabled(chat.archived)
            Button {
                if textbox == "" { return }
                    queriesVM.sendMessage(chat: chat, message: .init(id: UUID().uuidString, author: .user, content: .text(textbox), timestamp: Date()))
                    textbox = ""
            } label: {
                Image(systemName: "paperplane")
            }.disabled(chat.archived)
        }
        .padding()
        .background(Material.regular)
    }
}

struct TextMessageView: View {
    var message: String
    var author: MessageAuthor
    var body: some View {
        HStack {
            if author == .user {
                Spacer()
            }
            Text(message)
                .padding(8)
                .background {
                    if author == .agent {
                        Rectangle()
                            .foregroundStyle(Material.ultraThick)
                    } else {
                        Color.accentColor
                    }
                }
                .clipShape(
                    UnevenRoundedRectangle(
                        cornerRadii: .init(
                            topLeading: 8,
                            bottomLeading: author == .agent ? 0 : 8,
                            bottomTrailing: author == .user ? 0 : 8,
                            topTrailing: 8
                        )
                    )
                )
            if author == .agent {
                Spacer()
            }
        }
    }
}

#Preview {
    QueriesHomeView()
        .environmentObject(QueriesVM())
}


