//
//  LoginFallbackViewController.swift
//  GBM-Challenge
//
//  Created by Joaquín González Cervantes on 08/05/22.
//

import UIKit

protocol LoginFallbackViewControllerDelegate: AnyObject {
    func backButton()
    func didLogin()
}

class LoginFallbackViewController: UIViewController {
    weak var delegate: LoginFallbackViewControllerDelegate?

    var isBackButtonVisible = false
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Go back", for: [])
        button.setTitleColor(UIColor.systemBlue, for: [])
        button.addTarget(self, action: #selector(backButtonDidTapped), for: .primaryActionTriggered)
        
        return button
    }()
    
    lazy var loginFallbackView = LoginFallbackView()
    lazy var signInButton: UIButton = {
        let signInButton = UIButton(type: .system)
        
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.configuration = .filled()
        signInButton.configuration?.imagePadding = 8
        signInButton.setTitle("Sign In", for: [])
        signInButton.addTarget(self, action: #selector(signInTapped), for: .primaryActionTriggered)
        
        return signInButton
    }()
    
    let errorMessageLabel: UILabel = {
        let errorMessageLabel = UILabel()
        
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        errorMessageLabel.textAlignment = .center
        errorMessageLabel.textColor = .systemRed
        errorMessageLabel.numberOfLines = 0
        errorMessageLabel.isHidden = true
        
        return errorMessageLabel
    }()
        
    var username: String? {
        return loginFallbackView.usernameTextField.text
    }
    
    var password: String? {
        return loginFallbackView.passwordTextField.text
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginFallbackView.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray
        
        if !isBackButtonVisible {
            backButton.isHidden = true
        }
        
        setup()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        signInButton.configuration?.showsActivityIndicator = false
    }
    
    private func setup() {
        view.addSubview(backButton)
        view.addSubview(loginFallbackView)
        view.addSubview(signInButton)
        view.addSubview(errorMessageLabel)
        
        // Back Button
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            backButton.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1)
        ])

        // LoginView
        NSLayoutConstraint.activate([
            loginFallbackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginFallbackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: loginFallbackView.trailingAnchor, multiplier: 1)
        ])
        
        // Button
        NSLayoutConstraint.activate([
            signInButton.topAnchor.constraint(equalToSystemSpacingBelow: loginFallbackView.bottomAnchor, multiplier: 2),
            signInButton.leadingAnchor.constraint(equalTo: loginFallbackView.leadingAnchor),
            signInButton.trailingAnchor.constraint(equalTo: loginFallbackView.trailingAnchor)
        ])
        
        // Error Message
        NSLayoutConstraint.activate([
            errorMessageLabel.topAnchor.constraint(equalToSystemSpacingBelow: signInButton.bottomAnchor, multiplier: 2),
            errorMessageLabel.leadingAnchor.constraint(equalTo: loginFallbackView.leadingAnchor),
            errorMessageLabel.trailingAnchor.constraint(equalTo: loginFallbackView.trailingAnchor)
        ])
    }
}

extension LoginFallbackViewController {
    @objc func backButtonDidTapped(sender: UIButton) {
        delegate?.backButton()
    }
    
    @objc func signInTapped(sender: UIButton) {
        errorMessageLabel.isHidden = true
        login()
    }
    
    private func login() {
        guard let username = username, let password = password else {
            assertionFailure("Username / password should never be nil")
            return
        }
        
        if username == "" && password == "" {
            signInButton.configuration?.showsActivityIndicator = true
            delegate?.didLogin()
        } else {
            configureView(withMessage: "Incorrect username / password")
        }
    }
    
    private func configureView(withMessage message: String) {
        errorMessageLabel.isHidden = false
        errorMessageLabel.text = message
    }
}
