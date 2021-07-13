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
    
    static var placeholder: CardInfo { CardInfo(front: .init(title: "perfect", superscript: "", subtitle: "UK[ˈpɜːrfɪkt]US[ˈpɜːrfɪkt]"), back: .init(content: "adj.完美的；最好的；精通的vt.使完美；使熟练n.完成式n.（Perfect）（美、爱、英）珀费克特（人名）", example: "Your job is perfect.你的工作很完美", method: "per-全部+fect-做->全部做完->完美的"))}
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
        var method: String
    }
}

extension CardInfo: Identifiable {
    
}
