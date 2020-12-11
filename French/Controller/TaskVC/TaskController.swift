//
//  TaskController.swift
//  French
//
//  Created by dovietduy on 11/11/20.
//

import UIKit

class TaskController: UIViewController{
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblTextQuiz: UILabel!
    @IBOutlet weak var imgTextQuiz: UIImageView!
    @IBOutlet weak var imgAudioQuiz: UIImageView!
    @IBOutlet weak var btnPlayAudio: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var bottomBtnPlay: NSLayoutConstraint!
    var isTextQuiz = true
    let scale = UIScreen.main.bounds.width / 414
    var listData: [PhraseModel] = []
    var list4Choices: [PhraseModel] = []
    var correctAnswer: PhraseModel!
    var idNext = 0
    var idCorrectAnwser = 0
    var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.layer.cornerRadius = 50 * scale
        tblView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomBtnPlay.constant = -30 * scale
        tblView.delegate = self
        tblView.dataSource = self
        tblView.isScrollEnabled = false
        tblView.register(UINib(nibName: "HeaderTaskCell", bundle: nil), forCellReuseIdentifier: "HeaderTaskCell")
        tblView.register(UINib(nibName: "FooterTaskCell", bundle: nil), forCellReuseIdentifier: "FooterTaskCell")
        tblView.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "TaskCell")
        progressBar.progress = 0.0
        checkTextOrAudioQuiz()
        setupQuestion()
    }
    func checkTextOrAudioQuiz(){
        if isTextQuiz {
            lblTextQuiz.isHidden = false
            imgTextQuiz.isHidden = false
        } else {
            imgAudioQuiz.isHidden = false
            btnPlayAudio.isHidden = false
        }
    }
    func setupQuestion(){
        listData = listData.shuffled()
        correctAnswer = listData[idNext]
        let removeItem = listData.remove(at: idNext)
        list4Choices = []
        for item in listData[0...3]{
            list4Choices.append(item)
        }
        idCorrectAnwser = (0...3).randomElement()!
        list4Choices.insert(removeItem, at: idCorrectAnwser)
        listData.insert(removeItem, at: idNext)
        
        lblTextQuiz.text = list4Choices[idCorrectAnwser].locaziation()
    }
    @IBAction func didSelectBtnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func didSelectBtnNext(_ sender: Any) {
        idNext += 1
        if idNext < listData.count {
            setupQuestion()
            tblView.reloadData()
        } else {
            let alert = UIAlertController(title: "Congratulations".localized(), message: "Thank for participating the game".localized(), preferredStyle: UIAlertController.Style.alert)
            let alertActionOK = UIAlertAction(title: "OK".localized(), style: .default) { (act) in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(alertActionOK)
            self.present(alert, animated: true, completion: nil)
        }
        progressBar.progress += 1 / Float(listData.count)
        progressBar.setProgress(progressBar.progress, animated: true)
    }
    @IBAction func didSelectBtnPlayAudio(_ sender: Any) {
        AudioPlayer.shared.delegate = self
        AudioPlayer.shared.playAudio(name: list4Choices[idCorrectAnwser].voice + "_m", withExtension: "mp3", subdirectory: "Audios/phrase")
    }
    
}

extension TaskController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        cell.lblAnswer.text = list4Choices[indexPath.row].vietnam
        cell.viewAnswer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.lblAnswer.textColor = #colorLiteral(red: 0.2666666667, green: 0.2588235294, blue: 0.3843137255, alpha: 1)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65 * scale
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderTaskCell") as! HeaderTaskCell
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75 * scale
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TaskCell
        let cellCorrect = tableView.cellForRow(at: IndexPath(row: idCorrectAnwser, section: 0)) as! TaskCell
        if indexPath.row == idCorrectAnwser {
            cell.viewAnswer.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.5529411765, blue: 0.2078431373, alpha: 1)
            cell.lblAnswer.textColor = .white
            score += 1
        } else {
            cell.viewAnswer.backgroundColor = #colorLiteral(red: 0.8823529412, green: 0.1490196078, blue: 0.2117647059, alpha: 1)
            cellCorrect.viewAnswer.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.5529411765, blue: 0.2078431373, alpha: 1)
            cell.lblAnswer.textColor = .white
            cellCorrect.lblAnswer.textColor = .white
        }
        
    }
}
extension TaskController: AudioPlayerDelegate {
    func didFinishPlaying() {
        print("audio play finish")
    }
}
