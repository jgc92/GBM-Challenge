//
//  LoginViewController.swift
//  GBM-Challenge
//
//  Created by Joaquín González Cervantes on 08/05/22.
//

import Foundation

import UIKit

class LoginViewController: UIViewController {
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.contentMode = .scaleToFill
        
        let image = UIImage(named: "GBM-logo")
        let targetSize = CGSize(width: 300, height: 150)
        let scaledImage = image?.scalePreservingAspectRatio(
            targetSize: targetSize
        )
        logoImageView.image = scaledImage
                
        return logoImageView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 32

        return stackView
    }()

    lazy var signInLabel: UILabel = {
        let signInLabel = UILabel()

        signInLabel.translatesAutoresizingMaskIntoConstraints = false
        signInLabel.text = "Sign In"
        signInLabel.textAlignment = .center

        return signInLabel
    }()

    lazy var authButton: UIButton = {
        let authButton = UIButton(type: .system)

        authButton.translatesAutoresizingMaskIntoConstraints = false
        authButton.configuration = .filled()
        authButton.configuration?.imagePadding = 8
        authButton.setTitle("Face ID", for: [])

        return authButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        
        stackView.addArrangedSubview(signInLabel)
        stackView.addArrangedSubview(authButton)
        
        view.addSubview(logoImageView)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -50)
        ])

        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 1)
        ])
    }
}
