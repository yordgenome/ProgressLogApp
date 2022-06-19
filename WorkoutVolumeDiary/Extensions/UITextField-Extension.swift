//
//  UITextField-Extension.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/06/04.
//

import UIKit

extension UITextField {

    func cornerRodius(_ r:CGFloat) {

        self.layer.cornerRadius = r

        self.layer.borderWidth = 2.0

        self.layer.borderColor = UIColor.gray.cgColor

        self.clipsToBounds = true

    }

}
