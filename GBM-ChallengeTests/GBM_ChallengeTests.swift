//
//  GBM_ChallengeTests.swift
//  GBM-ChallengeTests
//
//  Created by Joaquín González Cervantes on 08/05/22.
//

import XCTest
@testable import GBM_Challenge

class GBM_ChallengeTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }
    
    // Test IPC array
    private func createIPCArray() -> [IPC] {
        let testIPCArray = [
            IPC(date: "2020-08-18T04:11:52.06-05:00", price: 65, percentageChange: 42, volume: 54, change: 324),
            IPC(date: "2020-08-18T04:11:52.06-05:00", price: 56, percentageChange: 789, volume: 52, change: 87),
            IPC(date: "2020-08-18T04:11:52.06-05:00", price: 645, percentageChange: 7, volume: 852, change: 78),
            IPC(date: "2020-08-18T04:11:52.06-05:00", price: 6512, percentageChange: 755, volume: 74, change: 45),
            IPC(date: "2020-08-18T04:11:52.06-05:00", price: 91, percentageChange: 25, volume: 45, change: 11),
        ]
        
        return testIPCArray
    }
    
    // Test TabBarViewControllerViewModel for no empty data
    func testTabBarViewControllerViewModel() {
        let tabBarViewControllerViewModel = TabBarViewControllerViewModel()
        let testIPCArray = createIPCArray()
        
        tabBarViewControllerViewModel.updateViewModel(testIPCArray)
        
        XCTAssertFalse(tabBarViewControllerViewModel.priceData == [])
        XCTAssertFalse(tabBarViewControllerViewModel.percentageChangeData == [])
        XCTAssertFalse(tabBarViewControllerViewModel.volumeData == [])
        XCTAssertFalse(tabBarViewControllerViewModel.changeData == [])
    }
    
    // Test ListViewControllerViewModel for no empty data
    func testListViewControllerViewModel() {
        let listViewControllerViewModel = ListViewControllerViewModel()
        let testIPCArray = createIPCArray()

        listViewControllerViewModel.updateViewModel(testIPCArray)

        XCTAssertFalse(listViewControllerViewModel.ipcArray.isEmpty)
    }
    
    // Test ViewModelHelper date formatter
    func testViewModelHelperGetFormattedDate() {
        let viewModelHelper = ViewModelHelper()
        let isoDateString = "2020-08-18T00:02:43.91-05:00"
        let formattedDateString = viewModelHelper.getFormattedDate(isoDate: isoDateString)
        let expectedDateString = "Date: August-18-2020   Time: 0:2:43"
        
        XCTAssertEqual(expectedDateString, formattedDateString)
    }
}
