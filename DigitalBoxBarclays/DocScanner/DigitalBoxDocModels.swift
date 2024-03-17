//
//  DigitalBoxDocModel.swift
//  DigitalBoxBarclays
//
//  Created by Chinmay Patil on 14/03/24.
//

import Foundation
import PDFKit

struct DigitalBoxDoc: Hashable {
    let id: String
    var title: String
    var metadata: String
    var pdf: PDFDocument
}

enum Progress: Equatable {
    case idle
    case failed
    case inProgress(Double)
}
