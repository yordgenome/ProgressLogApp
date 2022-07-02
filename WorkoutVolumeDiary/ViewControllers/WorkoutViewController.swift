//
//  TrainingLogController.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/06/01.
//

import UIKit
import FirebaseFirestore
import RxSwift
import RxCocoa


final class WorkoutViewController: UIViewController {
    
//MARK: - Properties
//    private var workoutMenu = WorkoutMenuModel()
    
    private let viewModel = SetworkoutViewModel()
    private let gradientView = GradientView()
    private let footerView = MuscleFooterView()
    private let headerView = DatePickView()
    private let setWorkoutView = SetWorkoutView()
    
    let userDefaults = UserDefaults.standard
    
    let disposeBag = DisposeBag()
    
    var workoutMenu = ["腕立て伏せ",
                       "ベンチプレス",
                       "懸垂",
                       "スクワット",
                       "アームカール",
                       "ショルダープレス"
    ]
    
    private let targetParts = ["胸", "背", "肩", "腕", "腹", "脚", "他"]
    
    var workoutData: [WorkoutModel] = []
    
    var currentDate: Date?
      
    private let workoutTableView: UITableView = {
        let tv = UITableView.init(frame: .zero, style: .grouped)
        tv.register(WorkoutTableViewCell.self, forCellReuseIdentifier: WorkoutTableViewCell.identifier)
        tv.backgroundColor = .clear
        tv.layer.cornerRadius = 10
        return tv
    }()
    
//MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        currentDate = DateUtils.toDateFromString(string: headerView.dateTextField.text!)
        
        
        print("currentDate:", currentDate!)
        workoutTableView.delegate = self
        workoutTableView.dataSource = self

        setupLayout()
        setupBindings()
    }
    
    private func setupLayout() {
        view.addSubview(gradientView)
        view.addSubview(headerView)
        view.addSubview(setWorkoutView)
        view.addSubview(workoutTableView)
        view.addSubview(footerView)
        
        gradientView.frame = view.bounds
        headerView.anchor(top: view.topAnchor, centerX: view.centerXAnchor, width: view.frame.width+4, height: 80)
        setWorkoutView.anchor(top: headerView.bottomAnchor, centerX: view.centerXAnchor, width: view.bounds.width, height: 100)
        workoutTableView.anchor(top: setWorkoutView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, width: view.bounds.width-20, height: view.bounds.height-50, topPadding: 20, leftPadding: 10, rightPadding:  10)
        footerView.anchor(bottom: view.bottomAnchor, centerX: view.centerXAnchor, width: view.bounds.width, height: 80)
    }

