//
//  CategoryModel.swift
//  French
//
//  Created by dovietduy on 11/16/20.
//

import Foundation
class CategoryModel {
    var id: Int = 0
    var english: String = ""
    var vietnamese: String = ""
    var image: String = ""
    
    init(id: Int, english: String, vietnamese: String, image: String) {
        self.id = id
        self.english = english
        self.vietnamese = vietnamese
        self.image = image
    }
}

extension CategoryModel {
    func locaziation() -> String {
        switch LanguageEntity.shared.languageDefaulCode() {
        case "en":
            return english
        case "vi":
            return vietnamese
        default:
            return ""
        }
    }
}
