//
//  AssigmentFilter.swift
//  HSETests
//
//  Created by Дмитрий Соколов on 16.04.2022.
//

import XCTest
@testable import HSE

class AssigmentFilter: XCTestCase {
    var scheduleModel: ScheduleViewModel?
    var tableView: UITableView?

    override func setUpWithError() throws {
        try super.setUpWithError()
        self.tableView = UITableView()
        if let table = self.tableView {
            self.scheduleModel = ScheduleViewModel(tableView: table, NetworkManager())
        }
    }

    override func tearDownWithError() throws {
        self.scheduleModel = nil
        self.tableView = nil
        try super.tearDownWithError()
    }
    
    func checkItemsInDataSource(contentType: DeadlineContentType) {
        if let dataSource = tableView?.dataSource as? ScheduleViewModel.TableDataSource {
            var indexPaths = [IndexPath]()
            guard let numberOfSection = tableView?.numberOfSections else { return }
            for i in 0..<numberOfSection {
                guard let numberOfRows = tableView?.numberOfRows(inSection: i) else { return }
                for j in 0..<numberOfRows {
                    indexPaths.append(IndexPath(row: j, section: i))
                }
            }
            
            indexPaths.forEach {
                let item = dataSource.itemIdentifier(for: $0)
                if let item = item as? ScheduleViewModel.Item {
                    switch item {
                    case .deadline(let deadItem):
                        let newItem = deadItem as Deadline
                        XCTAssertTrue(newItem.type.rawValue == contentType.rawValue)
                    default:
                        XCTFail("should be deadline instead of timetable")
                    }
                } else {
                    XCTFail("should be deadline instead of timetable")
                }
            }
        }
    }

    func testFilter() throws {
        scheduleModel?.contentChanged(contentType: .assigments)
        XCTAssertEqual(scheduleModel?.contentType, .assigments, "Content Should have changed")
        XCTAssertTrue(scheduleModel?.deadlineType == .all, "By default deadline type is set to all")
        
        scheduleModel?.deadLineContentChanged(.cw)
        
        XCTAssertTrue(scheduleModel?.deadlineType == .cw)
        checkItemsInDataSource(contentType: .hw)
        
        scheduleModel?.deadLineContentChanged(.hw)
        
        XCTAssertTrue(scheduleModel?.deadlineType == .hw)
        checkItemsInDataSource(contentType: .hw)
        
        scheduleModel?.deadLineContentChanged(.all)
        
        XCTAssertTrue(scheduleModel?.deadlineType == .all)
        
        scheduleModel?.deadLineContentChanged(.hw)
        scheduleModel?.contentChanged(contentType: .timeTable)
        scheduleModel?.contentChanged(contentType: .assigments)
        
        XCTAssertTrue(scheduleModel?.deadlineType == .all)
    }

}
