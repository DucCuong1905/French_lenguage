//
//  GreetingsController.swift
//  French
//
//  Created by dovietduy on 11/9/20.
//

import UIKit
import AVFoundation
let PAGE_GREETING = 0
let PAGE_VOCABULARY = 1
let PAGE_FAVORITE = 2

class GreetingsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblGreetings: UILabel!
    @IBOutlet weak var txfSearch: UITextField!
    
    let scale = UIScreen.main.bounds.width / 414
    var category:  CategoryModel!
    var listData: [PhraseModel] = []
    var filteredData: [PhraseModel] = []
    var PAGE_IS = PAGE_GREETING
    var soundRecorder: AVAudioRecorder!
    var isRecording = false
    var indexPathRecording: IndexPath!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblGreetings.font = lblGreetings.font.withSize(16 * scale)
        txfSearch.font = txfSearch.font?.withSize(16 * scale)
        txfSearch.placeholder = "Search".localized()
        tblView.layer.cornerRadius = 50 * scale
        tblView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tblView.delegate = self
        tblView.dataSource = self
        txfSearch.delegate = self
        
        tblView.register(UINib(nibName: "GreetingsCell", bundle: nil), forCellReuseIdentifier: "GreetingsCell")
        tblView.estimatedRowHeight = 106 * scale
        tblView.rowHeight = UITableView.automaticDimension
        switch PAGE_IS {
        case PAGE_GREETING:
            listData = PhraseEntity.shared.getData(item: category)
            lblGreetings.text = category.locaziation()
        case PAGE_VOCABULARY:
            listData = VocabEntity.shared.getAllData()
            lblGreetings.text = "Vocabulary".localized()
        case PAGE_FAVORITE:
            listData = PhraseEntity.shared.getFavoriteData() + VocabEntity.shared.getFavoriteData()
            lblGreetings.text = "Favorite".localized()
        default:
            print("not found")
        }
        filteredData = listData
    }
    
    @IBAction func didSelectBtnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        AudioPlayer.shared.stop()
        TextToSpeech.shared.stop()
        
    }
    @IBAction func didSelectbtnSearch(_ sender: Any) {
        txfSearch.isHidden = false
        lblGreetings.isHidden = true
        btnSearch.isHidden = true
    }
    var index = 0
    let DID_SELECT_PLAYALL = 1
    let DID_SELECT_ROW = 2
    var flag = 0
    @IBAction func didSelectPlayAll(_ sender: Any) {
        tblView.scrollToRow(at: IndexPath(row: index, section: 0), at: .top, animated: true)
        switch PAGE_IS {
        case PAGE_VOCABULARY:
            TextToSpeech.shared.delegate = self
            TextToSpeech.shared.play(text: filteredData[index].french)
        default:
            AudioPlayer.shared.delegate = self
            AudioPlayer.shared.playAudio(name: filteredData[index].voice + "_m", withExtension: "mp3", subdirectory: "Audios/phrase")
        }
        flag = DID_SELECT_PLAYALL
        if let cell = cellForRowAt(indexPath: IndexPath(row: index, section: 0)) {
            cell.imgSeen.image = UIImage(named: "ic_seen")
        }
    }
    @IBAction func didSelectBtnMenu(_ sender: Any) {
        let alert = UIAlertController()
        let alertActionPractice = UIAlertAction(title: "Practive Now".localized(), style: .default) { (act) in
            print("action practive now")
        }
        let alertActionAudioQuiz = UIAlertAction(title: "Audio Quiz".localized(), style: .default) { (act) in
            let taskVC = self.storyboard?.instantiateViewController(withIdentifier: TaskController.className) as! TaskController
            taskVC.modalPresentationStyle = .fullScreen
            taskVC.listData = self.listData
            taskVC.isTextQuiz = false
            self.present(taskVC, animated: true, completion: nil)
        }
        let alertActionTextQuiz = UIAlertAction(title: "Text Quiz".localized(), style: .default) { (act) in
            let taskVC = self.storyboard?.instantiateViewController(withIdentifier: TaskController.className) as! TaskController
            taskVC.modalPresentationStyle = .fullScreen
            taskVC.listData = self.listData
            taskVC.isTextQuiz = true
            self.present(taskVC, animated: true, completion: nil)
        }
        let alertActionCancel = UIAlertAction(title: "Cancel".localized(), style: .cancel) { (act) in
            print("action cancel")
        }
        alert.addAction(alertActionPractice)
        alert.addAction(alertActionAudioQuiz)
        alert.addAction(alertActionTextQuiz)
        alert.addAction(alertActionCancel)
        self.present(alert, animated: true, completion: nil)
        AudioPlayer.shared.stop()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GreetingsCell", for: indexPath) as! GreetingsCell
        let item = filteredData[indexPath.row]
        cell.delegate = self
        cell.initData(item: item)
        cell.indexPath = indexPath
        cell.PAGE_IS = PAGE_IS
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30 * scale
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }
    func loadData(){
        tblView.reloadData()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch PAGE_IS {
        case PAGE_VOCABULARY:
            TextToSpeech.shared.play(text: filteredData[indexPath.row].french)
        default:
            AudioPlayer.shared.delegate = self
            AudioPlayer.shared.playAudio(name: filteredData[indexPath.row].voice + "_m", withExtension: "mp3", subdirectory: "Audios/phrase")
        }
        
        flag = DID_SELECT_ROW
        guard let cell = cellForRowAt(indexPath: indexPath) else {
            return
        }
        cell.imgSeen.image = UIImage(named: "ic_seen")
    }

    func cellForRowAt(indexPath: IndexPath) -> GreetingsCell? {
        guard let cell = tblView.cellForRow(at: indexPath) as? GreetingsCell else {
            return nil
        }
        return cell
    }
}

