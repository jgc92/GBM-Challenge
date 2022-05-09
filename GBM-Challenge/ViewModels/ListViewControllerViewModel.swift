//
//  ListViewControllerViewModel.swift
//  GBM-Challenge
//
//  Created by Joaquín González Cervantes on 08/05/22.
//

import Foundation

class ListViewControllerViewModel {
    private let viewModelHelper = ViewModelHelper()
    var refreshData = { () -> () in }
    
    var ipcArray: [IPC] = [] {
        didSet {
            refreshData()
        }
    }
    
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
    
    func updateViewModel(_ data: [IPC]) {
        self.ipcArray = data
    }
}
