//
//  AppDelegate.swift
//  GBM-Challenge
//
//  Created by Joaquín González Cervantes on 08/05/22.
//

import UIKit
import LocalAuthentication

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let localAuthenticationContext = LAContext()
    
    let loginViewController = LoginViewController()
    let loginFallbackViewController = LoginFallbackViewController()
    let tabBarViewController = TabBarViewController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        
        // Set delegates
        loginViewController.delegate = self
        loginFallbackViewController.delegate = self
        
        // Inject LAContext
        loginViewController.localAuthenticationContext = localAuthenticationContext
        
        window?.rootViewController = loginViewController
        
        return true
    }
}

extension AppDelegate: LoginViewControllerDelegate {
    func didLoginWithLA() {
        setRootViewController(tabBarViewController)
    }
    
    func didFallback() {
        loginFallbackViewController.isBackButtonVisible = true
        setRootViewController(loginFallbackViewController)
    }
}

extension AppDelegate: LoginFallbackViewControllerDelegate {
    func backButton() {
        setRootViewController(loginViewController)
    }
    
    func didLogin() {
        setRootViewController(tabBarViewController)
    }
}

// Set root view controller with animation
extension AppDelegate {
    func setRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard animated, let window = self.window else {
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
            return
        }
        
        window.rootViewController = vc
        window.makeKeyAndVisible()
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
        
    }
}

