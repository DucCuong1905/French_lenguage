//
//  AudioPlayer.swift
//  French
//
//  Created by dovietduy on 11/17/20.
//

import Foundation
import AVFoundation

class AudioPlayer: NSObject, AVAudioPlayerDelegate{
    
    static let shared = AudioPlayer()
    var player : AVAudioPlayer!
    
    var delegate: AudioPlayerDelegate!
    override init() {
    }
    
    func playAudio(name: String, withExtension: String, subdirectory: String) {
        if let url = Bundle.main.url(forResource: name, withExtension: withExtension, subdirectory: subdirectory){
            print(url)
            do {
                self.player = try AVAudioPlayer(contentsOf: url)
                player.delegate = self
                player.volume = 1.0
                player.play()
            } catch let error as NSError {
                print(error.localizedDescription)
            } catch {
                print("AVAudioPlayer init failed")
            }
        }
    }
    func playAudio(fileName: String) {
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        print(url.path)
        do {
            self.player = try AVAudioPlayer(contentsOf: url)
            player.delegate = self
            player.volume = 1.0
            player.play()
        } catch let error as NSError {
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
        
    }
    func playAudioSlowMotion(name: String, withExtension: String, subdirectory: String) {
        if let url = Bundle.main.url(forResource: name, withExtension: withExtension, subdirectory: subdirectory){
            print(url.absoluteString)
            do {
                self.player = try AVAudioPlayer(contentsOf: url)
                player.delegate = self
                player.volume = 1.0
                player.enableRate = true
                player.rate = 0.5
                player.play()
            } catch let error as NSError {
                print(error.localizedDescription)
            } catch {
                print("AVAudioPlayer init failed")
            }
        }
    }
    func stopAudio(){
        if player != nil {
            player.stop()
        }
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        delegate?.didFinishPlaying()
    }
    func stop(){
        if player != nil {
            player.stop()
        }
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

protocol AudioPlayerDelegate: class {
    func didFinishPlaying()
}
