//
//  HSETests.swift
//  HSETests
//
//  Created by Дмитрий Соколов on 11.01.2022.
//

import XCTest
@testable import HSE

class HSETests: XCTestCase {
    var schViewModel: ScheduleViewModel!
    var tableVIew = UITableView()

    override func setUpWithError() throws {
        try super.setUpWithError()
        schViewModel = ScheduleViewModel(tableView: tableVIew)
    }

    override func tearDownWithError() throws {
        schViewModel = nil
        try super.tearDownWithError()
    }

    func testSortingDeadlines() throws {
        let closure = {
            let deadlinesCW = self.schViewModel.currentdeadlines
            deadlinesCW.forEach {
                $0.assignments.forEach {
                    XCTAssertEqual($0.type, .cw, "Assignment type not matching cw")
                }
            }
        }
        schViewModel.contentChanged(contentType: .assigments)
        schViewModel.bindScheduleViewModelToController = closure
        schViewModel.deadLineContentChanged(.hw)
        
    }

}
