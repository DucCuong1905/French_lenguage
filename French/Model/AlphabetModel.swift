//
//  AlphabetModel.swift
//  French
//
//  Created by dovietduy on 11/13/20.
//

import Foundation
class AlphabetModel {
    var name: String = ""
    var id: String = ""
    var voice: String = ""
    var icon: String = ""
    
    init(id: String, name: String, voice: String, icon: String) {
        self.id = id
        self.name = name
        self.voice = voice
        self.icon = icon
    }
}
