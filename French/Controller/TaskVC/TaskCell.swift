//
//  TaskCell.swift
//  French
//
//  Created by dovietduy on 11/11/20.
//

import UIKit

class TaskCell: UITableViewCell {
    
    
    @IBOutlet weak var viewAnswer: UIView!
    @IBOutlet weak var lblAnswer: UILabel!
    let scale = UIScreen.main.bounds.width / 414
    override func awakeFromNib() {
        super.awakeFromNib()
        viewAnswer.layer.cornerRadius = 14 * scale
        viewAnswer.layer.borderWidth = 2 * scale
        viewAnswer.layer.borderColor = UIColor(red: 228/255, green: 228/255, blue: 241/255, alpha: 1).cgColor
        lblAnswer.font = lblAnswer.font.withSize(15 * scale)
    }
    
}
