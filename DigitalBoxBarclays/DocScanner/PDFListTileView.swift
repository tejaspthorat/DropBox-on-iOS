//
//  PDFListTileView.swift
//  DigitalBoxBarclays
//
//  Created by Chinmay Patil on 14/03/24.
//

import SwiftUI
import PDFKit

struct PDFListTileView: View {
    let doc: DigitalBoxDoc
    let progress: Progress
    func getFirstPage(pdf: PDFDocument) -> UIImage {
        guard pdf.pageCount > 0 else { return UIImage() }
        guard let firstPage = pdf.page(at: 0) else { return UIImage() }
        let pdfPageSize = firstPage.bounds(for: .mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pdfPageSize.size)
        
        let image = renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(pdfPageSize)
            ctx.cgContext.translateBy(x: 0.0, y: pdfPageSize.size.height)
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)        
            firstPage.draw(with: .mediaBox, to: ctx.cgContext)
        }
        
        return image
    }
    
    var body: some View {
        HStack {
            Image(uiImage: getFirstPage(pdf: doc.pdf))
                .resizable()
                .frame(width: 75, height: 75)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            VStack(alignment: .leading){
                Text(doc.title)
                switch progress {
                    case .idle:
                        EmptyView()
                    case .failed:
                        Image(systemName: "xmark.circle.fill")
                    case .inProgress(let double):
                        ProgressView("Uploading....", value: double)
                }
                
            }
        }
    }
}
