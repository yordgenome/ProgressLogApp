//
//  SignUpButton.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/06/19.
//

import Foundation
import UIKit

class SignUpButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.setTitle("登録", for: .normal)
        self.setTitleColor(UIColor.white, for: .normal)
        self.backgroundColor = .uiLightOrange?.withAlphaComponent(0.9)
        self.titleLabel?.font = UIFont(name: "GeezaPro-Bold", size: 18)
        self.layer.cornerRadius = 5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
