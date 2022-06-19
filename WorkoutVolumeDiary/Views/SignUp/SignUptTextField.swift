//
//  SignUpButtom.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/06/19.
//

import Foundation
import UIKit

class SignUptTextField: UITextField {
    
    init(placeholder: String){
        super.init(frame: .zero)
        self.placeholder = placeholder
            self.borderStyle = .roundedRect
            self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
