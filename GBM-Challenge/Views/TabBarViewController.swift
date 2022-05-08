//
//  TabBarViewController.swift
//  GBM-Challenge
//
//  Created by Joaquín González Cervantes on 08/05/22.
//

import UIKit

class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        let priceChartViewController = UIViewController()
        let percentageChangeChartViewController = UIViewController()
        let volumeChartViewController = UIViewController()
        let changeChartViewController = UIViewController()
        
        priceChartViewController.title = "Price vs Time"
        percentageChangeChartViewController.title = "Percentage Change vs Time"
        volumeChartViewController.title = "Volume vs Time"
        changeChartViewController.title = "Change vs Time"
                
        let priceTab = UINavigationController(rootViewController: priceChartViewController)
        let percentageChangeTab = UINavigationController(rootViewController: percentageChangeChartViewController)
        let volumeTab = UINavigationController(rootViewController: volumeChartViewController)
        let changeTab = UINavigationController(rootViewController: changeChartViewController)
        
        priceTab.title = "Price"
        priceTab.navigationBar.isTranslucent = false

        percentageChangeTab.title = "Percentage Change"
        percentageChangeTab.navigationBar.isTranslucent = false

        
        volumeTab.title = "Volume"
        volumeTab.navigationBar.isTranslucent = false

        changeTab.title = "Change"
        changeTab.navigationBar.isTranslucent = false

        setViewControllers([priceTab, percentageChangeTab, volumeTab, changeTab], animated: false)
        tabBar.isTranslucent = false
        
        guard let items = tabBar.items else { return }
        let icons = ["dollarsign.square", "chart.line.uptrend.xyaxis", "v.square", "chart.xyaxis.line"]
        for i in 0..<items.count {
            items[i].image = UIImage(systemName: icons[i])
        }
    }
}
