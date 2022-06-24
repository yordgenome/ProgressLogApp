//
//  TrainingLogHeaderView.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/06/04.
//

import UIKit

final class DatePickView: UIView, UITextFieldDelegate {
    
    let nextDayButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("翌日＞", for: .normal)
        button.setTitleColor(UIColor.endColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "GeezaPro", size: 14)
        button.layer.masksToBounds = true
        button.layer.backgroundColor =  UIColor.white.withAlphaComponent(0.9).cgColor
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.endColor?.cgColor
        
        return button
    }()
    
    private let previousDayButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("＜前日", for: .normal)
        button.setTitleColor(UIColor.endColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "GeezaPro", size: 14)
        button.layer.masksToBounds = true
        button.layer.backgroundColor = UIColor.white.withAlphaComponent(0.9).cgColor
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.endColor?.cgColor
        
        return button
    }()
    
    let dateTextField: UITextField = {
        let textField = UITextField()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月d日"
        let timeString = formatter.string(from: Date())
        let attributes: [NSAttributedString.Key : Any] = [
            .font: UIFont(name: "GeezaPro", size: 14) as Any,
            .foregroundColor : UIColor.endColor as Any
        ]
        textField.attributedPlaceholder = NSAttributedString(string: timeString, attributes: attributes)
        textField.textAlignment = .center
        textField.font = UIFont(name: "GeezaPro", size: 14)
        textField.textColor = UIColor.endColor
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.endColor?.cgColor
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        
        return textField
    }()
    
    let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.locale = Locale.current
        dp.maximumDate = Date()
        dp.backgroundColor = UIColor.endColor
        return dp
    }()
    
    private let totalVolumeLabel: UILabel = {
        let label = UILabel()
        label.text = "本日のトレーニングボリューム"
        
        
        return label
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        setupDatePicker()
        setupRegisterView()
    }
    
    private func setupDatePicker() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(title: "決定", style: .done, target: self, action: #selector(done))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年 M月d日"
        let timeString = formatter.string(from: Date())
        datePicker.date = formatter.date(from: timeString)!
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Date()
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = toolbar
        dateTextField.delegate = self
    }
    
    private func setupLayout() {
        backgroundColor = .uiLightOrange?.withAlphaComponent(0.9)
//        layer.borderColor = UIColor.appDavysGray?.cgColor
//        layer.borderWidth = 2
        
        addSubview(previousDayButton)
        addSubview(dateTextField)
        addSubview(nextDayButton)
        
        dateTextField.inputView = datePicker
        
        previousDayButton.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, width: 50, height: 25, topPadding: 5, leftPadding: 20)
        dateTextField.anchor(top: safeAreaLayoutGuide.topAnchor, centerX: centerXAnchor, width: 130, height: 25, topPadding: 5)
        nextDayButton.anchor(top: safeAreaLayoutGuide.topAnchor, right: rightAnchor, width: 50, height: 25, topPadding: 5, rightPadding: 20)
    }
    
    private func setupRegisterView() {


        

    }
    
    @objc func done() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年 M月d日"
        dateTextField.text = formatter.string(from: datePicker.date)
        endEditing(true)
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


