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
    let onboardingContainerViewController = OnboardingContainerViewController()
    let tabBarViewController = TabBarViewController()
    let listViewController = ListViewController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        
        // Set list view as a navigation
        let listViewControllerNavigation = UINavigationController(rootViewController: listViewController)
        
        // Set delegates
        loginViewController.delegate = self
        loginFallbackViewController.delegate = self
        listViewController.delegate = self
        onboardingContainerViewController.delegate = self
        
        // Inject LAContext
        loginViewController.localAuthenticationContext = localAuthenticationContext
        tabBarViewController.localAuthenticationContext = localAuthenticationContext
        
        // Inject navigation views to tab bar view
        tabBarViewController.loginViewController = loginViewController
        tabBarViewController.loginFallbackViewController = loginFallbackViewController
        tabBarViewController.listViewControllerNavigation = listViewControllerNavigation
        
        // Set login by biometric availability
        switch localAuthenticationContext.biometricType {
        case .faceID:
            window?.rootViewController = loginViewController
        case .touchID:
            window?.rootViewController = loginViewController
        case .none:
            window?.rootViewController = loginFallbackViewController
        }
        
        return true
    }
}

extension AppDelegate: LoginViewControllerDelegate {
    func didLoginWithLA() {
        if LocalState.hasOnboarded {
            setRootViewController(tabBarViewController)
        } else {
            setRootViewController(onboardingContainerViewController)
        }    }
    
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
        if LocalState.hasOnboarded {
            setRootViewController(tabBarViewController)
        } else {
            setRootViewController(onboardingContainerViewController)
        }
    }
}

extension AppDelegate: ListViewControllerDelegate {
    func ListViewControllerBackButtonDidTapped() {
        setRootViewController(tabBarViewController)
    }
}

extension AppDelegate: OnboardingContainerViewControllerDelegate {
    func didFinishOnboarding() {
        LocalState.hasOnboarded = true
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

