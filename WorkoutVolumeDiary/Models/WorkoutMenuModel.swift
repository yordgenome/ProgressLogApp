//
//  WorkoutMenuModel.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/06/01.
//

import UIKit
import FirebaseFirestore
import SwiftUI


struct WorkoutModel {
    var doneAt: Timestamp = Timestamp(date: Date())
    var targetPart: TargetPart
    var workoutName: String = ""
    var weight: Double = 1
    var reps: Double = 1
    var volume: Double


    init(doneAt: Timestamp,
         targetPart: TargetPart,
         workoutName: String,
         weight: Double,
         reps: Double,
         volume: Double){

        self.doneAt = doneAt
        self.targetPart = targetPart
        self.workoutName = workoutName
        self.weight = weight
        self.reps = reps
        self.volume = weight * reps
    }
    
//    func toDictionary() -> [String: Any] {
//        return [
//            "date": doneAt,
//            "workoutName" : workoutName,
//            "targetPart" : targetPart,
//            "sets": sets
//        ]
//    }
}

class WorkoutMenuModel {
    var menu: [String: TargetPart] =
    ["ベンチプレス": .chest,
     "アームカール": .arm,
     "サイドレイズ": .shoulder,
     "クランチ": .abs,
     "スクワット": .leg
    ]
}

public enum TargetPart {
    case chest
    case back
    case arm
    case shoulder
    case abs
    case leg
    case others
    
    public func toString() -> String {
            switch self {
            case .chest: return "chest"
            case .shoulder: return "shoulder"
            case .back: return "back"
            case .arm: return "arm"
            case .abs: return "abs"
            case .leg: return "leg"
            case .others: return "others"
            }
    }
}

class TargetPartUtils {
    
    class func toTargetPartg(_ targetPart: String) -> TargetPart {
        switch targetPart {
        case "chest": return .chest
        case "shoulder": return .shoulder
        case "back": return .back
        case "arm": return .arm
        case "abs": return .abs
        case "leg": return .leg
        case "others": return .others
        default: return .others
        }
    }
}


