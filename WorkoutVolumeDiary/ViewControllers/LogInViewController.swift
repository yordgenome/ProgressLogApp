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
    private let viewModel = LoginViewModel()
    
    private let gradientView = GradientView()
    
    private let productLabel = SignUpLabel(text: "ログイン", font: UIFont(name: "DevanagariSangamMN-Bold", size: 36)!)

    private let passwordLabel = SignUpLabel(text: "パスワード")
    private let emailLabel = SignUpLabel(text: "メールアドレス")
    
    private let emailTextField = SignUptTextField(placeholder: "メールアドレス", tag: 0, returnKeyType: .next)
    private let passwordTextField = SignUptTextField(placeholder: "パスワード", tag: 1, returnKeyType: .done)

    private let loginButton = SignUpButton(text: "ログイン")

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
        
        emailTextField.delegate = self
        passwordTextField.delegate = self

        setupLayout()
        setupBindings()
    }
    
    func setupLayout() {
        addSubViews()
        
        view.addSubview(setButton)
        view.addSubview(getButton)

        gradientView.frame = view.bounds
        productLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, centerX: view.centerXAnchor, width: view.bounds.width, height: 50, topPadding: 30)
        emailLabel.anchor(top: productLabel.bottomAnchor, left: emailTextField.leftAnchor, width: 150, height: 20, topPadding: 30)
        emailTextField.anchor(top: emailLabel.bottomAnchor, centerX: view.centerXAnchor, width: 250, height: 30, topPadding: 2)
        passwordLabel.anchor(top: emailTextField.bottomAnchor, left: emailLabel.leftAnchor, width: 150, height: 20, topPadding: 16)
        passwordTextField.anchor(top: passwordLabel.bottomAnchor, centerX: view.centerXAnchor, width: 250, height: 30, topPadding: 2)
        loginButton.anchor(top: passwordTextField.bottomAnchor, centerX: view.centerXAnchor, width: 250, height: 30, topPadding: 38)
        moveToSignUpButton.anchor(top: loginButton.bottomAnchor, centerX: view.centerXAnchor, width: 250, height: 30, topPadding: 50)
    }
    
    private func addSubViews(){
        view.addSubview(gradientView)
        view.addSubview(productLabel)
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(moveToSignUpButton)
    }

    private func setupBindings() {
        
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
        
        loginButton.rx.tap.asDriver().drive { [weak self] _ in
            self?.gradientView.backgroundColor = .gray
            print("registerrrr")

        }
        .disposed(by: disposeBag)
        
        moveToSignUpButton.rx.tap.asDriver().drive { [ weak self ] _ in
            let signUp  = SignUpViewController()
            self?.navigationController?.pushViewController(signUp, animated: true)
        }
        .disposed(by: disposeBag)
        
        viewModel.validLoginDriver.drive { validAll in
            self.loginButton.isEnabled = validAll
            self.loginButton.backgroundColor = validAll ? .uiLightOrange?.withAlphaComponent(0.9) : .init(white: 0.9, alpha: 0.9)
        }
        .disposed(by: disposeBag)
    }
    
    private func loginWithFireAuth() {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        Auth.loginWithFireAuth(email: email, password: password) { success in
            if success {
                print("ログインに成功")
                
                let homeVC = HomeViewController()
                homeVC.modalPresentationStyle = .fullScreen
                self.present(homeVC, animated: true)
            } else {
                print("ログインに失敗")
            }
            
        }
        
        
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            passwordTextField.becomeFirstResponder()
        case 1:
            passwordTextField.resignFirstResponder()
        default:
            break
        }
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        
    }

}
