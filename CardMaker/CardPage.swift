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
            LazyVGrid(columns: (0...3).map { _ in GridItem(.fixed(240)) }, spacing: 10, content: {
                ForEach(0..<(cards.count)) { index in
                    ZStack {
                        if isBackPage {
                            VStack {
                                Text(cards[index].back.content)
                                    .foregroundColor(.black)
                                    .font(.title)
                                Text(cards[index].back.example)
                                    .font(.title2)
                                    .foregroundColor(.gray.opacity(0.7))
                            }
                        } else {
                            Text(cards[index].front.title)
                                .foregroundColor(.black)
                                .font(.largeTitle)
                            VStack {
                                Spacer()
                                Text(cards[index].front.subtitle)
                                    .font(.title2)
                                    .foregroundColor(.gray)
                                    .padding(.bottom, 30)
                            }
                            VStack {
                                HStack {
                                    Spacer()
                                    Text(cards[index].front.superscript)
                                        .font(.title3)
                                        .foregroundColor(.black)
                                        .padding(.trailing, 10)
                                }
                                .padding(.top, 20)
                                Spacer()
                            }
                        }
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
        CardPage(cards: (0...15).map { _ in .placeholder}, isBackPage: true).colorScheme(.light)
    }
}
