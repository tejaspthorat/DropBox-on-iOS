//
//  DocumentDetailView.swift
//  DigitalBoxBarclays
//
//  Created by Chinmay Patil on 17/03/24.
//

import SwiftUI
import PDFKit

struct PDFKitView: UIViewRepresentable {
    
    let doc: PDFDocument
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = doc
        pdfView.autoScales = true
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFView, context: Context) {
        // Update pdf if needed
    }
}


struct DocumentDetailView: View {
    let document: DigitalBoxDoc
    
    func convertToDictionary(text: String) -> [String: String] {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: String] ?? [:]
            } catch {
                print(error.localizedDescription)
            }
        }
        return [:]
    }
    
    var body: some View {
        List {
            Section {
                PDFKitView(doc: document.pdf)
                    .frame(height: 300)
            }
            Section {
                HStack(alignment: .top) {
                    Text("Document Name")
                    Spacer()
                    Text(document.title)
                        .multilineTextAlignment(.trailing)
                }
                MetaDataListView(metaData: convertToDictionary(text: document.metadata))
            }
        }
    }
}

struct MetaDataListView: View {
    let metaData: [String : String]
    var body: some View {
        ForEach(metaData.keys.sorted(), id: \.self) { key in
            HStack(alignment: .top) {
                Text(key.capitalized)
                Spacer()
                Text(metaData[key] ?? "")
                    .multilineTextAlignment(.trailing)
            }
        }
    }
}
