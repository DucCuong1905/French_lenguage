//
//  GreetingsCell.swift
//  French
//
//  Created by dovietduy on 11/9/20.
//

import UIKit
import AVFoundation

class GreetingsCell: UITableViewCell, AVAudioRecorderDelegate {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblFrenchTitle: UILabel!
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var imgSeen: UIImageView!
    @IBOutlet weak var btnRecord: UIButton!
    @IBOutlet weak var btnVoice: UIButton!
    
    @IBOutlet weak var leadingSeenIcon: NSLayoutConstraint!
    @IBOutlet weak var topSeenIcon: NSLayoutConstraint!
    @IBOutlet weak var trailingViewContainer: NSLayoutConstraint!
   
    let scale = UIScreen.main.bounds.width / 414

    var fileName: String = ""
    var soundRecorder: AVAudioRecorder!
    var soundPlayer : AVAudioPlayer!
    var item: PhraseModel!
    var delegate: GreetingsCellDelegate!
    var isRecording = false
    var indexPath: IndexPath!
    var PAGE_IS = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        lblTitle.font = lblTitle.font?.withSize(16 * scale)
        lblFrenchTitle.font = lblFrenchTitle.font?.withSize(15 * scale)
        viewContainer.layer.cornerRadius = 15 * scale
        leadingSeenIcon.constant = 29 * scale
        topSeenIcon.constant = 6 * scale
        trailingViewContainer.constant = 33 * scale
        trailingViewContainer.constant = 28 * scale
        
    }
    func initData(item: PhraseModel) {
        self.item = item
        self.lblTitle.text = item.locaziation()
        self.lblFrenchTitle.text = item.french
        setBackgroundImageForBtnFavorite()
        ifFileExist()
    }
    override func prepareForReuse() {
        self.btnVoice.isHidden = true
        self.imgSeen.image = #imageLiteral(resourceName: "ic_not_seen")
    }
    func setBackgroundImageForBtnFavorite(){
        if self.item.favorite == 0 {
            btnFavorite.setBackgroundImage(UIImage(named: "ic_not_favorite"), for: .normal)
        } else {
            btnFavorite.setBackgroundImage(UIImage(named: "ic_favorite"), for: .normal)
        }
    }
    
    @IBAction func didSelectBtnFavorite(_ sender: Any) {
        item.favorite = (item.favorite == 0) ? 1 : 0
        if PAGE_IS == PAGE_VOCABULARY {
            _ = VocabEntity.shared.updateFavorite(id: item.id)
        }else {
            _ = PhraseEntity.shared.updateFavorite(id: item.id)
        }
        setBackgroundImageForBtnFavorite()
    }
    
    @IBAction func didSelectBtnMenu(_ sender: Any) {
        delegate?.didSelectBtnMenuCell(item: item)
    }
    
    @IBAction func didSelectBtnPlay(_ sender: Any) {
        switch PAGE_IS {
        case PAGE_VOCABULARY:
            TextToSpeech.shared.play(text: item.french)
        default:
            AudioPlayer.shared.delegate = self
            AudioPlayer.shared.playAudio(name: item.voice + "_m", withExtension: "mp3", subdirectory: "Audios/phrase")
        }
        
        imgSeen.image = UIImage(named: "ic_seen")
    }
    
    @IBAction func didSelectBtnSnail(_ sender: Any) {
        AudioPlayer.shared.playAudioSlowMotion(name: item.voice + "_m", withExtension: "mp3", subdirectory: "Audios/phrase")
    }
    
    @IBAction func didSelectBtnRecord(_ sender: Any) {
        delegate?.didSelectBtnRecord(item: self.item, indexPath: self.indexPath)
    }
    
    @IBAction func didSelectBtnYourVoice(_ sender: Any) {
        delegate?.didSelectBtnPlayYourVoice(item: item)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        btnVoice.isHidden = false
        btnRecord.setBackgroundImage(UIImage(named: "ic_microphone"), for: .normal)
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func ifFileExist() {
        let url = getDocumentsDirectory().appendingPathComponent(item.voice + ".m4a")
        if FileManager.default.fileExists(atPath: url.path){
            btnVoice.isHidden = false
        }
    }
}

protocol GreetingsCellDelegate {
    func didSelectBtnMenuCell(item: PhraseModel)
    func didSelectBtnRecord(item: PhraseModel, indexPath: IndexPath)
    func didSelectBtnPlayYourVoice(item: PhraseModel)
}

extension GreetingsCell: AudioPlayerDelegate {
    func didFinishPlaying() {
        print("play \(item.voice) ending")
    }
}
