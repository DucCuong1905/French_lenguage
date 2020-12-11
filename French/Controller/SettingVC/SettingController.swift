//
//  SettingController.swift
//  French
//
//  Created by NguyenHuySONCode on 11/5/20.
//

import UIKit

class SettingController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    
    let scale = UIScreen.main.bounds.width / 414
    let listMenu: [MenuModel] =
        [MenuModel(title: "Language".localized(), image: "ic_language"),
         MenuModel(title: "Download vocabulary".localized(), image: "ic_download_vocabulary"),
         MenuModel(title: "Delete all recordings".localized(), image: "ic_delete_all_recordings"),
         MenuModel(title: "Send feedback".localized(), image: "ic_send_feedback"),
         MenuModel(title: "Share app".localized(), image: "ic_share_app"),
         MenuModel(title: "Rate_this_app".localized(), image: "ic_rate_this_app"),
         MenuModel(title: "About app".localized(), image: "ic_about_app")
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = "Settings".localized()
        btnBack.layer.cornerRadius = 17 * scale
        tblView.layer.cornerRadius = 50 * scale
        tblView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tblView.dataSource = self
        tblView.delegate = self
        tblView.register(UINib(nibName: "SettingCell", bundle: nil), forCellReuseIdentifier: "SettingCell")
    }
    @IBAction func disSelectBtnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        let homePageVC = storyboard?.instantiateViewController(withIdentifier: HomePageController.className) as! HomePageController
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController = homePageVC
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
        let item = listMenu[indexPath.row]
        cell.lblName.text = item.title
        cell.imgIcon.image = UIImage(named: item.image)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68 * scale
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 27 * scale
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: // language
            let languageVC = storyboard?.instantiateViewController(withIdentifier: LanguageController.className) as! LanguageController
            languageVC.modalPresentationStyle = .fullScreen
            present(languageVC, animated: true, completion: nil)
        case 1: // download vocabulary
            downloadAudioFile(from: "Audios/alphabet")
            downloadAudioFile(from: "Audios/phrase")
        case 2: // delete all recordings
            view.showToast(message: deleteAllRecordings())
        default:
            print("i dont know")
        }
    }
    func deleteAllRecordings() -> String {
        let documentsUrl = getDocumentsDirectory()
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            if fileURLs.count == 0 {
                return "empty"
            }
            for fileURL in fileURLs {
                if fileURL.pathExtension == "m4a" {
                    try FileManager.default.removeItem(at: fileURL)
                }
            }
            return "delete successful"
        } catch  {
            return "delete fail"
            
        }
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    var numberOK = 0
    var filesName: [String] = []
    func downloadAudioFile(from folderName: String){
        do {
            let folderURL = Bundle.main.resourceURL!.appendingPathComponent(folderName)
            let fileList = try FileManager.default.contentsOfDirectory(atPath: folderURL.path)
            filesName = fileList
            numberOK = 0
            downloadFile(in: folderURL, withName: filesName[0])
        } catch let err {
            print(err.localizedDescription)
        }
    }
    
    func downloadFile(in folder: URL, withName: String){
        let audioUrl = folder.appendingPathComponent(withName)
        let destinationUrl = getDocumentsDirectory().appendingPathComponent(audioUrl.lastPathComponent)
        do{
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                try FileManager.default.removeItem(at: destinationUrl)
            }
        } catch{
            print(error)
        }
        URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) -> Void in
            guard let location = location, error == nil else {
                DispatchQueue.main.async { print(error as Any)}
                return
            }
            do {
                try FileManager.default.moveItem(at: location, to: destinationUrl)
                DispatchQueue.main.async {
                    self.numberOK += 1
                    self.message("Downloaded".localized() + " \(self.numberOK) " + "files".localized())
                    if self.numberOK < self.filesName.count{
                        self.downloadFile(in: folder, withName: self.filesName[self.numberOK])
                    } else {
                        self.numberOK = 0
                    }
                }
            } catch let error as NSError {
                DispatchQueue.main.async { print(error)}
            }
        }).resume()
    }
    func message(_ text : String){
        self.view.showToast(message: text)
    }
}
