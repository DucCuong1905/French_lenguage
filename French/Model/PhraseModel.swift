//
//  PhraseModel.swift
//  French
//
//  Created by dovietduy on 11/12/20.
//

import Foundation
class PhraseModel {
    var english: String = ""
    var vietnam: String = ""
    var french: String = ""
    var favorite: Int = 0
    var voice: String = ""
    var id: Int = 0
    
    init(id: Int, english: String, vietnam: String, french: String, favorite: Int, voice: String) {
        self.english = english
        self.vietnam = vietnam
        self.french = french
        self.favorite = favorite
        self.voice = voice
        self.id = id
    }
}

extension PhraseModel {
    func locaziation() -> String {
        switch LanguageEntity.shared.languageDefaulCode() {
        case "en":
            return english
        case "vi":
            return vietnam
        default:
            return ""
        }
    }
}
