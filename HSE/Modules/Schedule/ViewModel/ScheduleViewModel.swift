//
//  ScheduleDayViewModel.swift
//  HSE
//
//  Created by Дмитрий Соколов on 15.01.2022.
//

import Foundation

//no backend => logic not clear so far

enum ContentType {
    case timeTable
    case assigments
}

class ScheduleViewModel: NSObject {
    private var networkManager: NetworkManager!
    private var contentType: ContentType = .timeTable {
        didSet {
            updateData()
        }
    }
    
    public private(set) var schedule = [ScheduleDay]() {
        didSet {
            self.bindScheduleViewModelToController()
        }
    }
    public private(set) var deadlines = [DeadlineDay]() {
        didSet {
            self.bindScheduleViewModelToController()
        }
    }
    
    public var bindScheduleViewModelToController: () -> () = {}
    
    override init() {
        super.init()
        
        networkManager = NetworkManager()
        fetchSchedule()
        fetchDeadline()
    }
    
    private func fetchSchedule() {
        networkManager.getSchedule { schedule, error in
            if let error = error {
                print(error)
            }
            if let schedule = schedule {
                self.schedule = schedule
            }
        }
    }
    
    private func fetchDeadline() {
        networkManager.getDeadline { deadlines, error in
            if let error = error{
                print(error)
            }
            if let deadlines = deadlines {
                self.deadlines = deadlines
            }
        }
    }
    // MARK: - Internal calls
    
    public func updateData() {
        if contentType == .timeTable {
            fetchSchedule()
        } else {
            fetchDeadline()
        }
    }
    
    public func contentChanged(contentType: ContentType) {
        self.contentType = contentType
    }
}
