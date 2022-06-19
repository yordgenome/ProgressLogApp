//
//  UserModdel.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/06/07.
//

import UIKit
import FirebaseFirestore
import Foundation

struct UserModel {
    var emailString: String?
    var passwordString: String?
    var nameString: String?
    var createdAt: Timestamp
}
