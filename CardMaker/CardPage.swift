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
    private var cards: [CardInfo]
    private var isBackPage: Bool
    
    init(cards: [CardInfo], isBackPage: Bool = false) {
        var cards = cards
        let offset = 16 - cards.count
        if offset > 0 {
            cards.append(contentsOf: (0..<offset).map({_ in .placeholder}))
        } else {
            cards = Array(cards[...15])
        }
        self.isBackPage = isBackPage
        if isBackPage {
            var cardGroups = [[CardInfo]]()
            var tempArr = [CardInfo]()
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
            LazyVGrid(columns: (0...3).map { _ in GridItem(.fixed(245)) }, spacing: 5, content: {
                ForEach(cards) { cardInfo in
                    CardView(cardInfo: cardInfo, isBackPage: isBackPage)
                }
            })
        }
        .padding(20)
        .frame(width: 1024, height: 724, alignment: .center)
        .background(Color.white)
    }
}

struct CardPage_Previews: PreviewProvider {
    static var previews: some View {
        CardPage(cards: (0...1).map { _ in .placeholder}, isBackPage: false).colorScheme(.light)
    }
}
