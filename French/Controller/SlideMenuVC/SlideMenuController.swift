//
//  SlideMenuController.swift
//  French
//
//  Created by nguyenhuyson-bocote on 11/6/20.
//

import UIKit

class SlideMenuController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var tblVIew: UITableView!
    @IBOutlet weak var lblHappyLearing: UILabel!
    
    @IBOutlet weak var topHappyLearing: NSLayoutConstraint!
    @IBOutlet weak var trailingHappyLearing: NSLayoutConstraint!
    
    let scale = UIScreen.main.bounds.width / 414
    let listMenu: [MenuModel] =
        [MenuModel(title: "Home".localized(), image: "ic_home"),
         MenuModel(title: "Vocabulary".localized(), image: "ic_vocabulary"),
         MenuModel(title: "Favorite".localized(), image: "ic_favorite"),
         MenuModel(title: "Translate".localized(), image: "ic_translate"),
         MenuModel(title: "Settings".localized(), image: "ic_settings")
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblHappyLearing.font = lblHappyLearing.font?.withSize(18 * scale)
        topHappyLearing.constant = 74 * scale
        trailingHappyLearing.constant = 22 * scale
        
        tblVIew.delegate = self
        tblVIew.dataSource = self
        tblVIew.register(UINib(nibName: "SlideMenuCell", bundle: nil), forCellReuseIdentifier: "SlideMenuCell")
    }
    @IBAction func didTapBtnCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SlideMenuCell", for: indexPath) as! SlideMenuCell
        let item = listMenu[indexPath.row]
        cell.lblTitle.text = item.title
        cell.imgIcon.image = UIImage(named: item.image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68 * scale
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            dismiss(animated: true, completion: nil)
        case 1: // vocabulary
            let greetingsVC = storyboard?.instantiateViewController(withIdentifier: GreetingsController.className) as! GreetingsController
            greetingsVC.modalPresentationStyle = .fullScreen
            greetingsVC.PAGE_IS = PAGE_VOCABULARY
            present(greetingsVC, animated: true, completion: nil)
        case 2: // favorite
            let greetingsVC = storyboard?.instantiateViewController(withIdentifier: GreetingsController.className) as! GreetingsController
            greetingsVC.modalPresentationStyle = .fullScreen
            greetingsVC.PAGE_IS = PAGE_FAVORITE
            present(greetingsVC, animated: true, completion: nil)
        case 3: // link to google translate
            if let url = URL(string: "https://translate.google.com/") {
                UIApplication.shared.open(url)
            }
        case 4: // setting
            let settingVC = storyboard?.instantiateViewController(withIdentifier: SettingController.className) as! SettingController
            settingVC.modalPresentationStyle = .fullScreen
            present(settingVC, animated: true, completion: nil)
        default:
            print("oke")
        }
    }
}
