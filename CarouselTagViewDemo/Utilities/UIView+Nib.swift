//
//  UIView+Nib.swift
//  FunHub
//
//  Created by Paige Sun on 12/19/18.
//

import UIKit

protocol NibLoadable {
}

extension NibLoadable where Self: UIView {
    
    static var nibName: String {
        return String(describing: self)
    }

    static var nib: UINib?  {
        return UINib(nibName: nibName, bundle: nil)
    }
    
    func constrainNibToSelf() {
        guard let nibView = loadViewFromNib() else {
            return
        }
        
        nibView.frame = self.bounds
        nibView.translatesAutoresizingMaskIntoConstraints = false
        nibView.backgroundColor = UIColor.clear
        addSubview(nibView)
        
        nibView.constrainEdges(to: self)
    }
    
    private func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        return bundle.loadNibNamed(Self.nibName, owner: self, options: nil)?.first as? UIView
    }
}
