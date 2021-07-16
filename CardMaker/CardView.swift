//
//  CardView.swift
//  CardMaker
//
//  Created by caishilin on 2021/7/13.
//

import SwiftUI

struct CardView: View {
    let cardInfo: CardInfo
    let isBackPage: Bool
    
    func sentenceView() -> some View {
        let keywordRange = cardInfo.back.example.range(of: "<b>\(cardInfo.front.title)</b>")
        guard let range = keywordRange, !range.isEmpty else { return Text(cardInfo.back.example) }
        let lowerStr = cardInfo.back.example[..<(range.lowerBound)]
        var upperStr = "."
        if range.upperBound < cardInfo.back.example.endIndex {
            upperStr = String(cardInfo.back.example[(range.upperBound)...])
        }
        return Text(lowerStr) + Text(cardInfo.front.title).fontWeight(.medium) + Text(upperStr)
    }
    
    var body: some View {
        ZStack {
            if isBackPage {
                VStack(spacing: 0) {
                    Text(cardInfo.back.content)
                        .underline()
                        .lineLimit(4)
                        .foregroundColor(.black)
                        .font(.system(size: 13, weight: .regular, design: .rounded))
                    if !cardInfo.back.method.isEmpty {
                        Text(cardInfo.back.method)
                            .font(.system(size: 12, weight: .regular, design: .rounded))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                            .padding(3)
                            .background(Color.black.opacity(0.05))
                    }
                    sentenceView()
                        .font(.system(size: 12, weight: .light, design: .rounded))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                }
                .padding(10)
            } else {
                Text(cardInfo.front.title)
                    .foregroundColor(.black)
                    .font(.system(size: 30, weight: .medium, design: .rounded))
                VStack {
                    Spacer()
                    Text(cardInfo.front.subtitle)
                        .font(.system(size: 15, weight: .light, design: .rounded))
                        .foregroundColor(.black)
                        .padding(.bottom, 25)
                }
                VStack {
                    HStack {
                        Spacer()
                        Text(cardInfo.front.superscript)
                            .font(.title3)
                            .foregroundColor(.black)
                            .padding(.trailing, 10)
                    }
                    .padding(.top, 20)
                    Spacer()
                }
            }
        }
        .frame(minWidth:245, minHeight: 160)
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
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(cardInfo: .placeholder, isBackPage: true)
            .frame(width: 245, height: 300, alignment: .center)
            .background(Color.white)
    }
}
