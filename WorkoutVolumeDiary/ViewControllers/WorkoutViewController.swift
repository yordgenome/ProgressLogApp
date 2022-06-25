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
    let gradientView = GradientView()
    
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
    
    private let targetParts = ["胸", "背", "肩", "腕", "腹", "脚"]
    
    var workoutData: [WorkoutModel] = []
    
    private let trainingLogTableView: UITableView = {
        let tv = UITableView.init(frame: .zero, style: .grouped)
        tv.register(WorkoutTableViewCell.self, forCellReuseIdentifier: WorkoutTableViewCell.identifier)
        tv.backgroundColor = .clear
        tv.layer.cornerRadius = 10
        return tv
    }()
    
//MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trainingLogTableView.delegate = self
        trainingLogTableView.dataSource = self

        setupLayout()
        setupBindings()
    }
    
    private func setupLayout() {
        view.addSubview(gradientView)
        view.addSubview(headerView)
        view.addSubview(setWorkoutView)
        view.addSubview(trainingLogTableView)
        view.addSubview(footerView)
        
        gradientView.frame = view.bounds
        headerView.anchor(top: view.topAnchor, centerX: view.centerXAnchor, width: view.frame.width+4, height: 80)
        setWorkoutView.anchor(top: headerView.bottomAnchor, centerX: view.centerXAnchor, width: view.bounds.width, height: 100)
        trainingLogTableView.anchor(top: setWorkoutView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, width: view.bounds.width-20, height: view.bounds.height-50, topPadding: 20, leftPadding: 10, rightPadding:  10)
        footerView.anchor(bottom: view.bottomAnchor, centerX: view.centerXAnchor, width: view.bounds.width, height: 80)
        
//        headerView.nextDayButton.addTarget(self, action: #selector(test), for: .touchUpInside)
        
    }
    
    private func setupBindings() {
        
        SetupTextFields()
        
        setWorkoutView.setButton.rx.tap.asDriver().drive {[ weak self ] _ in
            print(#function)
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
            
            print(#function)
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
        WorkoutViewController().view.endEditing(true)
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
    
    
//    @objc func test() {
//
//        let dateString  = headerView.dateTextField.text!
//        let alert = UIAlertController(title: "\(dateString) ", message: "トレーニングを記録", preferredStyle: .alert)
//        //OKボタンを生成
//        let okAction = UIAlertAction(title: "登録", style: .default) { (action:UIAlertAction) in
//
//            guard let textFields:[UITextField] = alert.textFields else {return}
//
//            let workoutName = textFields[1].text ?? "ベンチプレス"
//            let targetPart = TargetPartUtils.toTargetPart(textFields[2].text!)
//            let weight = Double(textFields[3].text!) ?? 1
//            let reps = Double(textFields[4].text!) ?? 1
//            let workout = WorkoutModel(doneAt: Timestamp(), targetPart: targetPart, workoutName: workoutName, weight: weight, reps: reps, volume: weight*reps)
//            self.workoutData.append(workout)
//            self.dismiss(animated: true)
//            }
//        //OKボタンを追加
//        alert.addAction(okAction)
//
//        //Cancelボタンを生成
//        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
//        //Cancelボタンを追加
//        alert.addAction(cancelAction)
//
//        alert.addTextField { (text:UITextField!) in
//            let pickerView = UIPickerView()
//            pickerView.delegate = self
//            pickerView.dataSource = self
//            text.inputView = pickerView
//            // toolbar
//            let toolbar = UIToolbar()
//            toolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
//            let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.donePicker))
//            toolbar.setItems([doneButtonItem], animated: true)
//            text.inputAccessoryView = toolbar
//
//            text.placeholder = "メニュー"
//            text.tag = 1
//        }
//
//        alert.addTextField { (text:UITextField!) in
//            text.placeholder = "ターゲット部位"
//            text.tag = 2
//        }
//        alert.addTextField { (text:UITextField!) in
//            text.placeholder = "重量(kg)"
//            text.keyboardType = .numberPad
//            text.tag = 3
//        }
//        alert.addTextField { (text:UITextField!) in
//            text.placeholder = "レップ数"
//            text.keyboardType = .numberPad
//            text.tag = 4
//        }
//
//        present(alert, animated: true)
//    }
    

//    @objc func donePicker(tf : UITextField) {
//        tf.endEditing(true)
//        dismiss(animated: true)
//    }
    

//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        textField.endEditing(true)
//    }
    
    
}



//MARK: - UITableViewDelegate, UITableViewDataSource
extension WorkoutViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
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
        cell.targetPartLabel.text = workoutData[indexPath.section].workoutName
        cell.selectionStyle = .none
        
        cell.addLogButton.tag = indexPath.section

        cell.repsTableView.reloadData()
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


        let editAction = UIContextualAction(style: .normal, title: "編集") { (action, view, completionHandler) in
            // 編集処理を記述
            print("Editがタップされた")
            //            tableView.reloadData()
            completionHandler(true)
        }


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
        editAction.backgroundColor = UIColor.endColor
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
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
