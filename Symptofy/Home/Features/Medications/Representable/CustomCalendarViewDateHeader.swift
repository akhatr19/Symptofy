//
//  CustomCalendarViewDateHeader.swift
//  Symptofy
//
//  Created by Aarav Khatri on 7/30/23.
//

import UIKit
import JTAppleCalendar

class CustomCalendarViewDateHeader: JTACMonthReusableView {
    static let reuseID = "monthCell"

    lazy var monthTitle: CommonLabel = {
        let label = CommonLabel()
        label.isHeading2 = true
        return CommonLabel()
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .oneBackgroundColor
        addSubview(monthTitle)
        setUpAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) has not been implemented")
    }

    private func setUpAutoLayout() {
        NSLayoutConstraint.activate([
            monthTitle.leftAnchor.constraint(equalTo: leftAnchor),
            monthTitle.rightAnchor.constraint(equalTo: rightAnchor),
            monthTitle.topAnchor.constraint(equalTo: topAnchor),
            monthTitle.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
