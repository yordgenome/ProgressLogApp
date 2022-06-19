//
//  MuscleTableViewCell.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/05/26.
//

import UIKit

class MuscleTableViewCell: UITableViewCell {
    
    static let identifier = "MuscleTableViewCell"
    
    let label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        label.frame = self.frame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
