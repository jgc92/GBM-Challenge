//
//  TabBarViewController.swift
//  GBM-Challenge
//
//  Created by Joaquín González Cervantes on 08/05/22.
//

import UIKit

// Main TabBar view to showcase charts.
class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        // Create all chart views.
        let priceChartViewController = UIViewController()
        let percentageChangeChartViewController = UIViewController()
        let volumeChartViewController = UIViewController()
        let changeChartViewController = UIViewController()
        
        // Set navigation title.
        priceChartViewController.title = "Price vs Time"
        percentageChangeChartViewController.title = "Percentage Change vs Time"
        volumeChartViewController.title = "Volume vs Time"
        changeChartViewController.title = "Change vs Time"
                
        // Create navigations for charts.
        let priceTab = UINavigationController(rootViewController: priceChartViewController)
        let percentageChangeTab = UINavigationController(rootViewController: percentageChangeChartViewController)
        let volumeTab = UINavigationController(rootViewController: volumeChartViewController)
        let changeTab = UINavigationController(rootViewController: changeChartViewController)
        
        priceTab.title = "Price"  // Set tab bar title.
        priceTab.navigationBar.isTranslucent = false  // Set navigation translucent flag.

        percentageChangeTab.title = "Percentage Change"
        percentageChangeTab.navigationBar.isTranslucent = false

        
        volumeTab.title = "Volume"
        volumeTab.navigationBar.isTranslucent = false

        changeTab.title = "Change"
        changeTab.navigationBar.isTranslucent = false

        // Add navigations to tab bar.
        setViewControllers([priceTab, percentageChangeTab, volumeTab, changeTab], animated: false)
        tabBar.isTranslucent = false  // Set tab bar translucent flag.
        
        // Add tab bar icons.
        guard let items = tabBar.items else { return }
        let icons = ["dollarsign.square", "chart.line.uptrend.xyaxis", "v.square", "chart.xyaxis.line"]
        for i in 0..<items.count {
            items[i].image = UIImage(systemName: icons[i])
        }
    }
}
