//
//  ScheduleDayViewModel.swift
//  HSE
//
//  Created by Дмитрий Соколов on 15.01.2022.
//

import Foundation

//no backend => logic not clear so far

class ScheduleViewModel: NSObject {
    
    private var networkManager: NetworkManager!
    
    public private(set) var Schedule: [ScheduleDay]! {
        didSet {
            self.bindScheduleViewModelToController()
        }
    }
    
    public var bindScheduleViewModelToController: () -> () = {}
    
    override init() {
        super.init()
        
        networkManager = NetworkManager()
        fetchSchedule()
    }
    
    private func fetchSchedule() {
        self.Schedule = ScheduleDay.days
    }
}
