//
//  TabBarViewController.swift
//  GBM-Challenge
//
//  Created by Joaquín González Cervantes on 08/05/22.
//

import UIKit

// Main TabBar view to showcase charts.
class TabBarViewController: UITabBarController {
    lazy var viewModel = TabBarViewControllerViewModel()
    var listViewControllerNavigation: UINavigationController?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadData()
        viewModel.refreshData = { () in
            DispatchQueue.main.async { [weak self] in
                self?.setup()
            }
        }
    }
    
    private func setup() {
        // Create all chart views.
        let priceChartViewController = ChartViewController()
        let percentageChangeChartViewController = ChartViewController()
        let volumeChartViewController = ChartViewController()
        let changeChartViewController = ChartViewController()
        
        // Set view models
        priceChartViewController.data = viewModel.priceData
        percentageChangeChartViewController.data = viewModel.percentageChangeData
        volumeChartViewController.data = viewModel.volumeData
        changeChartViewController.data = viewModel.changeData
        
        // Set delegation
        priceChartViewController.delegate = self
        percentageChangeChartViewController.delegate = self
        volumeChartViewController.delegate = self
        changeChartViewController.delegate = self
        
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

extension TabBarViewController: ChartViewControllerDelegate {
    func chartDidLogout() {
        // TODO
    }
    
    func goToList() {
        view.window?.rootViewController = self.listViewControllerNavigation
    }
}
