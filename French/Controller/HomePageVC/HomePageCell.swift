//
//  HomePageCell.swift
//  French
//
//  Created by dovietduy on 11/9/20.
//

import UIKit

class HomePageCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblLearningSet: UILabel!
    @IBOutlet weak var imgStartNow: UIImageView!
    
    @IBOutlet weak var bottomBtnStartNow: NSLayoutConstraint!
    @IBOutlet weak var leadingTitle: NSLayoutConstraint!
    
    let scale = UIScreen.main.bounds.width / 414
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewContainer.layer.cornerRadius = 24 * scale
        bottomBtnStartNow.constant = 23 * scale
        leadingTitle.constant = 22 * scale
        lblTitle.font = lblTitle.font.withSize(20 * scale)
        lblNumber.font = lblTitle.font.withSize(10 * scale)
        lblLearningSet.font = lblTitle.font.withSize(10 * scale)
    }
}
