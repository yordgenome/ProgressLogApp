//
//  DatePickerView.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/06/04.
//


import UIKit

final class DatePickerView: UIView {

    var datePicker: UIDatePicker = UIDatePicker()

    override init(frame: CGRect) {
//        let view = CGRect.init(from: frame)
        super.init(frame: .zero)
        
        setupDatePicker()
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
//        datePicker.date = formatter.date(from: Date())!
        datePicker.datePickerMode = .date
        datePicker.locale = Locale.current
        datePicker.maximumDate = Date()
        addSubview(datePicker)
        datePicker.subviews[0].subviews[0].subviews[0].backgroundColor = .clear

    }
}
//
//class CustomDatePicker: UIDatePicker {
//    
//    let label = UILabel()
//    
//    func updateLabel() {
//        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: "ja_JP")
//        formatter.setLocalizedDateFormatFromTemplate("MMM d yyyy")
//        label.text = formatter.string(from: date)
//    }
//    
//    override func willMove(toSuperview newSuperview: UIView?) {
//        super.willMove(toSuperview: newSuperview)
//        addSubview(label)
//    }
//    
//    func makeTransparent(view: UIView) {
//        if view === label { return }
//        if view.backgroundColor != nil {
//            view.isHidden = true
//        }
//        else {
//            for subview in view.subviews {
//
//            }
//        }
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        makeTransparent(view: self)
//        label.frame = CGRect(origin: .zero, size: frame.size)
//        updateLabel()
//    }
//}
