//
//  LanguageModel.swift
//  French
//
//  Created by dovietduy on 11/12/20.
//

import Foundation
class LanguageModel {
    var name: String = ""
    var code: String = ""
    var image: String = ""
    var isSelected: String = ""
    
    init(name: String, code: String, image: String, isSelected: String) {
        self.name = name
        self.code = code
        self.image = image
        self.isSelected = isSelected
    }
}