//MARK: - Bindings
    private func setupBindings() {
        
        SetupTextFields()
        // 日付処理
        headerView.dateTextField.rx.text.asDriver().drive { [weak self] text in
            guard let self = self else { return }
            self.currentDate = DateUtils.toDateFromString(string: text!)
//            let data: [WorkoutModel] = []
//            Task {try await UserModel.setWorkoutToFirestore(workout: data, dateString: DateUtils.toStringFromDate(date: self.currentDate!))}
            print("currentDate:", self.currentDate!)
        }
        .disposed(by: disposeBag)
        
        headerView.previousDayButton.rx.tap.asDriver().drive { [weak self] _ in
            guard let self = self else { return }
            self.currentDate = Calendar.current.date(byAdding: .day, value: -1, to: self.currentDate!)!
            self.headerView.dateTextField.text = DateUtils.toStringFromDate(date: self.currentDate!)
            print("currentDate:", self.currentDate!)
        }.disposed(by: disposeBag)

        headerView.nextDayButton.rx.tap.asDriver().drive { [weak self] _ in
            guard let self = self else { return }
            if self.currentDate == DateUtils.toDateFromString(string: DateUtils.toStringFromDate(date: Date())) {
                print("currentDate:", self.currentDate!)
                return
            } else {
                self.currentDate = Calendar.current.date(byAdding: .day, value: 1, to: self.currentDate!)!
                self.headerView.dateTextField.text = DateUtils.toStringFromDate(date: self.currentDate!)
                print("currentDate:", self.currentDate!)
            }
        }.disposed(by: disposeBag)
        
        // ワークアウト登録
        setWorkoutView.setButton.rx.tap.asDriver().drive {[ weak self ] _ in
            guard let self = self else { return }
            let targetPart = TargetPartUtils.toTargetPart(self.setWorkoutView.targetPartTextField.text!)
            let workoutName = self.setWorkoutView.workoutNameTextField.text!
            let weight = Double(self.setWorkoutView.weightTextField.text!)!
            let reps = Double(self.setWorkoutView.repsTextField.text!)!
            let workout = WorkoutModel(doneAt: Timestamp(date: self.currentDate!), targetPart: targetPart, workoutName: workoutName, weight: weight, reps: reps, volume: weight*reps)
            self.workoutData.append(workout)
            self.workoutTableView.reloadData()
            print(self.workoutData)
            Task { do { try await UserModel.setWorkoutToFirestore(workout: self.workoutData, dateString: DateUtils.toStringFromDate(date: self.currentDate!))
            } catch { print("ワークアウトの登録に失敗") }
            }
        }.disposed(by: disposeBag)

        
        setWorkoutView.workoutNameTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                self?.viewModel.workoutNameTextInput.onNext(text ?? "")
            }
            .disposed(by: disposeBag)
        
        setWorkoutView.targetPartTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                self?.viewModel.targetPartTextInput.onNext(text ?? "")
            }
            .disposed(by: disposeBag)
        
        setWorkoutView.weightTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                self?.viewModel.weightTextInput.onNext(text ?? "")
            }
            .disposed(by: disposeBag)
        
        setWorkoutView.repsTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                self?.viewModel.repsTextInput.onNext(text ?? "")
            }
            .disposed(by: disposeBag)
        
        viewModel.validRegisterDriver.drive { validAll in
            print(validAll)
            self.setWorkoutView.setButton.isEnabled = validAll
            self.setWorkoutView.setButton.backgroundColor = validAll ? .endColor?.withAlphaComponent(0.9) : .init(white: 0.9, alpha: 0.9)
        }
        .disposed(by: disposeBag)
        
        footerView.homeView.button?.rx.tap.asDriver().drive { [ weak self ] _ in
            let homeVC = HomeViewController()
            homeVC.modalPresentationStyle = .fullScreen
            self?.present(homeVC, animated: true)
        }
        .disposed(by: disposeBag)
                                                 
    }
    
    private func SetupTextFields() {
        
        let targetPartPicker = UIPickerView()
        targetPartPicker.tag = 1
        targetPartPicker.delegate = self
        targetPartPicker.dataSource = self
        setWorkoutView.targetPartTextField.inputView = targetPartPicker
        let targetPartToolbar = UIToolbar()
        targetPartToolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
        let space1 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButtonItem1 = UIBarButtonItem(title: "次へ", style: .done, target: self, action: #selector(donePicker1))
        targetPartToolbar.setItems([space1, doneButtonItem1], animated: true)
        setWorkoutView.targetPartTextField.inputAccessoryView = targetPartToolbar
        
        let workoutNamePicker = UIPickerView()
        workoutNamePicker.tag = 2
        workoutNamePicker.delegate = self
        workoutNamePicker.dataSource = self
        setWorkoutView.workoutNameTextField.inputView = workoutNamePicker
        let workoutNameToolbar = UIToolbar()
        workoutNameToolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
        let space2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButtonItem2 = UIBarButtonItem(title: "次へ", style: .done, target: self, action: #selector(donePicker2))
        workoutNameToolbar.setItems([space2, doneButtonItem2], animated: true)
        setWorkoutView.workoutNameTextField.inputAccessoryView = workoutNameToolbar

        let weightToolbar = UIToolbar()
        weightToolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
        let space3 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButtonItem3 = UIBarButtonItem(title: "次へ", style: .done, target: self, action: #selector(donePicker3))
        weightToolbar.setItems([space3, doneButtonItem3], animated: true)
        setWorkoutView.weightTextField.inputAccessoryView = weightToolbar
        
        let repsToolbar = UIToolbar()
        repsToolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
        let space4 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButtonItem4 = UIBarButtonItem(title: "決定", style: .done, target: self, action: #selector(donePicker4))
        repsToolbar.setItems([space4, doneButtonItem4], animated: true)
        setWorkoutView.repsTextField.inputAccessoryView = repsToolbar
    }
    
    @objc func donePicker1() {
        setWorkoutView.workoutNameTextField.becomeFirstResponder()
    }
    @objc func donePicker2() {
        setWorkoutView.weightTextField.becomeFirstResponder()
    }
    @objc func donePicker3() {
        setWorkoutView.repsTextField.becomeFirstResponder()
    }
    @objc func donePicker4() {
        setWorkoutView.repsTextField.resignFirstResponder()
    }
    
    //MARK: - UITextFieldDelegate
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            setWorkoutView.workoutNameTextField.becomeFirstResponder()
        case 1:
            setWorkoutView.weightTextField.becomeFirstResponder()
        case 2:
            setWorkoutView.repsTextField.becomeFirstResponder()
        case 3:
            setWorkoutView.repsTextField.resignFirstResponder()
        default:
            break
        }
        return true
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension WorkoutViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return workoutData.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WorkoutTableViewCell.identifier, for: indexPath) as! WorkoutTableViewCell
        cell.menuLabel.text = workoutData[indexPath.section].workoutName
        cell.targetPartLabel.text = workoutData[indexPath.section].targetPart.toString()
        cell.weightLabel.text = workoutData[indexPath.section].weight.description
        cell.repsLabel.text = workoutData[indexPath.section].reps.description
        cell.selectionStyle = .none
        
        return cell
    }
        
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let marginView = UIView()
        marginView.backgroundColor = .clear
        return marginView
    }


    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let marginView = UIView()
        marginView.backgroundColor = .clear
        return marginView
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "削除") {action, view, completionHandler in
            
            let alert = UIAlertController(title: "確認", message: "選択中のデータを削除しますか?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "削除", style: .destructive, handler: { _ in
                // 配列から削除
                self.workoutData.remove(at: indexPath.section)
                // セルから削除
                let indexSet = NSMutableIndexSet()
                indexSet.add(indexPath.section)
                tableView.deleteSections(indexSet as IndexSet, with: .fade)
                
            }))
            alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            completionHandler(true)
            
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}


//MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension WorkoutViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return targetParts.count
        } else {
            return workoutMenu.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return targetParts[row]
        } else {
            return workoutMenu[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            setWorkoutView.targetPartTextField.text = targetParts[row]
        } else {
            setWorkoutView.workoutNameTextField.text = workoutMenu[row]
        }
    }
}
