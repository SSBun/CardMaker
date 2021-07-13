//
//  CardInfo.swift
//  CardMaker
//
//  Created by caishilin on 2021/7/12.
//

import Foundation

struct CardInfo {
    let id: String = UUID().uuidString
    var front: Front
    var back: Back
    
    static var placeholder: CardInfo { CardInfo(front: .init(title: "FRONT", superscript: "superscript", subtitle: "subtitle"), back: .init(content: "BACK", example: "example"))}
}

extension CardInfo {
    struct Front {
        var title: String
        var superscript: String
        var subtitle: String
    }
}

extension CardInfo {
    struct Back {
        var content: String
        var example: String
    }
}

extension CardInfo: Identifiable {
    
}
