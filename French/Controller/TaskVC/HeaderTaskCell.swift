//
//  HeaderTaskCell.swift
//  French
//
//  Created by dovietduy on 11/11/20.
//

import UIKit

class HeaderTaskCell: UITableViewCell {
    @IBOutlet weak var lblChooseAnswer: UILabel!
    @IBOutlet weak var leadingChooseAnswer: NSLayoutConstraint!
    let scale = UIScreen.main.bounds.width / 414
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblChooseAnswer.font = lblChooseAnswer.font.withSize(15 * scale)
        leadingChooseAnswer.constant = 37 * scale
    }
}
