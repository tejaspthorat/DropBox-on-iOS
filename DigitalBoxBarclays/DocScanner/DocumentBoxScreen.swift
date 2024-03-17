//
//  DocumentBoxScreen.swift
//  DigitalBoxBarclays
//
//  Created by Chinmay Patil on 14/03/24.
//

import SwiftUI
import PDFKit

struct DocumentBoxScreen: View {
    
    @State var isSheetPresented = false
    @EnvironmentObject var documentStoreVM: DocumentStoreVM
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(documentStoreVM.freshlyScannedDocs, id: \.0) { doc, progress in
                        PDFListTileView(doc: doc, progress: progress)
                    }
                }
                Section {
                    if documentStoreVM.isFetching {
                        ProgressView()
                    } else {
                        ForEach(documentStoreVM.uploadedDocs, id: \.self) { doc in
                            NavigationLink(value: doc) {
                                PDFListTileView(doc: doc, progress: .idle)
                                    .contextMenu {
                                        Button {
                                            documentStoreVM.deleteDocument(doc: doc)
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                            }
                        }
                    }
                }
            }
            .navigationDestination(for: DigitalBoxDoc.self, destination: { doc in
                DocumentDetailView(document: doc)
            })
            .navigationTitle("Document Box")
            .toolbar {
                Button {
                    isSheetPresented = true
                } label: {
                    Label("Scan Document", systemImage: "doc.text.viewfinder")
                }
            }
            .sheet(isPresented: $isSheetPresented, onDismiss: {}) {
                DocumentCamera(
                    cancelAction: {
                        isSheetPresented = false
                    },
                    resultAction: { result in
                        Task { await documentStoreVM.scanResultAction(result: result) }
                        isSheetPresented = false
                    }
                )
            }
        }
    }
}

#Preview {
    DocumentBoxScreen()
        .environmentObject(DocumentStoreVM(userID: "preview"))
}
