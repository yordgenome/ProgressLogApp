//
//  TrainingLogTableViewCell.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/06/01.
//

import UIKit

class WorkoutTableViewCell: UITableViewCell {
//MARK: - Properties
    
    static let identifier = "WorkoutTableViewCell"
        
//MARK: - UIParts
    
    let menuLabel = WorkoutTableViewLabel(maskedCorner: [],
                                         backgroundColor: (UIColor.gold?.withAlphaComponent(0.9))!,
                                         textColor: .white,
                                         textAlignment: .left)
    
    let targetPartLabel = WorkoutTableViewLabel(maskedCorner: [.layerMinXMinYCorner],
                                               backgroundColor: .white.withAlphaComponent(0.9),
                                               textColor: (UIColor.gold?.withAlphaComponent(0.9))!,
                                               textAlignment: .center)

    let volumeTextLabel = WorkoutTableViewLabel(maskedCorner: [],
                                               backgroundColor: .white.withAlphaComponent(0.9),
                                               textColor: (UIColor.gold?.withAlphaComponent(0.9))!,
                                               textAlignment: .center,
                                               text: "総負荷")
    
    let TotalVolumeLabel = WorkoutTableViewLabel(maskedCorner: [],
                                           backgroundColor: .white.withAlphaComponent(0.9),
                                           textColor: (UIColor.gold?.withAlphaComponent(0.9))!,
                                           textAlignment: .left)
    let weightLabel = WorkoutTableViewLabel(maskedCorner: [],
                                           backgroundColor: .clear,
                                           textColor: (UIColor.gold?.withAlphaComponent(0.9))!,
                                           textAlignment: .center)
    let batsuLabel = WorkoutTableViewLabel(maskedCorner: [],
                                           backgroundColor: .clear,
                                           textColor: (UIColor.gold?.withAlphaComponent(0.9))!,
                                           textAlignment: .center)
    let repsLabel = WorkoutTableViewLabel(maskedCorner: [],
                                           backgroundColor: .clear,
                                           textColor: (UIColor.gold?.withAlphaComponent(0.9))!,
                                           textAlignment: .center)
  
    let addLogButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.circle.fill")?.resize(size: CGSize(width: 40, height: 40)), for: .normal)
        button.tintColor = .endColor
        button.layer.cornerRadius = 10
        button.layer.maskedCorners = [.layerMaxXMinYCorner]
        button.layer.backgroundColor = UIColor.gold?.withAlphaComponent(0.9).cgColor
        return button
    }()
    
    
//MARK: - LifeCycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.layer.cornerRadius = 10

        batsuLabel.text = "×"
        setupLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderColor = UIColor.gold?.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 10
        backgroundColor = .white
        
        targetPartLabel.addBorder(width: 2, color: (.gold?.withAlphaComponent(0.9))!, position: .bottomRight)
        volumeTextLabel.addBorder(width: 2, color: (.gold?.withAlphaComponent(0.9))!, position: .bottomRight)
        TotalVolumeLabel.addBorder(width: 2, color: (.gold?.withAlphaComponent(0.9))!, position: .bottom)
        
    }
    
    func setupLayout() {
        
        addSubview(targetPartLabel)
        addSubview(menuLabel)
        addSubview(TotalVolumeLabel)
        addSubview(volumeTextLabel)
        addSubview(addLogButton)
        addSubview(weightLabel)
        addSubview(batsuLabel)
        addSubview(repsLabel)
        targetPartLabel.anchor(top: topAnchor, left: leftAnchor, width: 50, height: 45)
        menuLabel.anchor(top: topAnchor, left: targetPartLabel.rightAnchor, right: addLogButton.leftAnchor, height: 25)
        addLogButton.anchor(top: topAnchor, right: rightAnchor, width: 45, height: 45)
        volumeTextLabel.anchor(top: menuLabel.bottomAnchor, left: targetPartLabel.rightAnchor, right: TotalVolumeLabel.leftAnchor, height: 20)
        TotalVolumeLabel.anchor(top: menuLabel.bottomAnchor, right: addLogButton.leftAnchor, width: (bounds.width-115)/2, height: 20)
        weightLabel.anchor(top: targetPartLabel.bottomAnchor, left: leftAnchor, width: 60, height: 20, topPadding: 5, leftPadding: 40)
        batsuLabel.anchor(top: weightLabel.topAnchor, left: weightLabel.rightAnchor, width: 20, height: 20, leftPadding: 20)
        repsLabel.anchor(top: weightLabel.topAnchor, left: batsuLabel.rightAnchor, width: 60, height: 20, leftPadding: 20)


        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - WorkoutTableViewLabel
class WorkoutTableViewLabel: UILabel {
    
    init(maskedCorner: CACornerMask,
         borderWidth: CGFloat = 2,
         borderColor: UIColor = (UIColor.uiLightOrange?.withAlphaComponent(0.9))!,
         borderPosition: BorderPosition = .none,
         backgroundColor: UIColor, textColor: UIColor,
         textAlignment: NSTextAlignment,
         text: String = "") {
        
        super.init(frame: .zero)
        self.layer.cornerRadius = 10
        self.layer.maskedCorners = maskedCorner
        self.layer.masksToBounds = true
        self.layer.backgroundColor = backgroundColor.cgColor
        self.addBorder(width: borderWidth, color: borderColor, position: borderPosition)
        self.textColor = textColor
        self.text = text
        self.font = UIFont(name: "GeezaPro", size: 16)
        self.textAlignment = textAlignment
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

