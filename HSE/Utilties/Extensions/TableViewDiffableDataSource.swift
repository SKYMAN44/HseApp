//
//  TableViewDiffableDataSource.swift
//  HSE
//
//  Created by Дмитрий Соколов on 12.02.2022.
//

import Foundation
import UIKit


extension UITableViewDiffableDataSource {
    func applySnapshotUsing(sectionIDs: [SectionIdentifierType],
                            itemBySection: [SectionIdentifierType: [ItemIdentifierType]],
                            sectionRetainedIfEmpty: Set<SectionIdentifierType> = Set<SectionIdentifierType>()) {
        applySnapshotUsing(sectionIDs: sectionIDs,
                           itemBySection: itemBySection,
                           animatingDifferences: true,
                           sectionRetainedIfEmpty: sectionRetainedIfEmpty)
        
    }
    
    func applySnapshotUsing(sectionIDs: [SectionIdentifierType],
                            itemBySection: [SectionIdentifierType: [ItemIdentifierType]],
                            animatingDifferences: Bool,
                            sectionRetainedIfEmpty: Set<SectionIdentifierType> = Set<SectionIdentifierType>()) {
        var snapshot = NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>()
        
        for sectionID in sectionIDs {
            guard let sectionItems = itemBySection[sectionID],
                  sectionItems.count > 0 || sectionRetainedIfEmpty.contains(sectionID) else { continue }
            snapshot.appendSections([sectionID])
            snapshot.appendItems(sectionItems, toSection: sectionID)
            snapshot.reloadItems(sectionItems)
        }
        
        self.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
