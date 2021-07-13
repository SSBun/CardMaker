//
//  YouDaoTranslator.swift
//  CardMaker
//
//  Created by caishilin on 2021/7/13.
//

import Foundation
import Combine

struct YouDaoTranslator {
    static func getInfo(_ vocabulary: String, _ callback: @escaping ((RecommendSentence, TranslationResult)?) -> Void) {
        guard let trs = translate(vocabulary), let sct = getRecommendSentences(vocabulary) else { callback(nil); return }
        let token = SubscriptionToken()
        trs.combineLatest(sct).sink { _ in
            token.unseal()
        } receiveValue: {  result in
            callback(result)
        }.seal(in: token)
    }
    
    static func translate(_ vocabulary: String) -> AnyPublisher<YouDaoTranslator.RecommendSentence, DataProvider.HTTPError>? {
        guard let url = URL(string: "https://dict.youdao.com/wordbook/itemInfo/batch?appVersion=9.0.30&client=iphonepro&data=%5B%7B%22itemId%22%3A%22c2c4aea37943ee7876ec4408e877b650%22%2C%22itemName%22%3A%22\(vocabulary)%22%2C%22lanFrom%22%3A%22en%22%2C%22lanTo%22%3A%22zh-CHS%22%2C%22bookType%22%3A0%2C%22recommendBookId%22%3A%22%22%7D%5D&idfa=&imei=b30d08308f07cf2c35e07f70278a5779&keyfrom=mdict.9.0.30.iphonepro&mid=14.6&model=iPhone13%2C2&network=wifi&product=mdict&screen=390x844&vendor=AppStore") else { return nil }
        return DataProvider().request(url, body: nil)
    }
    
    static func getRecommendSentences(_ vocabulary: String) -> AnyPublisher<YouDaoTranslator.TranslationResult, DataProvider.HTTPError>? {
        let timestamp = Int(Date().timeIntervalSince1970 * 1000)
        guard let url = URL(string: "https://dict.youdao.com/jsonapi_s?client=mobile&le=eng&q=\(vocabulary)&dicts=%7B%22count%22%3A41%2C%22dicts%22%3A%5B%5B%22ec%22%5D%2C%5B%22ce%22%5D%2C%5B%22ud%22%5D%2C%5B%22ec21%22%5D%2C%5B%22ce_new%22%5D%2C%5B%22ee%22%5D%2C%5B%22newhh%22%5D%2C%5B%22collins%22%5D%2C%5B%22special%22%5D%2C%5B%22phrs%22%5D%2C%5B%22syno%22%5D%2C%5B%22rel_word%22%5D%2C%5B%22pic_dict%22%5D%2C%5B%22fanyi%22%5D%2C%5B%22web_search%22%5D%2C%5B%22typos%22%5D%2C%5B%22web_trans%22%5D%2C%5B%22blng_sents_part%22%5D%2C%5B%22media_sents_part%22%5D%2C%5B%22auth_sents_part%22%5D%2C%5B%22etym%22%5D%2C%5B%22baike%22%5D%2C%5B%22wikipedia_digest%22%5D%2C%5B%22exam_dict%22%5D%2C%5B%22multle%22%5D%2C%5B%22ugc%22%5D%2C%5B%22longman%22%5D%2C%5B%22webster%22%5D%2C%5B%22oxford%22%5D%2C%5B%22oxfordAdvance%22%5D%2C%5B%22ywAncientWord%22%5D%2C%5B%22ywBasic%22%5D%2C%5B%22ywIdiom%22%5D%2C%5B%22ywRelatedWords%22%5D%2C%5B%22ywSynAndAnt%22%5D%2C%5B%22ywWordNet%22%5D%2C%5B%22newcenturyjc%22%5D%2C%5B%22newcenturyfc%22%5D%2C%5B%22video_sents%22%5D%2C%5B%22word_video%22%5D%2C%5B%22individual%22%5D%5D%7D&client=mobile&keyfrom=mdict.9.0.30.iphonepro&imei=b30d08308f07cf2c35e07f70278a5779&model=iPhone&deviceid=b30d08308f07cf2c35e07f70278a5779&mid=14.6&username=urs-phoneyd.451f3edbdfa442749@163.com&vendor=AppStore&userid=urs-phoneyd.451f3edbdfa442749@163.com&device=iPhone13,2&idfa=00000000-0000-0000-0000-000000000000&guestNonce=3483681322702397048&abtest=3&network=wifi&guestSig=838AB8E8F424E349F80DF2148362CBA1&previewEnvTest=0&jsonversion=4&source=main&t=\(timestamp)&sign=130c3d9b5372de3b2348614ebb1774a6&userLabel=WORKER,PRACTICAL") else { return nil }
        return DataProvider().request(url, method: .post, body: nil)
    }

}
// MARK: - RecommondSentence
/// Search example sentences and helping remember methods of the vocabulary
extension YouDaoTranslator {
    struct RecommendSentence: Codable {
        let code: Int
        let msg: String
        let data: [String: Info]
    }
}

extension YouDaoTranslator.RecommendSentence {
    struct Info: Codable {
        var ext: String?
        var sentences: [Sentence]
        var recite: Recite?
    }
    
    struct Sentence: Codable {
        var sent: String
        var trans: String
        var tag: String
        var source: String
    }
    
    struct Recite: Codable {
        var prefix: String?
        var suffix: String?
        var root: String?
        var method: [String]
    }
}

// MARK: - TranslationResult
/// Translating the vocabulary
extension YouDaoTranslator {
    struct TranslationResult: Codable {
        var ec: BaseInfo
    }
}

extension YouDaoTranslator.TranslationResult {
    struct BaseInfo: Codable {
        var word: Word
    }
    
    struct Word: Codable {
        var usphone: String
        var ukphone: String
        var trs: [Translation]
    }
    
    struct Translation: Codable {
        var pos: String
        var tran: String
    }
}
