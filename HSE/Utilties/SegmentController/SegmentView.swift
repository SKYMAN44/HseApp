//
//  SegmentView.swift
//  HSE
//
//  Created by Дмитрий Соколов on 12.01.2022.
//

import UIKit

protocol SegmentViewDelegate {
    func segmentChosen(index: Int)
}

class SegmentView: UIView {
    
    var collectionView: UICollectionView?
    
    var delegate: SegmentViewDelegate?
    
    var titles: [String] = []
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    func setUp() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 5, right: 36)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 12
        
        collectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        collectionView?.backgroundColor = self.backgroundColor
        
        collectionView?.register(SegmentCollectionViewCell.self, forCellWithReuseIdentifier: SegmentCollectionViewCell.reuseIdentifier)
        collectionView?.register(UINib(nibName: "SegmentCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: SegmentCollectionViewCell.reuseIdentifier)
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        collectionView?.showsHorizontalScrollIndicator = false
        
        self.addSubview(collectionView!)
        
        setTitles(titles: ["sfsf","ss","sgffff","ffff"])
    }
    
    public func setTitles(titles: [String]) {
        self.titles = titles
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    public func moveTo(index: Int) {
        
    }
    
    

}

extension SegmentView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.segmentChosen(index: indexPath.row)
    }
}


extension SegmentView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SegmentCollectionViewCell.reuseIdentifier, for: indexPath) as! SegmentCollectionViewCell
        cell.configure(title: titles[indexPath.row])
        return cell
    }
    
    
    
}
