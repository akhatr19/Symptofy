//
//  CustomCalendarViewDateCell.swift
//  Symptofy
//
//  Created by Aarav Khatri on 7/30/23.
//

import UIKit
import JTAppleCalendar

class CustomCalendarViewDateCell: JTACDayCell {
    static let reuseID = "dateCell"
    
    lazy var parentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var selectedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .buttonBackgroundColor
        view.layer.cornerRadius = 17.5
        return view
    }()
    
    lazy var dateLabel: CommonLabel = {
        return CommonLabel()
    }()
    
    lazy var eventView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .buttonBackgroundColor
        view.layer.cornerRadius = 3
        return view
    }()
    
    lazy var separatorView: CommonSeperatorView = {
        return CommonSeperatorView()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .oneBackgroundColor
        parentView.addSubview(selectedView)
        parentView.addSubview(dateLabel)
        parentView.addSubview(eventView)
        eventView.isHidden = true
        addSubview(parentView)
        addSubview(separatorView)
        setUpAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) has not been implemented")
    }
    
    private func setUpAutoLayout() {
        NSLayoutConstraint.activate([
            parentView.leftAnchor.constraint(equalTo: leftAnchor),
            parentView.rightAnchor.constraint(equalTo: rightAnchor),
            parentView.topAnchor.constraint(equalTo: topAnchor),
            parentView.bottomAnchor.constraint(equalTo: separatorView.topAnchor),
            
            selectedView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
            selectedView.centerYAnchor.constraint(equalTo: parentView.centerYAnchor, constant: -2.5),
            selectedView.widthAnchor.constraint(equalToConstant: 35),
            selectedView.heightAnchor.constraint(equalToConstant: 35),
            
            dateLabel.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: parentView.centerYAnchor, constant: -2.5),
            
            eventView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
            eventView.widthAnchor.constraint(equalToConstant: 6),
            eventView.heightAnchor.constraint(equalToConstant: 6),
            eventView.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: -2),
            
            separatorView.leftAnchor.constraint(equalTo: leftAnchor),
            separatorView.rightAnchor.constraint(equalTo: rightAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 1)
        ])
    }
}
