//
//  TaskViewModel.swift
//  HSE
//
//  Created by Дмитрий Соколов on 07.02.2022.
//

import Foundation


enum TimeViewType {
    case publication, deadline, submission
}

struct TimeView: Hashable {
    let id = UUID()
    let type: TimeViewType
    let date: String
    let time: String
}

struct TaskDescription: Hashable {
    let id = UUID()
    let courseName: String
    let taskName: String
    let description: String
}

struct TaskCreator: Hashable {
    let id = UUID()
    let owner: String
}

struct File: Hashable {
    let id = UUID()
    let name: String
}

class TaskViewModel: Equatable  {
    static func == (lhs: TaskViewModel, rhs: TaskViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id = UUID()
    let description: TaskDescription
    let creator: TaskCreator
    let publication: TimeView
    let deadLine: TimeView
    let submission: TimeView?
    let taskFiles: [File]
    let submissionFiles: [File]
    
    init() {
        publication = TimeView(type: .publication, date: "22.07.22", time: "14:59")
        deadLine = TimeView(type: .deadline, date: "22.07.22", time: "14:59")
        description = TaskDescription(courseName: "MACHIENE LEARNING", taskName: "HW:14 VENUS ANUS", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
        creator = TaskCreator(owner: "Oleg Melnikov")
        submission = nil
        taskFiles = [File(name: "hw-14-venus-Mars.pdf"), File(name: "photoDataset2014.csv")]
        submissionFiles = [File(name: "dummy"), File(name: "hw-13-venus-Mars.pdf"), File(name: "phot1Dataset2014.csv")]
    }
    
}
