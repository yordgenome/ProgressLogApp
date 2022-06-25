//
//  DateUtil.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/06/14.
//

import UIKit

class DateUtils {
//    class func toDateFromString(string: String, format: String = "yyyy/MM/dd HH:mm:ss Z") -> Date {
//        let formatter: DateFormatter = DateFormatter()
//        formatter.calendar = Calendar(identifier: .gregorian)
//        formatter.locale = Locale(identifier: "ja_JP")
//        formatter.dateFormat = format
//        let dateString = string + "00秒 +0900\n"
//        return formatter.date(from: dateString)!
//    }

    class func toStringFromDate(date: Date, format: String = "yyyy年MM月dd日") -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}
