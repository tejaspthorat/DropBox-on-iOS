//
//  HomeView.swift
//  DigitalBoxBarclays
//
//  Created by Chinmay Patil on 12/03/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authVM: AuthVM
    let userID: String
    var body: some View {
        TabView {
            NavigationStack {
                DashboardView()
                    .navigationTitle("Dashboard")
                    .toolbar {
                        Button {
                            authVM.logOut()
                        } label: {
                            Text("Log Out")
                        }
                    }
            }
            .tabItem {
                Label("Dashboard", systemImage: "house")
            }
            DocumentBoxScreen()
                .environmentObject(DocumentStoreVM(userID: userID))
            .tabItem {
                Label("Document Box", systemImage: "doc.on.doc")
            }
            QueriesHomeView()
                .environmentObject(QueriesVM())
                .navigationTitle("Support")
                    
            .tabItem {
                Label("Support", systemImage: "exclamationmark.bubble")
            }

        }
        
    }
}

#Preview {
    HomeView(userID: "abc")
}
