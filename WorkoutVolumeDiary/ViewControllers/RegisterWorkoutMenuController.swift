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

class WorkoutMenu: Codable {
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
    func changeCellState(view: RegiWorkoutTVHeader, section: Int)
}

final class RegisterWorkoutMenuController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = SetTargetViewModel()
    private let gradientView = GradientView()
    private let footerView = MuscleFooterView()
    private let headerView = RegiWorkoutHeaderView()
    private let setTargetView = SetTargetView()
    var workoutMenuArray = [WorkoutMenu]()
    
    let workoutMenuTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(RegiWorkoutCell.self, forCellReuseIdentifier: RegiWorkoutCell.identifier)
        return tableView
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        workoutMenuArray = UserDefaults.standard.getWorkoutMenu("WorkoutMenu") ?? []
        
        if workoutMenuArray.isEmpty {
            setupWorkoutMenu()
        }
        workoutMenuTableView.delegate = self
        workoutMenuTableView.dataSource = self
        workoutMenuTableView.backgroundColor = .clear
        
        setupLayout()
        setupBindings()
    }
    
    private func setupLayout() {
        view.addSubview(gradientView)
        view.addSubview(headerView)
        view.addSubview(setTargetView)
        view.addSubview(footerView)
        view.addSubview(workoutMenuTableView)
        
        gradientView.frame = view.bounds
        headerView.anchor(top: view.topAnchor, centerX: view.centerXAnchor, width: view.frame.width, height: 80)
        setTargetView.anchor(top: headerView.bottomAnchor, centerX: view.centerXAnchor, width: view.frame.width, height: 54)
        workoutMenuTableView.anchor(top: setTargetView.bottomAnchor, bottom: footerView.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        footerView.anchor(bottom: view.bottomAnchor, centerX: view.centerXAnchor, width: view.bounds.width, height: 80)
    }
    
    private func setupWorkoutMenu() {
        workoutMenuArray.append(WorkoutMenu(target: "???", menu: ["??????????????????", "?????????????????????", "???????????????"]))
        workoutMenuArray.append(WorkoutMenu(target: "???", menu: ["????????????????????????", "??????????????????", "???????????????"]))
        workoutMenuArray.append(WorkoutMenu(target: "???", menu: ["??????????????????", "?????????????????????", "???????????????????????????"]))
        workoutMenuArray.append(WorkoutMenu(target: "???", menu: ["????????????????????????", "???????????????????????????", "?????????????????????????????????"]))
        workoutMenuArray.append(WorkoutMenu(target: "???", menu: ["???????????????", "?????????????????????????????????", "??????????????????"]))
        workoutMenuArray.append(WorkoutMenu(target: "???", menu: ["??????????????????", "??????????????????????????????", "??????????????????"]))
        workoutMenuArray.append(WorkoutMenu(target: "???", menu: []))
    }
    
    //MARK: - Bindings
    private func setupBindings() {
        
        setTargetView.targetTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                self?.viewModel.targetTextInput.onNext(text ?? "")
            }
            .disposed(by: disposeBag)
        
        setTargetView.setButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                let text = self.setTargetView.targetTextField.text
                self.workoutMenuArray.append(WorkoutMenu(target: text!, menu: []))
                UserDefaults.standard.setWorkoutMenu(self.workoutMenuArray, "WorkoutMenu")
                self.workoutMenuTableView.reloadData()
                self.setTargetView.targetTextField.resignFirstResponder()
                self.setTargetView.targetTextField.text = ""
            })
        .disposed(by: disposeBag)
        
        viewModel.validTextDriver.drive { validAll in
            self.setTargetView.setButton.isEnabled = validAll
            self.setTargetView.setButton.backgroundColor = validAll ? .uiLightOrange?.withAlphaComponent(0.9) : .init(white: 0.9, alpha: 0.9)
        }
        .disposed(by: disposeBag)
        
        headerView.editButton.rx.tap.asDriver().drive { [ weak self ] _ in
            guard let self = self else { return }
            
            switch self.workoutMenuTableView.isEditing {
            case true:
                self.workoutMenuTableView.isEditing = false
                self.headerView.editButton.setTitle("??????", for: .normal)
            case false:
                self.workoutMenuTableView.isEditing = true
                self.headerView.editButton.setTitle("??????", for: .normal)
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
        
        headerView.addMenuButton.rx.tap.asDriver().drive(onNext: { [weak self] in
            guard let self = self else { return }
            let alert: UIAlertController = UIAlertController(title: "\(self.workoutMenuArray[section].target )", message: "?????????????????????????????????", preferredStyle: UIAlertController.Style.alert)
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.placeholder = "???????????????????????????"
            alert.textFields?.first?.keyboardType = .namePhonePad
            let saveMenuAction: UIAlertAction = UIAlertAction(title: "??????", style: UIAlertAction.Style.default, handler: { (_: UIAlertAction!) -> Void in
                guard let text = alert.textFields?.first?.text, !text.isEmpty else {
                    return
                }
                self.workoutMenuArray[section].menu.append(text)
                UserDefaults.standard.setWorkoutMenu(self.workoutMenuArray, "WorkoutMenu")
                self.workoutMenuTableView.reloadSections(IndexSet([section]), with: .automatic)
            })
            let cancelAction: UIAlertAction = UIAlertAction(title: "???????????????", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(saveMenuAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        headerView.deleteButton.rx.tap.asDriver().drive(onNext: { [weak self] in
            guard let self = self else { return }
            let alert: UIAlertController = UIAlertController(title: "???\(self.workoutMenuArray[section].target )????????????", message: "???\(self.workoutMenuArray[section].target )?????????????????????????????????????????????????????????", preferredStyle: UIAlertController.Style.alert)
            let deleteAction: UIAlertAction = UIAlertAction(title: "??????", style: UIAlertAction.Style.destructive, handler: { (_: UIAlertAction!) -> Void in
                self.workoutMenuArray.remove(at: section)
                UserDefaults.standard.setWorkoutMenu(self.workoutMenuArray, "WorkoutMenu")
                self.workoutMenuTableView.reloadData()
            })
            let cancelAction: UIAlertAction = UIAlertAction(title: "???????????????", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }).disposed(by: disposeBag)
        return headerView
    }
    

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
        
    // cell??????????????????????????????
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        workoutMenuArray[indexPath.section].menu.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "??????") {action, view, completionHandler in
            
            let alert = UIAlertController(title: "??????", message: "???????????????????????????????????????????", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "??????", style: .destructive, handler: { _ in
                self.workoutMenuArray[indexPath.section].menu.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }))
            alert.addAction(UIAlertAction(title: "???????????????", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            completionHandler(true)
            
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    // cell???????????????

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let workoutMenu = workoutMenuArray[sourceIndexPath.section].menu[sourceIndexPath.row]
        workoutMenuArray[sourceIndexPath.section].menu.remove(at: sourceIndexPath.row)
        workoutMenuArray[sourceIndexPath.section].menu.insert(workoutMenu, at: destinationIndexPath.row)
        UserDefaults.standard.setWorkoutMenu(workoutMenuArray, "WorkoutMenu")
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
        workoutMenuArray[section].isOpened = !workoutMenuArray[section].isOpened
        workoutMenuTableView.reloadSections(IndexSet([section]), with: .automatic)
    }
}
    
    

