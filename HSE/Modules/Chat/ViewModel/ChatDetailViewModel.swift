//
//  ChatDetailViewModel.swift
//  HSE
//
//  Created by Дмитрий Соколов on 25.05.2022.
//
import UIKit

fileprivate let fakeUsers: [UserReference] = [
    UserReference(id: 3, name: "Gregory Sosnovsky", role: .professor),
    UserReference(id: 4, name: "Sergey Shershakov", role: .professor),
    UserReference(id: 5, name: "Random Name", role: .assist),
    UserReference(id: 0, name: "Dmitrii Sokolov"),
    UserReference(id: 1, name: "Danila Kokin"),
    UserReference(id: 2, name: "Steve George")
]

final class ChatDetailViewModel: NSObject {
    typealias TableDataSource = UITableViewDiffableDataSource<AnyHashable, Item>

    private let tableView: UITableView
    private var sectionIdentifiers = [AnyHashable]()
    private var chatParticipants = [UserReference]() {
        didSet {
            self.updateDataSource()
        }
    }
    public var isLoading: Bool = false {
        didSet {
            if(isLoading) {
                setShimmer()
            }
        }
    }
    
    enum Item: Hashable {
        case header(ChatDetail)
        case user(UserReference)
        case loading(UUID)

        static var loadingItems: [Item] {
            return Array(repeatingExpression: Item.loading(UUID()), count: 8)
        }
    }
    
    // MARK: - Data Source
    public lazy var dataSource = TableDataSource(
        tableView: tableView
    ) { tableView, indexPath, itemIdentifier in
        switch itemIdentifier {
        case .header(let details):
            let cell = tableView.dequeueReusableCell(withIdentifier: ChatDetailHeaderTableViewCell.reuseIdentifier, for: indexPath)
            if let cell = cell as? ChatDetailHeaderTableViewCell {
                cell.configure(chatName: details.name, details.numberOfParticipants)
            }
            
            return cell
        case .user(let userR):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ChatDetailTableViewCell.reuseIdentifier,
                for: indexPath
            )
            if let cell = cell as? ChatDetailTableViewCell {
                cell.configure(name: userR.name)
            }
            
            return cell
        case .loading(_):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ChatDetailTableViewCell.reuseIdentifier,
                for: indexPath
            )
            return cell
        }
    }

    // MARK: - Init
    init(_ tableView: UITableView) {
        self.tableView = tableView
        super.init()
        self.tableView.dataSource = dataSource
        self.tableView.delegate = self
        self.chatParticipants = fakeUsers
        updateDataSource()
    }

    private func updateDataSource() {
        let sectionIdentifiers: Set<UserType>
        var itemBySection = [AnyHashable: [Item]]()
        sectionIdentifiers = Set(chatParticipants.map { $0.role })
        self.sectionIdentifiers = Array(sectionIdentifiers.sorted(by: { $0.rawValue > $1.rawValue }))
        chatParticipants.forEach {
            if (itemBySection[$0.role] != nil) {
                itemBySection[$0.role]?.append(Item.user($0))
            } else {
                itemBySection[$0.role] = [Item.user($0)]
            }
        }
        self.sectionIdentifiers.insert("Header", at: 0)
        itemBySection["Header"] = [Item.header(ChatDetail(
            name: "Professors,Students",
            numberOfParticipants: chatParticipants.count,
            image: nil
        ))]

        dataSource.applySnapshotUsing(
            sectionIDs: self.sectionIdentifiers,
            itemBySection: itemBySection,
            animatingDifferences: false
        )
    }

    // MARK: - Shimmer
    private func setShimmer() {}
}

// MARK: - Table Delegate
extension ChatDetailViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        headerView.backgroundColor = .background.style(.firstLevel)()

        let label = UILabel()
        label.frame = CGRect(x: 16, y: 0, width: headerView.frame.width, height: 15)
        label.font = .customFont.style(.special)()
        label.textColor = .textAndIcons.style(.tretiary)()

        if isLoading == false {
            if(section == 0) {
                return nil
            } else {
                if let section = sectionIdentifiers[section] as? UserType {
                    switch section {
                    case .professor:
                        label.text = "Professors"
                    case .assist:
                        label.text = "Tas"
                    case .student:
                        label.text = "Students"
                    }
                }
            }
        } else {
            label.text = ""
        }
        headerView.addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16).isActive = true

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 30
    }
}
