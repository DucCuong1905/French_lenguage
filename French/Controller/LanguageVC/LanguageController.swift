//
//  ViewController.swift
//  French
//
//  Created by NguyenHuySONCode on 11/5/20.
//

import UIKit

class LanguageController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
     
    let scale = UIScreen.main.bounds.width / 414
    var listLanguage = LanguageEntity.shared.getData()
    var codeChoosed = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = "Language".localized()
        btnBack.layer.cornerRadius = 17 * scale
        tblView.layer.cornerRadius = 50 * scale
        tblView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: "LanguageCell", bundle: nil), forCellReuseIdentifier: "LanguageCell")
    }
    @IBAction func didSelectBtnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        let settingVC = storyboard?.instantiateViewController(withIdentifier: SettingController.className) as! SettingController
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController = settingVC
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 27 * scale
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listLanguage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell", for: indexPath) as! LanguageCell
        let item = listLanguage[indexPath.row]
        cell.lblName.text = item.name
        cell.imgLanguage.image = UIImage(named: item.image)
        cell.imgChoose.isHidden = !(Bool(item.isSelected) ?? false)
        if item.isSelected == "true" {
            codeChoosed = item.code
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68 * scale
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for item in listLanguage {
            item.isSelected = "false"
        }
        let item = listLanguage[indexPath.row]
        item.isSelected = "true"
        let _ = LanguageEntity.shared.updateLanguage(code: item.code, isSelected: "true")
        let _ = LanguageEntity.shared.updateLanguage(code: codeChoosed, isSelected: "false")
        tableView.reloadData()
    }
}

