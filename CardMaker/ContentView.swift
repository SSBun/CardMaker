//
//  ContentView.swift
//  CardMaker
//
//  Created by caishilin on 2021/7/9.
//

import SwiftUI
import PDFKit

struct ContentView: View {
    /// PDF dcoument used to preview or export
    @State var document: PDFDocument?
    
    var body: some View {
        VStack {
            Button(action: {
                generatePDF()
            }, label: {
                Text("Generate PDF")
            })
            Button(action: {
                exportPDF()
            }, label: {
                Text("Export PDF")
            })
            NewPDFView(document: $document)
        }
        .frame(minWidth: 300, minHeight: 300)
    }
    
    func exportPDF() {
        guard let document = document else { return }
        let folderChooserPoint = CGPoint(x: 0, y: 0)
        let folderChooserSize = CGSize(width: 500, height: 600)
        let folderChooserRectangle = CGRect(origin: folderChooserPoint, size: folderChooserSize)
        let folderPicker = NSOpenPanel(contentRect: folderChooserRectangle, styleMask: .utilityWindow, backing: .buffered, defer: true)
        
        folderPicker.canChooseDirectories = true
        folderPicker.canChooseFiles = false
        
        folderPicker.begin { response in
            
            if response == .OK {
                if let directory = folderPicker.urls.first {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyyMMddHHmmss"
                    document.write(to: directory.appendingPathComponent("card-maker-\(dateFormatter.string(from: Date())).pdf"))
                }
            }
        }
    }
    
    func generatePDF() {
        let pdf = PDFDocument()
        let pages = generatePage(cards: ["get", "the", "dashed", "border", "we", "simply", "need", "to", "call", "the", "strokeBorder", "modifier", "which", "lets", "us", "define"])
        for (index, page) in pages.enumerated() {
            pdf.insert(page, at: index)
        }
        document = pdf
    }
    
    func generatePage(cards: [String]) -> [PDFPage] {
        let frontPage = NSHostingView(rootView: CardPage(cards: cards))
        frontPage.setFrameSize(.init(width: 1024, height: 724))
        
        let backPage = NSHostingView(rootView: CardPage(cards: cards, isBackPage: true))
        backPage.setFrameSize(.init(width: 1024, height: 724))
        
        guard let frontImage = frontPage.snapshot(), let backImage = backPage.snapshot() else { return [] }
        guard let frontPage = PDFPage(image: frontImage), let backPage = PDFPage(image: backImage) else { return [] }
        return [frontPage, backPage]
    }
    
}

extension NSView {
    func snapshot() -> NSImage? {
        let mySize = bounds.size
        let imgSize = NSSize(width: mySize.width, height: mySize.height)
        guard let bir = bitmapImageRepForCachingDisplay(in: bounds) else { return nil }
        bir.size = imgSize
        cacheDisplay(in: bounds, to: bir)
        let image = NSImage(size: imgSize)
        image.addRepresentation(bir)
        return image
    }
}

struct NewPDFView: NSViewRepresentable {
    typealias NSViewType = PDFView
    @Binding var document: PDFDocument?
    
    func makeNSView(context: Context) -> PDFView {
        let pdfView = PDFView()
        return pdfView
    }
    
    func updateNSView(_ nsView: PDFView, context: Context) {
        nsView.document = document
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
