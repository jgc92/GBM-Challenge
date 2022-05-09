//
//  ChartViewController.swift
//  GBM-Challenge
//
//  Created by Joaquín González Cervantes on 08/05/22.
//

import Charts
import UIKit

protocol ChartViewControllerDelegate: AnyObject {
    func chartDidLogout()
    func goToList()
}

class ChartViewController: UIViewController {
    // Chart data
    var data: [ChartDataEntry]? = nil
    
    weak var delegate: ChartViewControllerDelegate?
            
    // Chart view config
    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()

        let yAxis = chartView.leftAxis
        yAxis.drawAxisLineEnabled = false
        
        let xAxis = chartView.xAxis
        xAxis.enabled = false

        chartView.backgroundColor = .secondarySystemBackground
        chartView.rightAxis.enabled = false
        chartView.legend.enabled = false
        chartView.noDataText = "Loading ..."
        chartView.noDataFont = UIFont.systemFont(ofSize: 30)
        
        chartView.animate(xAxisDuration: 1)
                
        return chartView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        if let data = data {
            loadChart(with: data)
        }
    }
    
    private func setup() {
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lineChartView)

        NSLayoutConstraint.activate([
            lineChartView.topAnchor.constraint(equalTo: view.topAnchor),
            lineChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: lineChartView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: lineChartView.bottomAnchor)
        ])
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonDidTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Go to List", style: .plain, target: self, action: #selector(listButtonDidTapped))
    }
    
    // Create data set and data for chart
    private func loadChart(with entries: [ChartDataEntry]) {
        let dataSet = LineChartDataSet(entries: entries)

        dataSet.mode = .cubicBezier
        dataSet.drawCirclesEnabled = false
        dataSet.drawValuesEnabled = false
        dataSet.lineWidth = 3
        dataSet.setColor(.systemTeal)
        dataSet.fillAlpha = 0.8
        dataSet.drawFilledEnabled = true
        
        let chartData = LineChartData(dataSet: dataSet)
        lineChartView.data = chartData
    }
}

extension ChartViewController {
    @objc func logoutButtonDidTapped() {
        delegate?.chartDidLogout()
    }

    @objc func listButtonDidTapped() {
        delegate?.goToList()
    }
}
