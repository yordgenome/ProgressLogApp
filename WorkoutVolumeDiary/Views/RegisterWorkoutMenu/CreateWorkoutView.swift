//
//  CreateWorkoutView.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/07/06.
//

import Foundation
import UIKit

class CreateWorkoutView: UIView, UITextFieldDelegate{
    
    
    let workoutNameLabel: UILabel = {
        let label = UILabel()
        label.text = "トレーニングメニュー"
        label.textColor = .endColor
        label.font = UIFont(name: "GeezaPro", size: 10)
        return label
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
        addSubview(workoutNameLabel)
        addSubview(setButton)
        workoutNameLabel.anchor(top: topAnchor, left: leftAnchor, width: 80, height: 12, topPadding: 10, leftPadding: 20)
        setButton.anchor(top: topAnchor, right: rightAnchor, width: 40, height: 20, rightPadding: 20)
        
    }
    
    private func addsubViews() {

    }
}
