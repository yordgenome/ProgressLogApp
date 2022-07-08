//
//  ViewController.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/05/26.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import RxSwift
import RxCocoa
import PKHUD

class HomeViewController: UIViewController {

    //MARK: - Properties
    let gradientView = GradientView()
    let footerView = MuscleFooterView()
    
    var user: User?
    let today = Date()

    let disposeBag = DisposeBag()
    
    let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .blue
        button.setTitle("logout", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupLayout()
        setupBinding()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser?.uid == nil {
            let signUpVC = SignUpViewController()
            let nav = UINavigationController(rootViewController: signUpVC)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        } else {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            Firestore.firestore().collection("users").document(uid).getDocument(completion: { document, error in
                if let document = document {
                    let name = document.data()!["name"] as! String
                    let email = document.data()!["email"] as! String
                    let createdAt = document.data()!["createdAt"] as! Timestamp

                    self.user = User(id: uid, name: name, email: email, createdAt: createdAt)
                    print("ユーザー情報の取得に成功", self.user as Any)
                }
                if error != nil {
                    print("ユーザー情報の取得に失敗", error as Any)
                }
            })
        }
    }
    
    private func setupLayout() {
        view.addSubview(gradientView)
        view.addSubview(footerView)
        view.addSubview(logoutButton)
        gradientView.frame = view.bounds
        footerView.anchor(bottom: view.bottomAnchor, centerX: view.centerXAnchor, width: view.bounds.width, height: 80)
        logoutButton.anchor(bottom: footerView.topAnchor, right: view.rightAnchor, width: 100, height: 50)
    }
    
    private func setupBinding() {
        
        footerView.boostView.button?.rx.tap.asDriver().drive(onNext: { [weak self] in
            let regiWorkoutVC = RegisterWorkoutMenuController()
            regiWorkoutVC.modalPresentationStyle = .fullScreen
            self?.present(regiWorkoutVC, animated: true)
        }).disposed(by: disposeBag)
        
        footerView.workoutView.button?.rx.tap.asDriver().drive { [ weak self ] _ in
            let workoutVC = WorkoutViewController()
            workoutVC.modalPresentationStyle = .fullScreen
            self?.present(workoutVC, animated: true)
        }
        .disposed(by: disposeBag)

        
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
    }
    
    @objc private func logout() {
        do {
            try Auth.auth().signOut()
            let signUpVC = SignUpViewController()
            let nav = UINavigationController(rootViewController: signUpVC)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        } catch {
            print("ログアウトに失敗", error)
        }
    }
}





//MARK: - UITableViewDataSource, UITableViewDelegate
