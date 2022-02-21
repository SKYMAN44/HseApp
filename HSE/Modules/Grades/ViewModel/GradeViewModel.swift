//
//  GradeViewModel.swift
//  HSE
//
//  Created by Дмитрий Соколов on 14.02.2022.
//

import Foundation
import UIKit

class GradeViewModel: NSObject {
    private var networkManager: NetworkManager!
    public var isLoading: Bool = false {
        didSet {
            if(isLoading) {
                setShimmer()
            }
        }
    }
    private weak var tableView: UITableView?
    public private(set) var grades = [Grade]() {
        didSet {
           updateDataSource()
        }
    }
    
    
    // MARK: - DataSource
    public lazy var datasource = UITableViewDiffableDataSource<AnyHashable,Item>(tableView: tableView!) {
        tableView, indexPath, itemIdentifier in
        
        switch itemIdentifier {
        case .grade(let grade):
            let cell = tableView.dequeueReusableCell(withIdentifier: GradeTableViewCell.reuseIdentifier, for: indexPath) as! GradeTableViewCell
            cell.selectionStyle = .none
            cell.configure(grade: grade)
            
            return cell
        case .loading(_):
            let cell = tableView.dequeueReusableCell(withIdentifier: GradeTableViewCell.shimmerReuseIdentifier, for: indexPath) as! GradeTableViewCell
            cell.selectionStyle = .none
            cell.configureShimmer()
            
            return cell
        }
    }

    public var bindGradeViewModelToController: () -> Void = {}
    
    enum Item: Hashable {
        case grade(Grade)
        case loading(UUID)
    
        static var loadingItems: [Item] {
            return Array(repeatingExpression: Item.loading(UUID()), count: 12)
        }
    }

    // MARK: - Init
    init(tableView: UITableView) {
        super.init()
        
        self.tableView = tableView
        tableView.dataSource = datasource
        networkManager = NetworkManager()
        updateData()
    }
    
    // MARK: - Data Source update
    private func updateDataSource() {
        var itemBySection = [String: [Item]]()
        itemBySection["s"] = grades.map {
            Item.grade($0)
        }
        datasource.applySnapshotUsing(sectionIDs: ["s"], itemBySection: itemBySection, animatingDifferences: false)
    }
    
    // MARK: - API Calls
    private func fetchGrades() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.isLoading = false
            self.grades = [Grade(id: 1, number: 1, name: "234232", grade: 10),Grade(id: 2, number: 1, name: "234232", grade: 10),Grade(id: 3, number: 1, name: "234232", grade: 10)]
        }
    }
    
    // MARK: - Shimmer
    private func setShimmer() {
        datasource.applySnapshotUsing(sectionIDs: [""], itemBySection: ["":Item.loadingItems], animatingDifferences: false)
    }
    
    // MARK: - Internal call
    public func updateData() {
        isLoading = true
        fetchGrades()
    }
}
