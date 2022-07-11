//
//  UserModdel.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/06/07.
//

import UIKit
import FirebaseFirestore
import Foundation

public struct User: Identifiable{
    public var id: String = UUID().uuidString
    var name: String
    var email: String
    var createdAt: Timestamp
}
