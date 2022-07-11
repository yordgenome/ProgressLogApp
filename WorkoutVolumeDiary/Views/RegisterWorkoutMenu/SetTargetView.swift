//
//  CreateWorkoutView.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/07/06.
//

import Foundation
import UIKit

class SetTargetView: UIView, UITextFieldDelegate{
    
    
    let targetTextLabel: UILabel = {
        let label = UILabel()
        label.text = "ターゲット部位を追加"
        label.textColor = .endColor
        label.font = UIFont(name: "GeezaPro", size: 10)
        return label
    }()
    
    let targetTextField: UITextField = {
        let textField = UITextField()
        textField.tag = 0
        textField.placeholder = "ターゲット部位"
        textField.borderStyle = .roundedRect
        textField.textColor = .endColor
        return textField
    }()
    
    let setButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("追加", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.backgroundColor = UIColor.endColor?.cgColor
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white.withAlphaComponent(0.9)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        addSubview(targetTextLabel)
        addSubview(targetTextField)
        addSubview(setButton)
        targetTextLabel.anchor(top: topAnchor, left: leftAnchor, width: 120, height: 12, topPadding: 10, leftPadding: 20)
        targetTextField.anchor(top: targetTextLabel.bottomAnchor, left: leftAnchor, width: 140, height: 20, topPadding: 2, leftPadding: 20, rightPadding: 20)
        setButton.anchor(top: topAnchor, right: rightAnchor, width: 60, height: 34, topPadding: 10, rightPadding: 20)
        
    }
    
    private func addsubViews() {

    }
}
