//
//  ClassName.swift
//  French
//
//  Created by dovietduy on 11/12/20.
//

import Foundation
import AVKit

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    class var className: String {
        return String(describing: self)
    }
}

extension UIView {
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: 10, y: self.frame.size.height-100, width: self.frame.size.width - 20, height: 35))
        toastLabel.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
extension String {
    func localized() -> String {
        let lang = LanguageEntity.shared.languageDefaulCode()
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}
