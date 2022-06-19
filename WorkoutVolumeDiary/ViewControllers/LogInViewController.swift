//
//  LogInViewController.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/05/26.
//

import FirebaseAuth
import FirebaseFirestore
import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    private let viewModel = RegisterViewModel()
    
    private let gradientView = GradientView()
    
    private let productLabel = SignUpLabel(text: "Progress Log", font: UIFont(name: "DevanagariSangamMN-Bold", size: 50)!)
    private let titleLabel = SignUpLabel(text: "ログイン", font: UIFont(name: "DevanagariSangamMN-Bold", size: 24)!)

    private let nameLabel = SignUpLabel(text: "名前")
    private let passwordLabel = SignUpLabel(text: "パスワード")
    private let emailLabel = SignUpLabel(text: "メールアドレス")
    
    private let nameTextField = SignUptTextField(placeholder: "名前")
    private let passwordTextField = SignUptTextField(placeholder: "パスワード")
    private let emailTextField = SignUptTextField(placeholder: "メールアドレス")

    private let registerButton = SignUpButton()

    private let moveToSignUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("アカウントをお持ちでない方はコチラ", for: .normal)
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
        moveToSignUpButton.anchor(top: registerButton.bottomAnchor, centerX: view.centerXAnchor, width: 250, height: 30, topPadding: 50)
        
//        registerButton.addTarget(self, action: #selector(tapRegister), for: .touchUpInside)
//        moveToLoginButton.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        
        setButton.anchor(bottom: view.bottomAnchor, left: view.leftAnchor, width: 150, height: 50)
        getButton.anchor(bottom: view.bottomAnchor, right: view.rightAnchor, width: 150, height: 50)

//        setButton.addTarget(self, action: #selector(set), for: .touchUpInside)
//        getButton.addTarget(self, action: #selector(get), for: .touchUpInside)
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
        view.addSubview(moveToSignUpButton)
    }
}
