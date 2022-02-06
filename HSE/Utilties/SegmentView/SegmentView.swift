//
//  SegmentView.swift
//  HSE
//
//  Created by Дмитрий Соколов on 12.01.2022.
//

import UIKit

protocol SegmentViewDelegate {
    /// called by segmentView when chosen segment has changed
    func segmentChosen(index: Int)
}

final class SegmentView: UIView {
    
    private var collectionView: UICollectionView?
    
    /// segmentView delegate
    public var delegate: SegmentViewDelegate?
    
    /// current segment items
    public private(set) var segmentItems: [Item] = []
    
    override var backgroundColor: UIColor? {
        didSet {
            collectionView?.backgroundColor = backgroundColor
        }
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        
        setup()
    }
    
    private func setup() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 5, right: 0)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 12
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.backgroundColor = self.backgroundColor
        
        collectionView?.register(SegmentCollectionViewCell.self, forCellWithReuseIdentifier: SegmentCollectionViewCell.reuseIdentifier)
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        
        self.addSubview(collectionView!)
        
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView?.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        collectionView?.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        collectionView?.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView?.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    override func draw(_ rect: CGRect) {
    }
    
    // worker endpoint
    // learn manager swift
    // alamofire
    
    
    // MARK: - API
    
    /// set titles in segments
    public func setTitles(titles: [String: Int?]) {
        segmentItems.removeAll()
        titles.forEach { (title, count) in
            segmentItems.append(Item(title: title, notifications: count))
        }
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
            self.collectionView?.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
        }
    }
    
    /// scroll to specified segment
    public func moveTo(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        collectionView!.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
}

// MARK: - CollectionView Delegate

extension SegmentView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.segmentChosen(index: indexPath.row)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

// MARK: - CollectionView DataSource

extension SegmentView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return segmentItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SegmentCollectionViewCell.reuseIdentifier, for: indexPath) as! SegmentCollectionViewCell
        cell.configure(item: segmentItems[indexPath.row])
        
        return cell
    }
    
}