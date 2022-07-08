//
//  RegisterWorkoutMenuController.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/07/05.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import RxSwift
import RxCocoa
import SwiftUI

class WorkoutMenu {
    var target: String
    var menu: [String]
    var isOpened: Bool = true
    
    init(target: String, menu: [String], isOpened: Bool = true) {
        self.target = target
        self.menu = menu
        self.isOpened = isOpened
    }
}

protocol TableHeaderViewDelegate {
    /// 収束状態の変更要求
    func changeCellState(view: RegiWorkoutTVHeader, section: Int)
}

final class RegisterWorkoutMenuController: UIViewController {
    
    
    private let disposeBag = DisposeBag()
    
    private let gradientView = GradientView()
    private let footerView = MuscleFooterView()
    private let headerView = RegiWorkoutHeaderView()

    var workoutMenuArray = [WorkoutMenu]()
    
    let workoutMenuTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(RegiWorkoutCell.self, forCellReuseIdentifier: RegiWorkoutCell.identifier)
//        tableView.register(RegiWorkoutTVHeader.self, forHeaderFooterViewReuseIdentifier: RegiWorkoutTVHeader.identifier)
        return tableView
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        workoutMenuTableView.delegate = self
        workoutMenuTableView.dataSource = self
        workoutMenuTableView.backgroundColor = .clear
        
        setupWorkoutMenu()
        
        setupLayout()
        setupBindings()
    }
    
    
    private func setupLayout() {
        view.addSubview(gradientView)
        view.addSubview(headerView)
        view.addSubview(footerView)
        view.addSubview(workoutMenuTableView)
        
        gradientView.frame = view.bounds
        headerView.anchor(top: view.topAnchor, centerX: view.centerXAnchor, width: view.frame.width, height: 80)
        workoutMenuTableView.anchor(top: headerView.bottomAnchor, bottom: footerView.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        footerView.anchor(bottom: view.bottomAnchor, centerX: view.centerXAnchor, width: view.bounds.width, height: 80)

    }
    
    private func setupWorkoutMenu() {
        workoutMenuArray.append(WorkoutMenu(target: "胸", menu: ["ベンチプレス", "ダンベルフライ", "ディップス"]))
        workoutMenuArray.append(WorkoutMenu(target: "肩", menu: ["ショルダープレス", "サイドレイズ", "リアレイズ"]))
        workoutMenuArray.append(WorkoutMenu(target: "腕", menu: ["アームカール", "ハンマーカール", "スカルクラッシャー"]))
        workoutMenuArray.append(WorkoutMenu(target: "背", menu: ["ラットプルダウン", "ベントオーバーロウ", "バックエクステンション"]))
        workoutMenuArray.append(WorkoutMenu(target: "脚", menu: ["スクワット", "レッグエクステンション", "レッグカール"]))
        workoutMenuArray.append(WorkoutMenu(target: "腹", menu: ["シットアップ", "ツイストシットアップ", "レッグレイズ"]))
        workoutMenuArray.append(WorkoutMenu(target: "他", menu: []))
    }
    
    private func setupBindings() {
        
        headerView.editButton.rx.tap.asDriver().drive { [ weak self ] _ in
            guard let self = self else { return }
            
            switch self.workoutMenuTableView.isEditing {
            case true:
                self.workoutMenuTableView.isEditing = false
                self.headerView.editButton.setTitle("編集", for: .normal)
            case false:
                self.workoutMenuTableView.isEditing = true
                self.headerView.editButton.setTitle("決定", for: .normal)
            }
            
        }
        .disposed(by: disposeBag)
        
        footerView.workoutView.button?.rx.tap.asDriver().drive { [ weak self ] _ in
            let workoutVC = WorkoutViewController()
            workoutVC.modalPresentationStyle = .fullScreen
            self?.present(workoutVC, animated: true)
        }
        .disposed(by: disposeBag)
        
        footerView.homeView.button?.rx.tap.asDriver().drive { [ weak self ] _ in
            let homeVC = HomeViewController()
            homeVC.modalPresentationStyle = .fullScreen
            self?.present(homeVC, animated: true)
        }
        .disposed(by: disposeBag)
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension RegisterWorkoutMenuController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        25
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return workoutMenuArray.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let workoutMenu = workoutMenuArray[section]
        
        if workoutMenu.isOpened {
            return workoutMenuArray[section].menu.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        let cell = tableView.dequeueReusableCell(withIdentifier: RegiWorkoutCell.identifier, for: indexPath) as! RegiWorkoutCell
        cell.menuLabel.text = workoutMenuArray[indexPath.section].menu[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = RegiWorkoutTVHeader(frame: .zero, section: section)
        headerView.targetLabel.text = workoutMenuArray[section].target
        headerView.openSectionButton.setImage(
            workoutMenuArray[section].isOpened
            ? UIImage(systemName: "chevron.up")
            : UIImage(systemName: "chevron.down"), for: .normal)
        headerView.delegate = self

        return headerView
    }


    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
        
    // cellのスワイプ・編集処理
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        workoutMenuArray[indexPath.section].menu.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "削除") {action, view, completionHandler in
            
            let alert = UIAlertController(title: "確認", message: "選択中のデータを削除しますか?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "削除", style: .destructive, handler: { _ in
                // 配列から削除
                self.workoutMenuArray[indexPath.section].menu.remove(at: indexPath.row)
                // セルから削除
                tableView.deleteRows(at: [indexPath], with: .fade)
            }))
            alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            completionHandler(true)
            
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    // cellの移動処理

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let workoutMenu = workoutMenuArray[sourceIndexPath.section].menu[sourceIndexPath.row]
        workoutMenuArray[sourceIndexPath.section].menu.remove(at: sourceIndexPath.row)
        workoutMenuArray[sourceIndexPath.section].menu.insert(workoutMenu, at: destinationIndexPath.row)
    }

    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {

        if (proposedDestinationIndexPath.section != sourceIndexPath.section) {
            return sourceIndexPath
        }else {
            return proposedDestinationIndexPath
        }
    }
}

//MARK: - TableHeaderViewDelegate
extension RegisterWorkoutMenuController: TableHeaderViewDelegate {

    func changeCellState(view: RegiWorkoutTVHeader, section: Int) {
        print(#function)
        workoutMenuArray[section].isOpened = !workoutMenuArray[section].isOpened
        workoutMenuTableView.reloadSections(IndexSet([section]), with: .automatic)
    }
}
    
    

