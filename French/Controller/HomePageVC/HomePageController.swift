//
//  HomePageController.swift
//  French
//
//  Created by NguyenHuySONCode on 11/5/20.
//
import SideMenu
import UIKit

class HomePageController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var imgAvatar: UIButton!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var lblChooseTopic: UILabel!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var viewSearchContainer: UIView!
    
    @IBOutlet weak var topViewSearch: NSLayoutConstraint!
    @IBOutlet weak var topChooseTopic: NSLayoutConstraint!
    
    let scale = UIScreen.main.bounds.width / 414
    var listCategory = CategoryEntity.shared.getData()
    var filteredData: [CategoryModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        tblView.dataSource = self
        tblView.delegate = self
        tblView.register(UINib(nibName: "HomePageCell", bundle: nil), forCellReuseIdentifier: "HomePageCell")
        tblView.register(UINib(nibName: "HeaderHPCell", bundle: nil), forCellReuseIdentifier: "HeaderHPCell")
        txtSearch.delegate = self
        txtSearch.placeholder = "Search".localized()
        filteredData = listCategory
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tblView.reloadData()
    }
    func config() {
        viewSearchContainer.layer.cornerRadius = 50 * scale
        viewSearchContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        viewSearch.layer.cornerRadius = 18 * scale
        topViewSearch.constant = 54 * scale
        topChooseTopic.constant = 40 * scale
        txtSearch.font = txtSearch.font?.withSize(16 * scale)
        lblChooseTopic.font = lblChooseTopic.font?.withSize(16 * scale)
        lblChooseTopic.text = "Choose your topic".localized()
        lblQuestion.text = "What do you want to learn today?".localized()
    }
    @IBAction func didSelectBtnSlideMenu(_ sender: Any) {
        let menu = storyboard!.instantiateViewController(withIdentifier: "RightMenu") as! SideMenuNavigationController
        menu.menuWidth = 310 * scale
        menu.navigationBar.isHidden = true
        menu.presentationStyle = .menuDissolveIn
        present(menu, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomePageCell", for: indexPath) as! HomePageCell
        let item = filteredData[indexPath.row]
        cell.lblTitle.text = item.locaziation()
        cell.lblNumber.text = String(PhraseEntity.shared.count(byCategory: item))
        cell.imgIcon.image = UIImage(named: item.image)
        
        if indexPath.row % 2 != 0 {
            cell.imgStartNow.image = UIImage(named: "ic_yellow_startnow")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160 * scale
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch filteredData[indexPath.row].id {
        case 0:
            let alphabetVC = storyboard?.instantiateViewController(withIdentifier: AlphabetController.className) as! AlphabetController
            alphabetVC.modalPresentationStyle = .fullScreen
            present(alphabetVC, animated: true, completion: nil)
        default:
            let greetingsVC = storyboard?.instantiateViewController(withIdentifier: GreetingsController.className) as! GreetingsController
            greetingsVC.modalPresentationStyle = .fullScreen
            greetingsVC.category = filteredData[indexPath.row]
            present(greetingsVC, animated: true, completion: nil)
        }
    }
}
extension HomePageController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        filteredData = []
        if textField.text == "" {
            filteredData = self.listCategory
        } else {
            for item in listCategory {
                if item.locaziation().lowercased().contains((textField.text!.lowercased())){
                    filteredData.append(item)
                }
            }
        }
        self.tblView.reloadData()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.endEditing(true)
        return true
    }
}
