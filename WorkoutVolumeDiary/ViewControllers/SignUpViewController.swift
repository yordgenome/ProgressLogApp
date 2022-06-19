//
//  SignUpViewController.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/05/26.
//

import FirebaseAuth
import FirebaseFirestore
import UIKit
import RxSwift
import RxCocoa

final class SignUpViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    private let viewModel = RegisterViewModel()
    
    private let gradientView = GradientView()
    
    private let productLabel = SignUpLabel(text: "Progress Log", font: UIFont(name: "DevanagariSangamMN-Bold", size: 50)!)
    private let titleLabel = SignUpLabel(text: "アカウント登録", font: UIFont(name: "DevanagariSangamMN-Bold", size: 24)!)

    private let nameLabel = SignUpLabel(text: "名前")
    private let passwordLabel = SignUpLabel(text: "パスワード")
    private let emailLabel = SignUpLabel(text: "メールアドレス")
    
    private let nameTextField = SignUptTextField(placeholder: "名前")
    private let passwordTextField = SignUptTextField(placeholder: "パスワード")
    private let emailTextField = SignUptTextField(placeholder: "メールアドレス")

    private let registerButton = SignUpButton()

    private let moveToLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("アカウントをお持ちの方はコチラ", for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    private let setButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Set", for: .normal)
        button.backgroundColor = .red
        return button
    }()
    private let getButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Get", for: .normal)
        button.backgroundColor = .red
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        setupLayout()
        setupBindings()
    }
    
    func setupLayout() {
        addSubViews()
        
        view.addSubview(setButton)
        view.addSubview(getButton)

        gradientView.frame = view.bounds
        productLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, centerX: view.centerXAnchor, width: view.bounds.width, height: 50, topPadding: 30)
        titleLabel.anchor(top: productLabel.bottomAnchor, centerX: view.centerXAnchor, width: 250, height: 30, topPadding: 30)
        nameLabel.anchor(top: titleLabel.bottomAnchor, left: nameTextField.leftAnchor, width: 150, height: 20, topPadding: 30)
        nameTextField.anchor(top: nameLabel.bottomAnchor, centerX: view.centerXAnchor, width: 250, height: 30, topPadding: 2)
        emailLabel.anchor(top: nameTextField.bottomAnchor, left: nameLabel.leftAnchor, width: 150, height: 20, topPadding: 16)
        emailTextField.anchor(top: emailLabel.bottomAnchor, centerX: view.centerXAnchor, width: 250, height: 30, topPadding: 2)
        passwordLabel.anchor(top: emailTextField.bottomAnchor, left: nameLabel.leftAnchor, width: 150, height: 20, topPadding: 16)
        passwordTextField.anchor(top: passwordLabel.bottomAnchor, centerX: view.centerXAnchor, width: 250, height: 30, topPadding: 2)
        registerButton.anchor(top: passwordTextField.bottomAnchor, centerX: view.centerXAnchor, width: 250, height: 30, topPadding: 38)
        moveToLoginButton.anchor(top: registerButton.bottomAnchor, centerX: view.centerXAnchor, width: 250, height: 30, topPadding: 50)
        
