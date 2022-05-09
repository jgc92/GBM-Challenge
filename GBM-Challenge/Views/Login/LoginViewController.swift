//
//  LoginViewController.swift
//  GBM-Challenge
//
//  Created by Joaquín González Cervantes on 08/05/22.
//

import Foundation

import UIKit
import LocalAuthentication

protocol LoginViewControllerDelegate: AnyObject {
    func didLoginWithLA()
    func didFallback()
}

class LoginViewController: UIViewController {
    
    weak var delegate: LoginViewControllerDelegate?
    weak var localAuthenticationContext: LAContext?
    
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
        authButton.addTarget(self, action: #selector(authenticationWithLA), for: .primaryActionTriggered)
        
        guard let localAuthenticationContext = localAuthenticationContext else {
            return UIButton()
        }

        switch localAuthenticationContext.biometricType {
        case .faceID:
            authButton.setTitle("Face ID", for: [])
            authButton.setImage(UIImage(systemName: "faceid"), for: [])
        case .touchID:
            authButton.setTitle("Touch ID", for: [])
            authButton.setImage(UIImage(systemName: "touchid"), for: [])
        default:
            authButton.setTitle("Login", for: .normal)
        }

        return authButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
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

// Local Authentication helpers
extension LoginViewController {
    @objc func authenticationWithLA() {
        guard let localAuthenticationContext = localAuthenticationContext else { return }
        localAuthenticationContext.localizedFallbackTitle = "Use Passcode"

        var authError: NSError?
        let reasonString = "To access the secure data"

        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {

            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString) { [weak self] success, evaluateError in

                if success {
                    // LA success
                    DispatchQueue.main.async {
                        self?.delegate?.didLoginWithLA()
                    }
                } else {
                    guard let error = evaluateError else {
                        return
                    }
                    print(self?.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code) ?? "")

                    // Fallback with password.
                    DispatchQueue.main.async {
                        self?.delegate?.didFallback()
                    }
                }
            }
        } else {

            guard let error = authError else {
                return
            }
            print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error.code))
        }
    }

    func evaluatePolicyFailErrorMessageForLA(errorCode: Int) -> String {
        var message = ""
        if #available(iOS 11.0, macOS 10.13, *) {
            switch errorCode {
            case LAError.biometryNotAvailable.rawValue:
                message = "Authentication could not start because the device does not support biometric authentication."

            case LAError.biometryLockout.rawValue:
                message = "Authentication could not continue because the user has been locked out of biometric authentication, due to failing authentication too many times."

            case LAError.biometryNotEnrolled.rawValue:
                message = "Authentication could not start because the user has not enrolled in biometric authentication."

            default:
                message = "Did not find error code on LAError object"
            }
        } else {
            switch errorCode {
            case LAError.touchIDLockout.rawValue:
                message = "Too many failed attempts."

            case LAError.touchIDNotAvailable.rawValue:
                message = "TouchID is not available on the device"

            case LAError.touchIDNotEnrolled.rawValue:
                message = "TouchID is not enrolled on the device"

            default:
                message = "Did not find error code on LAError object"
            }
        }

        return message
    }

    func evaluateAuthenticationPolicyMessageForLA(errorCode: Int) -> String {

        var message = ""

        switch errorCode {

        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"

        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"

        case LAError.invalidContext.rawValue:
            message = "The context is invalid"

        case LAError.notInteractive.rawValue:
            message = "Not interactive"

        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"

        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"

        case LAError.userCancel.rawValue:
            message = "The user did cancel"

        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"

        default:
            message = evaluatePolicyFailErrorMessageForLA(errorCode: errorCode)
        }

        return message
    }
}
