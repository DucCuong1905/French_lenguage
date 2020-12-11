//
//  TextToSpeech.swift
//  French
//
//  Created by dovietduy on 11/26/20.
//

import Foundation
import AVFoundation

class TextToSpeech: NSObject, AVSpeechSynthesizerDelegate {
    static let shared = TextToSpeech()
    var synth: AVSpeechSynthesizer!
    var myUtterance: AVSpeechUtterance!
    var delegate: TextToSpeechDelegate!
    override init() {
        
    }
    func play(text: String) {
        myUtterance = AVSpeechUtterance(string: text)
        myUtterance.voice = AVSpeechSynthesisVoice(language: "fr-FR")
        synth = AVSpeechSynthesizer()
        synth.delegate = self
        synth.speak(myUtterance)
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        delegate?.didFinish()
    }
    func stop(){
        if synth != nil {
            synth.stopSpeaking(at: .immediate)
        }
    }
}

protocol TextToSpeechDelegate: class {
    func didFinish()
}
