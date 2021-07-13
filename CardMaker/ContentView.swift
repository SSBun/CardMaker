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
    
    @State var cards: [CardInfo] = []
    
    var body: some View {
        HStack {
            ScrollView([.vertical], showsIndicators: false) {
                ForEach(Array(cards.enumerated()), id: \.1.id) { item in
                    HStack {
                        TextField("TITLE", text: $cards[item.0].front.title)
                            .textFieldStyle(PlainTextFieldStyle())
                            .font(.title2)
                            .padding(.all, 5)
                            .background(Color.black.opacity(0.1))
                        TextField("SUPERSCRIPT", text: $cards[item.0].front.superscript)
                            .textFieldStyle(PlainTextFieldStyle())
                            .font(.title2)
                            .padding(.all, 5)
                            .background(Color.black.opacity(0.1))
                        TextField("SUBTITLE", text: $cards[item.0].front.subtitle)
                            .textFieldStyle(PlainTextFieldStyle())
                            .font(.title2)
                            .padding(.all, 5)
                            .background(Color.black.opacity(0.1))
                        TextField("CONTENT", text: $cards[item.0].back.content)
                            .textFieldStyle(PlainTextFieldStyle())
                            .font(.title2)
                            .padding(.all, 5)
                            .background(Color.black.opacity(0.2))
                        TextField("EXAMPLES", text: $cards[item.0].back.example)
                            .textFieldStyle(PlainTextFieldStyle())
                            .font(.title2)
                            .padding(.all, 5)
                            .background(Color.black.opacity(0.2))
                    }
                    .frame(minHeight: 44)
                }
                Button(action: {
                    cards.append(.init(front: .init(title: "", superscript: "", subtitle: ""), back: .init(content: "", example: "")))
                }, label: {
                    Text("Add new card")
                        .frame(width: 100, height: 44)
                        .background(Color.blue)
                        .cornerRadius(10)
                })
                .buttonStyle(PlainButtonStyle())
                .padding()
                Spacer()
            }
            .frame(minWidth: 200, maxWidth: .infinity, maxHeight: .infinity)
            VStack {
                Spacer()
                Button(action: {
                    generatePDF()
                }, label: {
                    Text("Generate PDF")
                        .frame(width: 100, height: 44)
                        .background(Color.red)
                        .cornerRadius(10)
                })
                .buttonStyle(PlainButtonStyle())
                .padding()
                Button(action: {
                    for card in cards {
                        print(card)
                    }
                }, label: {
                    Text("LOG")
                        .frame(width: 100, height: 44)
                        .background(Color.gray)
                        .cornerRadius(10)
                })
                .buttonStyle(PlainButtonStyle())
                .padding()
                Spacer()
            }
            .background(Color.gray.opacity(0.5))
        }
        .frame(minWidth: 300, minHeight: 300)
        .sheet(item: $document) { item in
            VStack {
                NewPDFView(document: $document)
                HStack(spacing: 200) {
                    Button(action: {
                        document = nil
                    }, label: {
                        Text("Close")
                            .frame(width: 100, height: 44)
                            .background(Color.red)
                            .cornerRadius(10)
                    })
                    Button(action: {
                        exportPDF()
                    }, label: {
                        Text("Export PDF")
                            .frame(width: 100, height: 44)
                            .background(Color.blue)
                            .cornerRadius(10)
                    })
                }
                .buttonStyle(PlainButtonStyle())
                .frame(minHeight: 100)
            }
            .frame(minWidth: 1200, minHeight: 1000)
        }
        .frame(minWidth: 500, maxWidth: .infinity, minHeight: 800, maxHeight: .infinity)
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
        var cardGroups: [[CardInfo]] = []
        var cardGroup = [CardInfo]()
        for (index, card) in cards.enumerated() {
            if index != 0, index % 16 == 0 {
                cardGroups.append(cardGroup)
                cardGroup.removeAll()
            }
            cardGroup.append(card)
        }
        cardGroups.append(cardGroup)
        
        let pages = cardGroups.map({ generatePage(cards: $0)}).flatMap({ $0 })
        for (index, page) in pages.enumerated() {
            pdf.insert(page, at: index)
        }
        document = pdf
    }
    
    func generatePage(cards: [CardInfo]) -> [PDFPage] {
        let frontPage = NSHostingView(rootView: CardPage(cards: cards))
        frontPage.setFrameSize(.init(width: 1024, height: 724))
        
        let backPage = NSHostingView(rootView: CardPage(cards: cards, isBackPage: true))
        backPage.setFrameSize(.init(width: 1024, height: 724))
        
        guard let frontImage = frontPage.snapshot(), let backImage = backPage.snapshot() else { return [] }
        guard let frontPage = PDFPage(image: frontImage), let backPage = PDFPage(image: backImage) else { return [] }
        return [frontPage, backPage]
    }
    
}

extension PDFDocument: Identifiable {
    public var id: String { string ?? "pdf" }
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
