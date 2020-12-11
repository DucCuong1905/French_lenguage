//
//  SettingCell.swift
//  French
//
//  Created by NguyenHuySONCode on 11/5/20.
//

import UIKit

class SettingCell: UITableViewCell {

   
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        imgIcon.layer.cornerRadius = 10
    }

}
