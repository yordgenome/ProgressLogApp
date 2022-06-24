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
//    var password: String
    var createdAt: Timestamp
    
    
//    init(dic: [String: Any]) {
//        self.name = dic["name"] as? String ?? ""
//        self.email = dic["email"] as? String ?? ""
//        self.password = dic["password"] as? String ?? ""
//        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
//    }
}
