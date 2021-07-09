//
//  CardPage.swift
//  CardMaker
//
//  Created by caishilin on 2021/7/9.
//

import SwiftUI

extension String: Identifiable {
    public var id: String { self }
}

struct CardPage: View {
    private var cards: [String]
    private var isBackPage: Bool
    
    init(cards: [String], isBackPage: Bool = false) {
        var cards = Array(cards[0...15])
        let offset = 16 - cards.count
        if offset > 0 {
            cards.append(contentsOf: (0..<offset).map({_ in ""}))
        }
        self.isBackPage = isBackPage
        if isBackPage {
            var cardGroups = [[String]]()
            var tempArr = [String]()
            var notClean = false
            for (index, card) in cards.enumerated() {
                if index % 4 == 0 {
                    cardGroups.append(tempArr)
                    tempArr.removeAll()
                    notClean = false
                }
                tempArr.append(card)
                notClean = true
            }
            if notClean {
                cardGroups.append(tempArr)
            }
            self.cards = cardGroups.reversed().flatMap { $0 }
        } else {
            self.cards = cards
        }
    }
    
    var body: some View {
        VStack {
            LazyVGrid(columns: (0...3).map { _ in GridItem(.fixed(240)) }, spacing: 10, content: {
                ForEach(0..<(cards.count)) { index in
                    VStack(spacing: 10) {
                        Text("\(cards[index])")
                            .foregroundColor(.black)
                            .font(.largeTitle)
                        Text("good")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, minHeight: 160)
                    .overlay(
                        Rectangle()
                            .strokeBorder(
                                style: StrokeStyle(
                                    lineWidth: 1,
                                    dash: [3]
                                )
                            )
                            .foregroundColor(.gray.opacity(0.4))
                    )
                }
            })
        }
        .padding(20)
        .background(Color.white)
    }
}

struct CardPage_Previews: PreviewProvider {
    static var previews: some View {
        CardPage(cards: ["get", "the", "dashed", "border", "we", "simply", "need", "to", "call", "the", "strokeBorder", "modifier", "which", "dashed", "border", "we"], isBackPage: true).colorScheme(.light)
    }
}
