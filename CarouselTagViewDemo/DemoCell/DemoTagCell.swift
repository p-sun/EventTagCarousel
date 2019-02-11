//
//  DemoTagCell.swift
//  EventTagCarousel
//
//  Created by Paige Sun on 1/22/19.
//  Copyright © 2019 Paige Sun. All rights reserved.
//

import UIKit

class DemoTagCell: UICollectionViewCell {
    
    private let tagView = DemoTagView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(tagView)
        tagView.constrainEdges(to: self)
    }
    
    func configure(title: String) {
        tagView.configure(title: title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
