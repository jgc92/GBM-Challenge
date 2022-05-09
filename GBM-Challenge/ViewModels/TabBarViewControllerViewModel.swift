//
//  TabBarViewControllerViewModel.swift
//  GBM-Challenge
//
//  Created by Joaquín González Cervantes on 08/05/22.
//

import Charts
import Foundation

class TabBarViewControllerViewModel {
    private let viewModelHelper = ViewModelHelper()
    
    // Execute on data change
    var refreshData = { () -> () in }
    
    var priceData: [ChartDataEntry] = [] {
        didSet {
            refreshData()
        }
    }
    var percentageChangeData: [ChartDataEntry] = [] {
        didSet {
            refreshData()
        }
    }
    var volumeData: [ChartDataEntry] = [] {
        didSet {
            refreshData()
        }
    }
    var changeData: [ChartDataEntry] = [] {
        didSet {
            refreshData()
        }
    }
    
    // Load data and call injection
    func loadData() {
        viewModelHelper.loadJson(fromURLString: "https://run.mocky.io/v3/cc4c350b-1f11-42a0-a1aa-f8593eafeb1e") { [weak self] result in
            switch result {
            case .success(let data):
                if let parsedData = self?.viewModelHelper.parse(jsonData: data) {
                    self?.updateViewModel(parsedData)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // Injection extraction
    func updateViewModel(_ data: [IPC]) {
        self.priceData = self.createData(from: data, for: .price)
        self.percentageChangeData = self.createData(from: data, for: .percentageChange)
        self.volumeData = self.createData(from: data, for: .volume)
        self.changeData = self.createData(from: data, for: .change)
    }
    
    enum chartType {
    case price, percentageChange, volume, change
    }
    
    // Create ChartDataEntry array for different charts
    private func createData(from ipcData: [IPC], for chartType: chartType) -> [ChartDataEntry] {
        var result: [ChartDataEntry] = []
        let sortedIPCData = ipcData.sorted { first, second in
            getTimeInterval(isoDate: first.date) < getTimeInterval(isoDate: second.date)
        }
        for ipc in sortedIPCData {
            let xEntry = getTimeInterval(isoDate: ipc.date)
            switch chartType {
            case .price:
                result.append(ChartDataEntry(x: xEntry, y: ipc.price))
            case .percentageChange:
                result.append(ChartDataEntry(x: xEntry, y: ipc.percentageChange))
            case .volume:
                result.append(ChartDataEntry(x: xEntry, y: ipc.volume))
            case .change:
                result.append(ChartDataEntry(x: xEntry, y: ipc.change))
            }
        }
        return result
    }

    // Format string iso date and return time interval
    private func getTimeInterval(isoDate: String) -> Double {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.date(from: isoDate) {
            let timeInterval = date.timeIntervalSince1970
            return Double(timeInterval)
        }
        return 0
    }
}
