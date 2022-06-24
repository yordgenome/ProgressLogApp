//
//  SetWorkoutView.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/06/25.
//

import UIKit

class SetWorkoutView: UIView, UITextFieldDelegate{
    
    
    let workoutNameLabel: UILabel = {
        let label = UILabel()
        label.text = "トレーニングメニュー"
        label.textColor = .endColor
        label.font = UIFont(name: "GeezaPro", size: 10)
        return label
    }()
    let targetPartLabel: UILabel = {
        let label = UILabel()
        label.text = "ターゲット部位"
        label.textColor = .endColor
        label.font = UIFont(name: "GeezaPro", size: 10)
        return label
    }()
    
    let weightlabel: UILabel = {
        let label = UILabel()
        label.text = "重量"
        label.textColor = .endColor
        label.font = UIFont(name: "GeezaPro", size: 10)
        return label
    }()
    
    let repslabel: UILabel = {
        let label = UILabel()
        label.text = "レップ数"
        label.textColor = .endColor
        label.font = UIFont(name: "GeezaPro", size: 10)
        return label
    }()
    
    let batsuLabel: UILabel = {
        let label = UILabel()
        label.text = "×"
        label.textColor = .endColor
        label.font = UIFont(name: "GeezaPro", size: 20)
        return label
    }()
    
    let workoutNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "トレーニングメニュー"
        textField.borderStyle = .roundedRect
        textField.textColor = .endColor
        textField.isEnabled = true
        return textField
    }()
    
    let targetPartTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "ターゲット部位"
        textField.borderStyle = .roundedRect
        textField.textColor = .endColor

        return textField
    }()
    
    let weightTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "重量"
        textField.borderStyle = .roundedRect
        textField.textColor = .endColor
        textField.keyboardType = .numberPad
        
        return textField
    }()
    
    let repsTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "レップ数"
        textField.borderStyle = .roundedRect
        textField.textColor = .endColor
        textField.keyboardType = .numberPad
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
        
        targetPartTextField.delegate = self
        workoutNameTextField.delegate = self
        weightTextField.delegate = self
        repsTextField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        addsubViews()
        
        targetPartLabel.anchor(top: topAnchor, left: leftAnchor, width: 80, height: 12, topPadding: 10, leftPadding: 20)
        targetPartTextField.anchor(top: targetPartLabel.bottomAnchor, left: targetPartLabel.leftAnchor, width: 120, height: 20, topPadding: 2)
        workoutNameLabel.anchor(top: targetPartLabel.topAnchor, left: targetPartTextField.rightAnchor, width: 80, height: 12, leftPadding: 20)
        workoutNameTextField.anchor(top: targetPartTextField.topAnchor, left: workoutNameLabel.leftAnchor, right: rightAnchor, height: 20, rightPadding: 20)
        weightlabel.anchor(top: targetPartTextField.bottomAnchor, left: targetPartLabel.leftAnchor, width: 80, height: 12, topPadding: 10)
        weightTextField.anchor(top: weightlabel.bottomAnchor, left: weightlabel.leftAnchor, width: 80, height: 20, topPadding: 2)
        batsuLabel.anchor(top: weightTextField.topAnchor, left: weightTextField.rightAnchor, width: 20, height: 20, leftPadding: 20)
        repslabel.anchor(top: weightlabel.topAnchor, left: batsuLabel.rightAnchor, width: 80, height: 15, leftPadding: 20)
        repsTextField.anchor(top: weightTextField.topAnchor, left: repslabel.leftAnchor, width: 80, height: 20)
        setButton.anchor(top: weightTextField.topAnchor, right: rightAnchor, width: 40, height: 20, rightPadding: 20)
        
    }
    
    private func addsubViews() {
        addSubview(workoutNameLabel)
        addSubview(targetPartLabel)
        addSubview(weightlabel)
        addSubview(repslabel)
        addSubview(batsuLabel)
        addSubview(workoutNameTextField)
        addSubview(targetPartTextField)
        addSubview(weightTextField)
        addSubview(repsTextField)
        addSubview(setButton)
    }
}
