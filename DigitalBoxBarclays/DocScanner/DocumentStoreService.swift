//
//  DocumentStoreService.swift
//  DigitalBoxBarclays
//
//  Created by Chinmay Patil on 14/03/24.
//

import SwiftUI
import Amplify
import PDFKit

class DocumentStoreService {
    let userID: String
    
    init(userID: String) {
        self.userID = userID
    }
    
    func uploadDocument(doc: DigitalBoxDoc, updateProgress: @escaping (Progress) -> Void) async {
        let key = "DigitalBox/\(userID)/docs/\(doc.id).pdf"
        let datastoreModel = DigitalBoxDocumentData(
            id: doc.id,
            name: doc.title,
            metadata: doc.metadata,
            key: key
        )
        do {
            let result = try await Amplify.API.mutate(request: .create(datastoreModel))
            switch result {
                case .success(_):
                    print("Saved Document Data")
                case .failure(let error):
                    print("Save Note failed with error: \(error)")
                    return
            }
        } catch let error as DataStoreError {
            print("Error saving post \(error)")
        } catch {
            print("Unexpected error \(error)")
        }
        guard let data = doc.pdf.dataRepresentation() else {
            updateProgress(.failed)
            return
        }
        let uploadTask = Amplify.Storage.uploadData(
            key: key,
            data: data
        )
        Task {
            for await uploadProgress in await uploadTask.progress {
                print("Uploading: \(uploadProgress)")
                updateProgress(.inProgress(uploadProgress.fractionCompleted))
            }
        }
        do {
            let data = try await uploadTask.value
            print("Completed: \(data)")
            updateProgress(.idle)
        } catch {
            updateProgress(.failed)
            print("Failed to upload: \(error)")
            print("KEY: \(key)")
        }
    }
    
    func deleteDocument(doc: DigitalBoxDoc) async -> Bool {
        do {
            let key = "DigitalBox/\(userID)/docs/\(doc.id).pdf"
            let docData = DigitalBoxDocumentData(
                id: doc.id,
                name: doc.title,
                metadata: doc.metadata,
                key: key
            )
            let result = try await Amplify.API.mutate(request: .delete(docData))
            switch result {
            case .success(_):
                print("Deleted data completed")
                let result = try await Amplify.Storage.remove(
                    key: key
                )
                print("Remove completed with result: \(result)")
                return true
            case .failure(let error):
                print("Delete Note failed with error: \(error)")
            }
        } catch {
            print("Delete Note failed with error: \(error)")
        }
        return false
    }
    
    func fetchDocuments() async -> [DigitalBoxDoc] {
        do {
            let result = try await Amplify.API.query(request: .list(DigitalBoxDocumentData.self))
            var docModels = [DigitalBoxDocumentData]()
            switch result {
                case .success(let result):
                        docModels = result.elements
                case .failure(let error):
                    print("Fetch Document Data failed with error: \(error)")
            }
            
            var uploadedDocs = [DigitalBoxDoc]()
            try await withThrowingTaskGroup(
                of: (StorageDownloadDataTask, DigitalBoxDocumentData).self
            ) { group in
                for docModel in docModels {
                    group.addTask {
                        return (Amplify.Storage.downloadData(key: docModel.key), docModel)
                    }
                }
                for try await (downloadTask, model) in group {
                    guard let pdf = try await PDFDocument(data: downloadTask.value) else {
                        return
                    }
                    let digitalBoxDoc = DigitalBoxDoc(
                        id:  model.id,
                        title: model.name ?? "",
                        metadata: model.metadata ?? "",
                        pdf: pdf
                    )
                    print("Added doc with doc id: \(model.id)")
                    uploadedDocs.append(digitalBoxDoc)
                }
            }
            return uploadedDocs
        } catch {
            print(error)
            return []
        }
    }
}
