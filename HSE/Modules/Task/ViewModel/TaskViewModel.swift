//
//  TaskViewModel.swift
//  HSE
//
//  Created by Дмитрий Соколов on 07.02.2022.
//

import Foundation
import UIKit


final class TaskViewModel {
    typealias TableDataSource = UITableViewDiffableDataSource<AnyHashable, AnyHashable>
    
    private var networkManager = NetworkManager()
    private var collectionView: UICollectionView
    public var task: StudentTask? {
        didSet {
            
        }
    }
    
    // MARK: - DataSource
    
    
    // MARK: - Init
    init(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
        fetchTask()
    }
    
    
    // MARK: - API
    private func fetchTask() {
        
    }
}
