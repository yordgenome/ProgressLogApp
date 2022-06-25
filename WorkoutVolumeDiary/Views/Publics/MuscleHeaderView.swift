//
//  MuscleHeaderView.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/06/04.
//

import UIKit


class MuscleHeaderView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let muscleArray = ["全身", "胸", "背中", "", "肩", "腹", "脚", "その他"]
    
    var cellItemsWidth: CGFloat = 0.0
    
    let muscleCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 1.0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MuscleCollectionViewCell.self, forCellWithReuseIdentifier: MuscleCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        muscleCollectionView.delegate = self
        muscleCollectionView.dataSource = self
    }
    
    override func layoutSubviews() {
        addSubview(muscleCollectionView)
        muscleCollectionView.anchor(top: topAnchor, centerX: centerXAnchor, width: bounds.width, height: 80)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return muscleArray.count*3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MuscleCollectionViewCell.identifier, for: indexPath) as! MuscleCollectionViewCell
        cell.muscleNameLabel.text = muscleArray[indexPath.row%muscleArray.count]
        
        //        if indexPath.row == 0 {
        //            cell.muscleNameLabel.layer.backgroundColor = UIColor.appDavysGray?.cgColor
        //            cell.muscleNameLabel.textColor = .appAlabaster
        //        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
}

extension MuscleHeaderView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if cellItemsWidth == 0.0 {
            cellItemsWidth = floor(scrollView.contentSize.width / 3.0) // 表示したい要素群のwidthを計算
        }
        
        if (scrollView.contentOffset.x <= 0.0) || (scrollView.contentOffset.x > cellItemsWidth * 1.8) { // スクロールした位置がしきい値を超えたら中央に戻す
            scrollView.contentOffset.x = cellItemsWidth
        }
        
    }
    
}

class MuscleCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MuscleCollectionViewCell"
    
    let muscleNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .appDavysGray
        label.layer.cornerRadius = 8
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor.appDavysGray?.cgColor
        label.layer.backgroundColor = UIColor.appCMikadoYellow?.cgColor
        
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(muscleNameLabel)
        layer.backgroundColor = UIColor.appDarkSilver?.cgColor
    }
    
    override func layoutSubviews() {
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.appDavysGray?.cgColor
        
        muscleNameLabel.anchor(centerY: centerYAnchor, centerX: centerXAnchor, width: contentView.bounds.height*4/5, height: contentView.bounds.height*4/5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
