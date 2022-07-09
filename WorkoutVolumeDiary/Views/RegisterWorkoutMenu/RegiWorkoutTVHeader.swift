//
//  RegisterWorkoutMenuHeader.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/07/06.
//

import Foundation
import UIKit

class RegiWorkoutTVHeader: UIView {
    
    var delegate: TableHeaderViewDelegate? = nil
    var section: Int = 0
    
    let targetLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.layer.backgroundColor = UIColor.gold?.cgColor
        label.layer.cornerRadius = 10
        label.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        return label
    }()
    
    let openSectionButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.backgroundColor = UIColor.white.cgColor
        button.layer.cornerRadius = 10
        button.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        button.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        button.tintColor = .gold
        return button
    }()
    
    let addMenuButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.backgroundColor = UIColor.gold?.cgColor
        button.layer.cornerRadius = 15
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    init(frame: CGRect, section: Int) {
        super.init(frame: frame)
        self.section = section
        
        setupLayout()
    }
    
    private func setupLayout() {
        layer.cornerRadius = 10
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        backgroundColor = .white
        

        addSubview(targetLabel)
        addSubview(openSectionButton)
        addSubview(addMenuButton)
        targetLabel.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, width: 150)
        openSectionButton.anchor(top: topAnchor, bottom: bottomAnchor, right: rightAnchor, width: 60)
        addMenuButton.anchor(top: topAnchor, bottom: bottomAnchor, right: openSectionButton.leftAnchor, width: 30)
        
        openSectionButton.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
    }
    
    @objc private func tappedButton() {
        print(#function, self.section)
        if let dg = self.delegate {
            dg.changeCellState(view: self, section: self.section)
        } else {
            print("error: \(#function)")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
