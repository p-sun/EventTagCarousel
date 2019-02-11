//
//  CarouselTagsView.swift
//  EventTagCarousel
//
//  Created by Paige Sun on 1/21/19.
//  Copyright © 2019 Paige Sun. All rights reserved.
//

import UIKit

protocol CarouselTagsViewDataSource: class {
    
    associatedtype Item
    associatedtype Cell: UICollectionViewCell
    
    static func estimatedItemSize() -> CGSize
    
    func numberOfItems() -> Int
    
    func itemAt(index: Int) -> Item
    
    func configure(cell: Cell, item: Item)
}

class CarouselTagsView<DataSource: CarouselTagsViewDataSource>: UIView, UICollectionViewDataSource {

    enum Style {
        case singleLine
        case multiLine(numberOfLines: Int)
    }

    weak var dataSource: DataSource?
    
    var style: Style = .singleLine {
        didSet {
            switch style {
            case .singleLine:
                collectionView.collectionViewLayout = singleLineLayout()
                collectionView.isScrollEnabled = true
            case .multiLine(let numberOfLines):
                collectionView.collectionViewLayout = multilineLayout(numberOfLines: numberOfLines)
                collectionView.isScrollEnabled = false
            }
            collectionView.reloadData()
        }
    }
    
    var heightConstraint: NSLayoutConstraint!
    
    private let cellReuseIdentifier = "CarouselTagCell"
    
    private func multilineLayout(numberOfLines: Int) -> UICollectionViewFlowLayout {
        let layout = LeftAlignedCollectionViewFlowLayout(maxNumberOfLines: numberOfLines)
        layout.cellHeightAwareFlowLayoutDelegate = self
        layout.estimatedItemSize = DataSource.estimatedItemSize()
        return layout
    }
    
    private func singleLineLayout() -> UICollectionViewFlowLayout {
        let layout = SingleLineCollectionViewFlowLayout()
        layout.cellHeightAwareFlowLayoutDelegate = self
        layout.estimatedItemSize = DataSource.estimatedItemSize()
        
        // We cannot change the minimumInteritemSpacing from default's 10 b/c
        // https://github.com/lionheart/openradar-mirror/issues/20861
        return layout
    }
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 200, height: 400), collectionViewLayout: singleLineLayout())
        heightConstraint = collection.heightAnchor.constraint(equalToConstant: 1000)
        heightConstraint.isActive = true
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])

        collectionView.register(DataSource.Cell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let numberOfItems = dataSource?.numberOfItems() ?? 0
        
        heightConstraint.isActive = numberOfItems > 0
        
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let dataSource = dataSource else {
            return UICollectionViewCell()
        }
        
        let item = dataSource.itemAt(index:indexPath.row)
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? DataSource.Cell {
            dataSource.configure(cell: cell, item: item)
            return cell
        }
        
        return UICollectionViewCell()
    }
}

extension CarouselTagsView: CellHeightAwareFlowLayoutDelegate {
    fileprivate func flowLayoutDidUpdateCellHeight(_ flowLayout: UICollectionViewFlowLayout, maxHeight: CGFloat) {
        heightConstraint.constant = maxHeight
    }
}

private protocol CellHeightAwareFlowLayoutDelegate: class {
    func flowLayoutDidUpdateCellHeight(_ flowLayout: UICollectionViewFlowLayout, maxHeight: CGFloat)
}

private class SingleLineCollectionViewFlowLayout: UICollectionViewFlowLayout {

    private var returnedCellHeight: CGFloat? {
        didSet {
            if oldValue != returnedCellHeight, let maxHeight = returnedCellHeight {
                cellHeightAwareFlowLayoutDelegate?.flowLayoutDidUpdateCellHeight(self, maxHeight: maxHeight + 1)
            }
        }
    }
    
    fileprivate weak var cellHeightAwareFlowLayoutDelegate: CellHeightAwareFlowLayoutDelegate?
    
    override init() {
        super.init()
        scrollDirection = .horizontal
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        returnedCellHeight = attributes?.first?.frame.height
        return attributes
    }
}

private class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    private let maxNumberOfLines: Int
    
    private var cache = [UICollectionViewLayoutAttributes]()
    fileprivate weak var cellHeightAwareFlowLayoutDelegate: CellHeightAwareFlowLayoutDelegate?
    
    required init(maxNumberOfLines: Int) {
        self.maxNumberOfLines = maxNumberOfLines

        super.init()
        
        minimumInteritemSpacing = 6
        minimumLineSpacing = 6
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        cache = []
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        if !cache.isEmpty {
            var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
            
            for attributes in cache {
                if attributes.frame.intersects(rect) {
                    visibleLayoutAttributes.append(attributes)
                }
            }
            
            return visibleLayoutAttributes
        }

        // Recreate Layout
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var lineNumber = 0
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        var didReturnHeight = false
        attributes?.forEach { layoutAttribute in
            
            // If THIS item is on the next row, reset its leftMargin
            if layoutAttribute.frame.origin.y >= maxY {
                lineNumber += 1
                let shouldLimitNumberOfLines = maxNumberOfLines != 0
                if shouldLimitNumberOfLines && lineNumber == maxNumberOfLines + 1 {
                    cellHeightAwareFlowLayoutDelegate?.flowLayoutDidUpdateCellHeight(self, maxHeight: maxY)
                    didReturnHeight = true
                }
                leftMargin = sectionInset.left
            }
            // Get the maxY for all items
            maxY = max(layoutAttribute.frame.maxY, maxY)
            
            // Set THIS item's origin.x to leftMargin. Note that the original origin.y is unchanged.
            layoutAttribute.frame.origin.x = leftMargin
            
            // Calculate NEXT item's leftMargin by adding this item's width
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
        }
        
        if !didReturnHeight {
            cellHeightAwareFlowLayoutDelegate?.flowLayoutDidUpdateCellHeight(self, maxHeight: maxY)
        }
        
        if let attributes = attributes {
            cache = attributes
        }
        return attributes
    }
}
