//
//  DemoTagView.swift
//  EventTagCarousel
//
//  Created by Paige Sun on 1/21/19.
//  Copyright © 2019 Paige Sun. All rights reserved.
//

import UIKit

class DemoTagView: UIView {

    @IBOutlet private weak var tagImageView: UIImageView!
    @IBOutlet private weak var tagLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func configure(title: String) {
        tagLabel.text = title
    }
    
    private func setup() {
        constrainNibToSelf()

        tagLabel.textColor = .white
        backgroundColor = #colorLiteral(red: 0, green: 0.8226858974, blue: 0.7789805532, alpha: 1)
        
        tagImageView.contentMode = .scaleAspectFit
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.height / 2
    }
}

extension DemoTagView: NibLoadable  { }
