//
//  CommonUIKitComponents.swift
//  Symptofy
//
//  Created by Aarav Khatri on 8/12/23.
//

import UIKit

@IBDesignable class CommonLabel: UILabel {
    
    @IBInspectable var isHeading1 = false
    @IBInspectable var isHeading2 = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textAlignment = .center
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if isHeading1 {
            self.textColor = .informationTextColor
            self.font = UIFont.systemFont(ofSize: 14)
        } else if isHeading2 {
            self.font = UIFont.systemFont(ofSize: 17)
            self.textColor = .normalTextColor
        } else {
            self.font = UIFont.systemFont(ofSize: 17)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@IBDesignable class CommonSeperatorView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .lightGray
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
