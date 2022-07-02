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
    
    func toDictionary() -> [String: Any] {
        return [
            "doneAt": doneAt,
            "targetPart" : targetPart.toString(),
            "workoutName" : workoutName,
            "weight": weight,
            "reps": reps,
            "volume": volume
        ]
    }
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
            case .chest: return "胸"
            case .shoulder: return "肩"
            case .back: return "背"
            case .arm: return "腕"
            case .abs: return "腹"
            case .leg: return "脚"
            case .others: return "他"
            }
    }
}

class TargetPartUtils {
    
    class func toTargetPart(_ targetPart: String) -> TargetPart {
        switch targetPart {
        case "胸": return .chest
        case "肩": return .shoulder
        case "背": return .back
        case "腕": return .arm
        case "腹": return .abs
        case "脚": return .leg
        case "他": return .others
        default: return .others
        }
    }
}


