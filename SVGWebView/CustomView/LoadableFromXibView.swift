//
//  LoadableFromXibView.swift
//  EDSDK
//
//  Created by eru-thanhtv on 10/22/19.
//  Copyright © 2019 EstRouge Inc. All rights reserved.
//

import UIKit

open class LoadableFromXibView: UIView {
    
    @IBOutlet public weak var view: UIView!
    
    private(set) var xibName: String = ""
    
    // MARK: - Inits
    override public init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }

    // MARK: - Setup
    func xibSetup() {
        let nib = UINib(nibName: xibName, bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            fatalError("Could not find a xib file in bundle")
        }
        self.view = view
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["view": view]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["view": view]))
    }
}

