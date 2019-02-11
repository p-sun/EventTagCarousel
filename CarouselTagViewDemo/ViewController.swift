//
//  ViewController.swift
//  EventTagCarousel
//
//  Created by Paige Sun on 1/21/19.
//  Copyright © 2019 Paige Sun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let singleLineCarousel = CarouselTagsView<DemoTagDataSource>()
    private let dataSource = DemoTagDataSource()
    private let addHeightButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        singleLineCarousel.backgroundColor = #colorLiteral(red: 0.515319109, green: 0.8531128764, blue: 0.2971386313, alpha: 1)
        view.addSubview(singleLineCarousel)
        singleLineCarousel.dataSource = dataSource
        singleLineCarousel.constrainLeft(to: view)
        singleLineCarousel.constrainRight(to: view)
        singleLineCarousel.constrainTop(to: view, offset: 180)

        let multilineCarousel3Lines = CarouselTagsView<DemoTagDataSource>()
        multilineCarousel3Lines.dataSource = dataSource
        multilineCarousel3Lines.backgroundColor = #colorLiteral(red: 0.6657629609, green: 0.2875884175, blue: 0.8349869251, alpha: 1)
        multilineCarousel3Lines.style = .multiLine(numberOfLines: 3)
        view.addSubview(multilineCarousel3Lines)
        multilineCarousel3Lines.constrainLeft(to: view)
        multilineCarousel3Lines.constrainRight(to: view)
        multilineCarousel3Lines.constrainTopToBottom(of: singleLineCarousel, offset: 40)

        let multilineCarouselMaxLines = CarouselTagsView<DemoTagDataSource>()
        multilineCarouselMaxLines.dataSource = dataSource
        multilineCarouselMaxLines.backgroundColor = #colorLiteral(red: 0.2624118328, green: 0.3039391637, blue: 0.8385177255, alpha: 1)
        multilineCarouselMaxLines.style = .multiLine(numberOfLines: 0)
        view.addSubview(multilineCarouselMaxLines)
        multilineCarouselMaxLines.constrainLeft(to: view)
        multilineCarouselMaxLines.constrainRight(to: view)
        multilineCarouselMaxLines.constrainTopToBottom(of: multilineCarousel3Lines, offset: 40)
        
        addHeightButton.setTitle("  Add height  ", for: .normal)
        addHeightButton.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        view.addSubview(addHeightButton)
        addHeightButton.constrainTopToTopLayoutGuide(of: self, inset: 30)
        addHeightButton.constrainCenterX(to: view)
        addHeightButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    @objc private func buttonPressed() {
        singleLineCarousel.heightConstraint.constant = singleLineCarousel.heightConstraint.constant + 10
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
}

struct DemoTag {
    let name: String
}

class DemoTagDataSource: CarouselTagsViewDataSource {
    
    typealias Cell = DemoTagCell
    typealias Item = DemoTag
    
    static func estimatedItemSize() -> CGSize {
        return CGSize(width: 100, height: 32)
    }

    func numberOfItems() -> Int {
        return 14
    }
    
    func itemAt(index: Int) -> Item {
        return DemoTag(name: titleAt(index: index))
    }
    
    func configure(cell: Cell, item: Item) {
        cell.configure(title: item.name)
    }
    
    private func titleAt(index: Int) -> String {
        return (0...index).reduce("") { (result, n) in
            return result + "\(n) "
        }
    }
}
