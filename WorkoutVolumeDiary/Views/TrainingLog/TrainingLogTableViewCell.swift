//
//  TrainingLogTableViewCell.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/06/01.
//

import UIKit

class TrainingLogTableViewCell: UITableViewCell {
//MARK: - Properties
    
    static let identifier = "TrainingLogTableViewCell"
        
//MARK: - UIParts
    
    let menuLabel = TreLogTableViewLabel(maskedCorner: [],
                                         backgroundColor: (UIColor.uiLightOrange?.withAlphaComponent(0.9))!,
                                         textColor: .white,
                                         textAlignment: .left)
    
    let targetPartLabel = TreLogTableViewLabel(maskedCorner: [.layerMinXMinYCorner],
                                               backgroundColor: .white.withAlphaComponent(0.9),
                                               textColor: (UIColor.uiLightOrange?.withAlphaComponent(0.9))!,
                                               textAlignment: .center)

    let volumeTextLabel = TreLogTableViewLabel(maskedCorner: [],
                                               backgroundColor: .white.withAlphaComponent(0.9),
                                               textColor: (UIColor.uiLightOrange?.withAlphaComponent(0.9))!,
                                               textAlignment: .center,
                                               text: "総負荷")
    
    let TotalVolumeLabel = TreLogTableViewLabel(maskedCorner: [],
                                           backgroundColor: .white.withAlphaComponent(0.9),
                                           textColor: (UIColor.uiLightOrange?.withAlphaComponent(0.9))!,
                                           textAlignment: .left)

    let spacerLabel = TreLogTableViewLabel(maskedCorner: [.layerMaxXMaxYCorner],
                                           backgroundColor: (.uiLightOrange?)!,
                                           textColor: (UIColor.uiLightOrange?.withAlphaComponent(0.9))!,
                                           textAlignment: .left)
  
    let addLogButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.circle.fill")?.resize(size: CGSize(width: 40, height: 40)), for: .normal)
        button.tintColor = .endColor
        button.layer.cornerRadius = 10
        button.layer.maskedCorners = [.layerMaxXMinYCorner]
        button.layer.backgroundColor = UIColor.uiLightOrange?.withAlphaComponent(0.9).cgColor
        return button
    }()
    
    let repsTableView: UITableView = {
       let tableView = UITableView()
        tableView.register(RepsTableViewCell.self, forCellReuseIdentifier: RepsTableViewCell.identifier)
        return tableView
    }()
    
//MARK: - LifeCycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.layer.cornerRadius = 10

