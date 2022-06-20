//
//  ViewController.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/05/26.
//

import UIKit

class HomeViewController: UIViewController {

//MARK: - Properties
let gradientView = GradientView()
let footerView = MuscleFooterView()
let headerView = MuscleHeaderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupBinding()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let signUpVC = SignUpViewController()
            let nav = UINavigationController(rootViewController: signUpVC)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
        
        
    }

    private func setupLayout() {
        view.addSubview(gradientView)
        view.addSubview(footerView)
        view.addSubview(headerView)
        gradientView.frame = view.bounds
        headerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, centerX: view.centerXAnchor, width: view.bounds.width, height: 80, topPadding: 20)
        footerView.anchor(bottom: view.bottomAnchor, centerX: view.centerXAnchor, width: view.bounds.width, height: 80)

    }
    
    private func setupBinding() {
        footerView.workoutView.button?.addTarget(self, action: #selector(workoutAction), for: .touchUpInside)
        
        
    }
    
    @objc private func workoutAction() {
        let vc = TrainingLogController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
        print(#function)    }
    
}



//MARK: - UITableViewDataSource, UITableViewDelegate
