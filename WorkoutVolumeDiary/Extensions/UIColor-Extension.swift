//
//  UIColor-Extensions.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/05/26.
//

import UIKit

extension UIColor{
    
    static let uiLightOrange = UIColor(hex: "FF9E00")
    static let uiDarkOrange = UIColor(hex: "AC6A00")
    
    
    static let startColor = UIColor(hex: "#00172D")
    static let endColor = UIColor(hex: "#0052A2")

    static let gold = UIColor(hex: "#A57C01")

    
    
    static let appGrullo = UIColor(hex: "AA977C")
    static let appDarkSilver = UIColor(hex: "7C7669")
    static let appDavysGray = UIColor(hex: "5C5C5A")
    static let appCMikadoYellow = UIColor(hex: "DDDAB2")
    static let appAlabaster = UIColor(hex: "F3EDE9")
    static let appPaleSilver = UIColor(hex: "CAC4B5")    

convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    

}