//        repsTableView.dataSource = self
        setupLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderColor = UIColor.uiLightOrange?.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 10
        backgroundColor = .clear
        
        targetPartLabel.addBorder(width: 2, color: (.uiLightOrange?.withAlphaComponent(0.9))!, position: .bottomRight)
        volumeTextLabel.addBorder(width: 2, color: (.uiLightOrange?.withAlphaComponent(0.9))!, position: .bottomRight)
        TotalVolumeLabel.addBorder(width: 2, color: (.uiLightOrange?.withAlphaComponent(0.9))!, position: .bottom)
        
        repsTableView.backgroundColor = .white.withAlphaComponent(0.9)
        repsTableView.layer.cornerRadius = 10
        repsTableView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    func setupLayout() {
        
        addSubview(targetPartLabel)
        addSubview(menuLabel)
        addSubview(TotalVolumeLabel)
        addSubview(volumeTextLabel)
        addSubview(addLogButton)
        addSubview(repsTableView)
        targetPartLabel.anchor(top: topAnchor, left: leftAnchor, width: 50, height: 45)
        menuLabel.anchor(top: topAnchor, left: targetPartLabel.rightAnchor, right: addLogButton.leftAnchor, height: 25)
        addLogButton.anchor(top: topAnchor, right: rightAnchor, width: 45, height: 45)
        volumeTextLabel.anchor(top: menuLabel.bottomAnchor, left: targetPartLabel.rightAnchor, right: TotalVolumeLabel.leftAnchor, height: 20)
        TotalVolumeLabel.anchor(top: menuLabel.bottomAnchor, right: addLogButton.leftAnchor, width: (bounds.width-115)/2, height: 20)
        repsTableView.anchor(top: targetPartLabel.bottomAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor)

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource

//extension TrainingLogTableViewCell: UITableViewDelegate, UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return repsWeightArray.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: RepsTableViewCell.identifier, for: indexPath) as! RepsTableViewCell
//        cell.weightLabel.text = repsWeightArray[indexPath.row].weight.description
//        cell.repsLabel.text = repsWeightArray[indexPath.row].reps.description
//        cell.volumeLabel.text = String(repsWeightArray[indexPath.row].weight * repsWeightArray[indexPath.row].reps)
//        return cell
//    }
//
//}


//MARK: - TreLogTableViewLabel
class TreLogTableViewLabel: UILabel {
    
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
        self.font = UIFont(name: "SinhalaSangamMN", size: 16)
        self.textAlignment = textAlignment
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: - RepsTableViewCell
class RepsTableViewCell: UITableViewCell {
    
    static let identifier = "RepsTableViewCell"
    
    let weightLabel: UILabel = {
       let label = UILabel()
        label.layer.masksToBounds = true
        label.backgroundColor = .clear
        label.textColor = .uiLightOrange?.withAlphaComponent(0.9)
        label.font = UIFont(name: "SinhalaSangamMN", size: 10)
        label.textAlignment = .center
        label.backgroundColor = .systemPink

        return label
    }()
    
    let batsuLabel: UILabel =  {
        let label = UILabel()
        label.layer.masksToBounds = true
        label.backgroundColor = .clear
        label.textColor = .uiLightOrange?.withAlphaComponent(0.9)
        label.font = UIFont(name: "SinhalaSangamMN", size: 10)
        label.textAlignment = .center
        label.text = "×"
        label.backgroundColor = .systemPink

         return label
    }()
    
    let repsLabel: UILabel = {
        let label = UILabel()
        label.layer.masksToBounds = true
        label.backgroundColor = .clear
        label.textColor = .uiLightOrange?.withAlphaComponent(0.9)
        label.font = UIFont(name: "SinhalaSangamMN", size: 10)
        label.textAlignment = .center
        label.backgroundColor = .systemPink

         return label
    }()
    
    let equalLabel: UILabel =  {
        let label = UILabel()
        label.layer.masksToBounds = true
        label.backgroundColor = .clear
        label.textColor = .uiLightOrange?.withAlphaComponent(0.9)
        label.font = UIFont(name: "SinhalaSangamMN", size: 10)
        label.textAlignment = .center
        label.text = "="
        label.backgroundColor = .systemPink

         return label
    }()
    
    let volumeLabel: UILabel =  {
        let label = UILabel()
        label.layer.masksToBounds = true
        label.backgroundColor = .clear
        label.textColor = .uiLightOrange?.withAlphaComponent(0.9)
        label.font = UIFont(name: "SinhalaSangamMN", size: 10)
        label.textAlignment = .center
        label.backgroundColor = .systemPink

         return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .gray
    }
    
    private func setupLayout() {
        addSubview(weightLabel)
        addSubview(batsuLabel)
        addSubview(repsLabel)
        addSubview(equalLabel)
        addSubview(volumeLabel)

        weightLabel.anchor(left: leftAnchor, centerY: centerYAnchor, width: 60,  leftPadding: 60)
        batsuLabel.anchor(left: weightLabel.rightAnchor, centerY: centerYAnchor, width: 30,  leftPadding: 0)
        repsLabel.anchor(left: batsuLabel.rightAnchor, centerY: centerYAnchor, width: 60,  leftPadding: 0)
        equalLabel.anchor(left: repsLabel.rightAnchor, centerY: centerYAnchor, width: 30,  leftPadding: 0)
        volumeLabel.anchor(left: equalLabel.rightAnchor, centerY: centerYAnchor, width: 60,  leftPadding: 0)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
