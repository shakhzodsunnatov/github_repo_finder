//
//  ViewController.swift
//  github_test
//
//  Created by Shokhzod on 07/07/22.
//

import UIKit
import SnapKit
import Lottie

class IntroViewController: UIViewController {
    
    private lazy var animationView: AnimationView = {
        let animation = AnimationView(name: "github-octocat")
        
        animation.contentMode = .scaleAspectFit
        
        return animation
    }()
    
    private lazy var authButton: Button = {
        let button = Button()
        button.title = "Sign In"
        button.color = .blue
        button.addTarget(self, action: #selector(authBtnAction))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Repo Finder"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.backgroundColor = .white
        
        view.addSubview(authButton)
        view.addSubview(animationView)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationView.play()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        authButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }
        
        animationView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(authButton.snp.top).inset(-40)
        }
        
        authButton.layer.cornerRadius = authButton.frame.size.height/2
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        animationView.pause()
    }

    @objc
    func authBtnAction() {
        let vc = AuthViewController()
        vc.completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success: success)
            }
        }
        vc.navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleSignIn(success: Bool) {
        guard success else {
            let alert = UIAlertController(
                title: "Oops",
                message: "SomeThing went wrong when siging in..",
                preferredStyle: .alert)
            present(alert, animated: true)
            return
        }
        
        let vc = MainViewController()
//        vc.modalPresentationStyle = .fullScreen
//        present(vc, animated: true)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

