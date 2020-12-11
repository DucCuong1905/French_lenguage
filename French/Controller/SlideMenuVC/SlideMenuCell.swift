//
//  SlideMenuCell.swift
//  French
//
//  Created by nguyenhuyson-bocote on 11/6/20.
//

import UIKit

class SlideMenuCell: UITableViewCell {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    let scale = UIScreen.main.bounds.width / 414
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblTitle.font = lblTitle.font?.withSize(14 * scale)
        imgIcon.layer.cornerRadius = 10 * scale
    }

}