//        registerButton.addTarget(self, action: #selector(tapRegister), for: .touchUpInside)
        moveToLoginButton.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        
        setButton.anchor(bottom: view.bottomAnchor, left: view.leftAnchor, width: 150, height: 50)
        getButton.anchor(bottom: view.bottomAnchor, right: view.rightAnchor, width: 150, height: 50)

        setButton.addTarget(self, action: #selector(set), for: .touchUpInside)
        getButton.addTarget(self, action: #selector(get), for: .touchUpInside)
    }
    
    private func addSubViews(){
        view.addSubview(gradientView)
        view.addSubview(productLabel)
        view.addSubview(titleLabel)
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(registerButton)
        view.addSubview(moveToLoginButton)
    }
    
    private func setupBindings() {
        
        nameTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                self?.viewModel.nameTextInput.onNext(text ?? "")
            }
            .disposed(by: disposeBag)
        
        emailTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                self?.viewModel.emailTextInput.onNext(text ?? "")
            }
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                self?.viewModel.passwordTextInput.onNext(text ?? "")
            }
            .disposed(by: disposeBag)
        
        //buttonのbindings
        registerButton.rx.tap.asDriver().drive { [weak self] _ in
            print("registerrrr")
            //登録時の処理
            self?.createUser()
        }
        .disposed(by: disposeBag)
        
        moveToLoginButton.rx.tap.asDriver().drive { [ weak self ] _ in
            let login = LoginViewController()
            self?.navigationController?.pushViewController(login, animated: true)
        }
        .disposed(by: disposeBag)
        
        // viewModelのbinding
        viewModel.validRegisterDriver.drive { validAll in
            self.registerButton.isEnabled = validAll
            self.registerButton.backgroundColor = validAll ? .uiLightOrange?.withAlphaComponent(0.9) : .init(white: 0.7, alpha: 0.9)
        }
        .disposed(by: disposeBag)
    }
    
    private func createUser() {
        guard let emailText = emailTextField.text,
              let nameText = nameTextField.text,
              let passText = passwordTextField.text else { return }
        
        let userInfo = UserModel.init(emailString: emailText, passwordString: passText, nameString: nameText, createdAt: Timestamp(date: Date()))
        
        Auth.createUserToFireAuth(model: userInfo) { success in
            if !success {
                let dialog = UIAlertController(title: "登録できません", message: "メールアドレスまたはパスワードが無効です", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    self.dismiss(animated: true, completion: nil)
                }
                dialog.addAction(okAction)
                self.present(dialog, animated: true, completion: nil)
                print("アカウント登録に失敗")
            }
            let homeVC = HomeViewController()
            homeVC.modalPresentationStyle = .fullScreen
            self.present(homeVC, animated: true)
            print("アカウント登録に成功")
        }
        
    }
    
    
    @objc private func tapButton() {
        let homeVC = HomeViewController()
        homeVC.modalPresentationStyle = .fullScreen

        self.present(homeVC, animated: true)
    }
    
    @objc private func set() {

        let workout: [WorkoutModel] = [WorkoutModel(doneAt: Timestamp(date: Date()), targetPart: .chest, workoutName: "ベンチプレス", weight: 120, reps: 10, volume: 600),
                       WorkoutModel(doneAt: Timestamp(date: Date()), targetPart: .chest, workoutName: "ベンチプレス", weight: 120, reps: 8, volume: 600),
                       WorkoutModel(doneAt: Timestamp(date: Date()), targetPart: .chest, workoutName: "ベンチプレス", weight: 120, reps: 5, volume: 600)]

        let dateSring = DateUtils.toStringFromDate(date: Date())
        
        Firestore.setWorkoutToFirestore(dateString: dateSring, workout: workout) { success in
            if success {
                print("成功", #function)
            } else {
                print("失敗", #function)
            }
        }
    }
    
    @objc private func get() {

        let uid = Auth.auth().currentUser?.uid
        let dateString = DateUtils.toStringFromDate(date: Date())
        Firestore.fetchWorkoutFromFirestore(uid: "EzUV2ql6NgRD3lq6ckD4DdRHPH82", dateString: dateString, targetPart: .chest){ workoutArray in
            

            print(#function, workoutArray)
        }
    }

    
//    @objc private func tapRegister(_ sender: Any) {

//
//        Auth.createUserToFireAuth(model: userInfo) { result in
//            if result {
//                let homeVC = HomeViewController()
//                homeVC.modalPresentationStyle = .fullScreen
//                self.present(homeVC, animated: true)
//            }
//
//            if !result {
//                let dialog = UIAlertController(title: "登録できません", message: "メールアドレスまたはパスワードが無効です", preferredStyle: .alert)
//                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
//                    self.dismiss(animated: true, completion: nil)
//                }
//                dialog.addAction(okAction)
//                self.present(dialog, animated: true, completion: nil)
//            }
//        }
//
//    }
    
}
