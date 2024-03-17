//
//  DocumentStoreVM.swift
//  DigitalBoxBarclays
//
//  Created by Chinmay Patil on 14/03/24.
//

import PDFKit
import SwiftUI
import Vision

class DocumentStoreVM: ObservableObject {
    let userID: String
    let service: DocumentStoreService
    
    @Published var scanContent = [String]()
    @Published var freshlyScannedDocs = [(DigitalBoxDoc, Progress)]()
    @Published var uploadedDocs = [DigitalBoxDoc]()
    @Published var isFetching = false
    
    init(userID: String) {
        self.userID = userID
        self.service = DocumentStoreService(userID: userID)
        Task {
            DispatchQueue.main.async {
                self.isFetching = true
            }
            let docs = await service.fetchDocuments()
            DispatchQueue.main.async {
                self.uploadedDocs = docs
                self.isFetching = false
            }
        }
    }
    
    func getMetadata(ocrOutput: String) async -> String {
        let body = ["text": ocrOutput]
        print(body)
        let finalBody = try? JSONSerialization.data(withJSONObject: body)

        var request = URLRequest(url: URL(string: "https://hack-o-hire-backend.onrender.com/extract_text")!,timeoutInterval: Double.infinity)
        
        request.httpMethod = "POST"
        
        request.httpBody = finalBody
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let data = try await URLSession.shared.data(for: request)
            return String(data: data.0, encoding: .utf8)!
        } catch {
            print("LLM Request Failed: \(error)")
        }
        return ""
    }
    
    func scanResultAction(result: DocumentCamera.CameraResult) async {
        switch result {
            case .success(let scan):
                let pdfDocument = PDFDocument()
                var ocrResults = [String]()
                for pageNumber in 0 ..< scan.pageCount {
                    ocrResults.append(ocr(image: scan.imageOfPage(at: pageNumber)))
                    let image = scan.imageOfPage(at: pageNumber)
                    guard let pdfPage = PDFPage(image: image) else { continue }
                    pdfDocument.insert(pdfPage, at: pageNumber)
                }
                var metaData = [String]()
                for ocrResult in ocrResults {
                    metaData.append(await getMetadata(ocrOutput: ocrResult))
                }
                let digitalBoxDoc = DigitalBoxDoc(
                    id: UUID().uuidString,
                    title: "Scanned Document - \(Date().description)",
                    metadata: metaData.joined(separator: "\n"),
                    pdf: pdfDocument
                )
                DispatchQueue.main.async {
                    self.freshlyScannedDocs.append((digitalBoxDoc, .inProgress(0.0)))
                }
                Task {
                    await service
                        .uploadDocument(doc: digitalBoxDoc) { progress in
                            DispatchQueue.main.async { [self] in
                                for doc in freshlyScannedDocs {
                                    if doc.0.id == digitalBoxDoc.id {
                                        freshlyScannedDocs[freshlyScannedDocs.count-1].1 = progress
                                    }
                                }
                            }
                            if progress == .idle {
                                DispatchQueue.main.async { [self] in
                                    freshlyScannedDocs.removeAll { (doc, prog) in
                                        doc.id == digitalBoxDoc.id
                                    }
                                    uploadedDocs.append(digitalBoxDoc)
                                }
                            }
                        }
                }
            case .failure(let error):
                print(error)
        }
    }
    
    
    
    func ocr(image: UIImage) -> String {
        if let cgImage = image.cgImage {
            let handler = VNImageRequestHandler(cgImage: cgImage)
            var outputText = ""
            let recognizeRequest = VNRecognizeTextRequest { (request, error) in
                guard let result = request.results as? [VNRecognizedTextObservation] else { return }
                let stringArray = result.compactMap { result in
                    result.topCandidates(1).first?.string
                }
                outputText = stringArray.joined(separator: "\n")
//                    print(outputText)
//                    self.scanContent.append(outputText)
            }
            recognizeRequest.recognitionLevel = .accurate
            do {
                try handler.perform([recognizeRequest])
            } catch {
                print(error)
            }
            return outputText
        }
        return ""
    }
    
    func deleteDocument(doc: DigitalBoxDoc) {
        Task {
            let result = await service.deleteDocument(doc: doc)
            if !result { return }
            DispatchQueue.main.async {
                self.uploadedDocs.removeAll { $0.id == doc.id }
            }
        }
    }
    
}