extension GreetingsController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        filteredData = []
        if textField.text == "" {
            filteredData = self.listData
        } else {
            for item in listData {
                if item.locaziation().lowercased().contains((textField.text!.lowercased())){
                    filteredData.append(item)
                }
            }
        }
        self.tblView.reloadData()
        AudioPlayer.shared.stop()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.endEditing(true)
        return true
    }
}

extension GreetingsController: GreetingsCellDelegate {
    func didSelectBtnRecord(item: PhraseModel, indexPath: IndexPath) {
        setupRecorder(item: item)
        if isRecording {
            soundRecorder.stop()
            soundRecorder = nil
            guard let cell = cellForRowAt(indexPath: self.indexPathRecording) else {
                return
            }
            cell.btnRecord.setBackgroundImage(UIImage(named: "ic_microphone"), for: .normal)
            cell.btnVoice.isHidden = false
        } else {
            soundRecorder.record()
            guard let cell = cellForRowAt(indexPath: indexPath) else {
                return
            }
            cell.btnRecord.setBackgroundImage(UIImage(named: "ic_recording"), for: .normal)
            self.indexPathRecording = indexPath
        }
        isRecording = !isRecording
    }
    
    func didSelectBtnPlayYourVoice(item: PhraseModel) {
        AudioPlayer.shared.delegate = self
        AudioPlayer.shared.playAudio(fileName: item.voice + ".m4a")
    }
    
    func didSelectBtnMenuCell(item: PhraseModel) {
        let alert = UIAlertController()
        let alertActionMore = UIAlertAction(title: "More Actions".localized(), style: .default) { (act) in
            print("More Actions")
        }
        let alertActionCopy = UIAlertAction(title: "Copy".localized(), style: .default) { (act) in
            let pasteboard = UIPasteboard.general
            pasteboard.string = item.locaziation()
            self.view.showToast(message: "Copied to clipboard".localized())
        }
        let alertActionShare = UIAlertAction(title: "Share".localized(), style: .default) { (act) in
            let items = ["\(item.locaziation())\n\n" + "Content".localized() + "\n\n\(item.french)"]
            let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
            self.present(ac, animated: true)
        }
        let alertActionCancel = UIAlertAction(title: "Cancel".localized(), style: .cancel) { (act) in
        }
        alert.addAction(alertActionMore)
        alert.addAction(alertActionCopy)
        alert.addAction(alertActionShare)
        alert.addAction(alertActionCancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func setupRecorder(item: PhraseModel) {
        if soundRecorder == nil{
            let audioFilename = getDocumentsDirectory().appendingPathComponent(item.voice + ".m4a")
            let recordSetting = [ AVFormatIDKey : kAudioFormatAppleLossless,
                                  AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
                                  AVEncoderBitRateKey : 320000,
                                  AVNumberOfChannelsKey : 2,
                                  AVSampleRateKey : 44100.2] as [String : Any]

            do {
                soundRecorder = try AVAudioRecorder(url: audioFilename, settings: recordSetting )
                soundRecorder.delegate = self
                soundRecorder.prepareToRecord()
            } catch {
                print(error)
            }
        } else {}
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

extension GreetingsController: AudioPlayerDelegate{
    func didFinishPlaying() {
        switch flag {
        case DID_SELECT_PLAYALL:
            guard let cell = cellForRowAt(indexPath: IndexPath(row: index, section: 0)) else {
                return
            }
            cell.imgSeen.image = UIImage(named: "ic_not_seen")
            index += 1
            if index < filteredData.count{
                tblView.scrollToRow(at: IndexPath(row: index, section: 0), at: .top, animated: true)
                AudioPlayer.shared.playAudio(name: filteredData[index].voice + "_m", withExtension: "mp3", subdirectory: "Audios/phrase")
                guard let cell = cellForRowAt(indexPath: IndexPath(row: index, section: 0)) else {
                    return
                }
                cell.imgSeen.image = UIImage(named: "ic_seen")
            } else {
                index = 0
            }
            print("\(filteredData[index].voice) ending....")
        default:
            print("\(filteredData[index].voice) ending....")
        }

    }
}

extension GreetingsController: AVAudioRecorderDelegate{
    
}
extension GreetingsController: TextToSpeechDelegate {
    func didFinish() {
        switch flag {
        case DID_SELECT_PLAYALL:
            if let cell = cellForRowAt(indexPath: IndexPath(row: index, section: 0)){
                cell.imgSeen.image = UIImage(named: "ic_not_seen")
            }
            index += 1
            if index < filteredData.count{
                tblView.scrollToRow(at: IndexPath(row: index, section: 0), at: .top, animated: true)
                TextToSpeech.shared.play(text: filteredData[index].voice)
                if let cell = cellForRowAt(indexPath: IndexPath(row: index, section: 0)){
                    cell.imgSeen.image = UIImage(named: "ic_seen")
                }
            } else {
                index = 0
            }
            print("\(filteredData[index].french) ending....")
        default:
            print("\(filteredData[index].french) ending....")
        }
    }
}
