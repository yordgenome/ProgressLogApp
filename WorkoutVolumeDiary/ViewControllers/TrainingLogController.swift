//
//  TrainingLogController.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/06/01.
//

import UIKit



final class TrainingLogController: UIViewController {
    
//MARK: - Properties
//    private var workoutMenu = WorkoutMenuModel()
    
    let gradientView = GradientView()
    
    private let footerView = MuscleFooterView()

    var workoutMenu = ["腕立て伏せ",
                       "ベンチプレス",
                       "懸垂",
                       "スクワット",
                       "アームカール",
                       "ショルダープレス"
    ]
    
    var workoutData: [WorkoutModel] = [
//        WorkoutModel(dateString: DateUtils.toStringFromDate(date: Date()), workoutName: "腕立て", targetPart: .chest,sets: [WeightAndReps(weight: 1, reps: 30), WeightAndReps(weight: 1, reps: 20), WeightAndReps(weight: 1, reps: 20)]),
//        WorkoutModel(dateString: "2022年06月12日", workoutName: "懸垂", targetPart: .back, sets: [WeightAndReps(weight: 1, reps: 10), WeightAndReps(weight: 1, reps: 10)]),
//        WorkoutModel(dateString: "2022年06月12日", workoutName: "スクワット", targetPart: .leg, sets: [WeightAndReps(weight: 120, reps: 5), WeightAndReps(weight: 120, reps: 5), WeightAndReps(weight: 120, reps: 5), WeightAndReps(weight: 120, reps: 5), WeightAndReps(weight: 120, reps: 5)])
    ]
    
    var items = [String]()
    
    private let headerView = TrainingLogHeaderView()
    
    private let muscleHeaderView = MuscleHeaderView()
        
    private let trainingLogTableView: UITableView = {
        let tv = UITableView.init(frame: .zero, style: .grouped)
        tv.register(TrainingLogTableViewCell.self, forCellReuseIdentifier: TrainingLogTableViewCell.identifier)
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
    }
    
    private func setupLayout() {
        view.addSubview(gradientView)
        view.addSubview(headerView)
        view.addSubview(trainingLogTableView)
        view.addSubview(muscleHeaderView)
        view.addSubview(footerView)
        
        gradientView.frame = view.bounds
        headerView.anchor(top: view.topAnchor, centerX: view.centerXAnchor, width: view.frame.width+4, height: 100)
        muscleHeaderView.anchor(top: headerView.bottomAnchor , left: view.leftAnchor, width: view.bounds.width, height: 60)

        trainingLogTableView.anchor(top: muscleHeaderView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, width: view.bounds.width-20, height: view.bounds.height-50, topPadding: 20, leftPadding: 10, rightPadding:  10)
        footerView.anchor(bottom: view.bottomAnchor, centerX: view.centerXAnchor, width: view.bounds.width, height: 80)
        
        headerView.nextDayButton.addTarget(self, action: #selector(test), for: .touchUpInside)
        
    }
    
    @objc func test() {
        let alert = UIAlertController(title: "トレーニングを記録", message: "テキストを入力せよ", preferredStyle: .alert)
        

        
        //OKボタンを生成
        let okAction = UIAlertAction(title: "登録", style: .default) { (action:UIAlertAction) in
            //複数のtextFieldのテキストを格納
//            guard let textFields:[UITextField] = alert.textFields else {return}
            //textからテキストを取り出していく
//            for textField in textFields {
//                switch textField.tag {
//                    case 1: self.label.text = textField.text
//                    case 2: self.label2.text = textField.text
//                    default: break
//                }
//            }
        }
        //OKボタンを追加
        alert.addAction(okAction)
        
        //Cancelボタンを生成
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        //Cancelボタンを追加
        alert.addAction(cancelAction)

        alert.addTextField { (text:UITextField!) in
            let pickerView = UIPickerView()
            pickerView.delegate = self
            pickerView.dataSource = self
            text.inputView = pickerView
            // toolbar
            let toolbar = UIToolbar()
            toolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
            let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.donePicker))
            toolbar.setItems([doneButtonItem], animated: true)
            text.inputAccessoryView = toolbar
            
            text.placeholder = "メニュー"
            //１つ目のtextFieldのタグ
            text.tag = 1
        }
        alert.addTextField { (text:UITextField!) in
            text.placeholder = "ターゲット部位"
            //2つ目のtextFieldのタグ
            text.tag = 2
        }
        alert.addTextField { (text:UITextField!) in
            text.placeholder = "重量(kg)"
            //１つ目のtextFieldのタグ
            text.tag = 3
        }
        alert.addTextField { (text:UITextField!) in
            text.placeholder = "レップ数"
            //2つ目のtextFieldのタグ
            text.tag = 4
        }
        alert.addTextField { (text:UITextField!) in
            text.placeholder = "セット数"
            //１つ目のtextFieldのタグ
            text.tag = 5
        }
        //アラートを表示
        present(alert, animated: true)
    }
    

    @objc func donePicker(tf : UITextField) {
        tf.endEditing(true)
    }
    

//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        textField.endEditing(true)
//    }
    
    
}



//MARK: - UITableViewDelegate, UITableViewDataSource
extension TrainingLogController: UITableViewDelegate, UITableViewDataSource {
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: TrainingLogTableViewCell.identifier, for: indexPath) as! TrainingLogTableViewCell
        cell.menuLabel.text = workoutData[indexPath.section].workoutName
        cell.targetPartLabel.text = workoutData[indexPath.section].workoutName
        cell.selectionStyle = .none
        
        cell.addLogButton.tag = indexPath.section
        cell.addLogButton.addTarget(self, action: #selector(registerWeightReps), for: .touchUpInside)

        cell.repsTableView.reloadData()
        return cell
    }
    
    @objc func registerWeightReps(_ sender: UIButton) {
        let alert = UIAlertController(title: "トレーニングを記録", message: "数値を入力してください", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "登録", style: .default) { (action:UIAlertAction) in
            
//            let weightRepsData = WeightAndReps(weight: Double(alert.textFields![1].text!) ?? 1 , reps: Double(alert.textFields![2].text!) ?? 1)
//            self.workoutData[sender.tag].sets.append(weightRepsData)
            alert.dismiss(animated: true)
        }
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        alert.addTextField { (text:UITextField!) in
            text.keyboardType = .numberPad
            text.placeholder = "重量(kg)"
            text.tag = 1
        }
        
        alert.addTextField { (text:UITextField!) in
            text.keyboardType = .numberPad
            text.placeholder = "レップ数"
            text.tag = 2
        }
        
        present(alert, animated: true, completion: nil)
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
extension TrainingLogController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return workoutMenu.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return workoutMenu[row]
    }


    
}
