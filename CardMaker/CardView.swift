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
    
    var body: some View {
        ZStack {
            if isBackPage {
                VStack {
                    Text(cardInfo.back.content)
                        .foregroundColor(.black)
                        .font(.system(size: 13, weight: .regular, design: .rounded))
                        .underline()
                    Text(cardInfo.back.example)
                        .font(.system(size: 12, weight: .light, design: .rounded))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                }
                .padding()
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
        .frame(minHeight: 160)
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
            .frame(width: 240, height: 300, alignment: .center)
            .background(Color.white)
    }
}
