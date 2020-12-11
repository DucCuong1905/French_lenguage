//
//  AlphabetController.swift
//  French
//
//  Created by dovietduy on 11/8/20.
//

import UIKit

class AlphabetController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, AudioPlayerDelegate {

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblAlphabet: UILabel!
    var listAlphabet = AlphabetEntity.shared.getData()
    
    let scale = UIScreen.main.bounds.width / 414
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblAlphabet.font = lblAlphabet.font?.withSize(16 * scale)
        lblAlphabet.text = "Alphabet".localized()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "AlphabetCell", bundle: nil), forCellWithReuseIdentifier: "AlphabetCell")
        
    }
    @IBAction func didSelectBtnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        AudioPlayer.shared.stop()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listAlphabet.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlphabetCell", for: indexPath) as! AlphabetCell
        let item = listAlphabet[indexPath.row]
        cell.imgIcon.image = UIImage(named: item.icon)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collWidth = collectionView.bounds.width - 20
        
        let deviceType = UIDevice.current.userInterfaceIdiom
        if deviceType == .pad{
            return CGSize(width: Int(collWidth/6), height: Int(collWidth/6))
        }else {
            return CGSize(width: Int(collWidth/3), height: Int(collWidth/3))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // play sound
        let item = listAlphabet[indexPath.row]
        AudioPlayer.shared.playAudio(name: item.voice, withExtension: "mp3", subdirectory: "Audios/alphabet")
    }
    func didFinishPlaying() {
    }

}
