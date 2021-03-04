//
//  PriceMarkerView.swift
//  SVGInteraction
//
//  Created by Trương Văn Kiên on 4/22/20.
//  Copyright © 2020 Prefeex. All rights reserved.
//

import UIKit

private extension UIColor {
    static var markerStrokeColor = UIColor(red: 0.565, green: 0.306, blue: 0.725, alpha: 1)
}

class PriceMarkerView: MarkerView {
    struct Constant {
        static let priceMarkerViewBaseFrame = CGRect(origin: .zero, size: CGSize(width: 83, height: 31))
    }
    
    convenience init(arrowPosition: MarkerView.ArrowPosition) {
        let isTopOrBottom = arrowPosition == .bottom || arrowPosition == .top
        self.init(frame: isTopOrBottom ? CGRect.priceMarkerBottomViewFrame : CGRect.priceMarkerLeftViewFrame)
        triangleWidth = isTopOrBottom ? CGFloat.triangleWidthForTopOrBottom : CGFloat.triangleWidthForLeftOrRight
        self.arrowPosition = arrowPosition
    }
    
    override var arrowPosition: MarkerView.ArrowPosition {
        didSet {
            guard arrowPosition != oldValue else { return }
            setNeedsDisplay()
            layoutLabel()
        }
    }
    
    @IBOutlet private weak var labelCenterYConstraint: NSLayoutConstraint!
    @IBOutlet private weak var labelCenterXConstraint: NSLayoutConstraint!
    @IBOutlet private weak var priceLabel: UILabel!
    
    var didTapMarker: (() -> Void)?
    
    override var xibName: String {
        return "PriceMarkerView"
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        guard let _superView = self.superview else {
            return super.point(inside: point, with: event)
        }
        let superViewPoint = convert(point, to: _superView)
        return super.point(inside: superViewPoint, with: event)
        
    }

    override func xibSetup() {
        super.xibSetup()
        lineColor = UIColor.markerStrokeColor
        priceLabel.textColor = UIColor.markerStrokeColor
        layoutLabel()
    }
    
    @IBAction private func didTapMarkerView(_ sender: Any) {
        self.didTapMarker?()
    }
    
    private func layoutLabel() {
        switch arrowPosition {
        case .bottom:
            labelCenterYConstraint.constant = -triangleHeight / 2
            labelCenterXConstraint.constant = 0
        case .top:
            labelCenterYConstraint.constant = triangleHeight / 2
            labelCenterXConstraint.constant = 0
        case .left:
            labelCenterYConstraint.constant = 0
            labelCenterXConstraint.constant = triangleWidth / 2 - 5
        case .right:
            labelCenterYConstraint.constant = 0
            labelCenterXConstraint.constant = -triangleWidth / 2 + 5
        }
        layoutIfNeeded()
    }
    
    func updatePrice(price: String) {
        priceLabel.text = "\(price)"
    }
}

private extension CGRect {
    static let priceMarkerBottomViewFrame = CGRect(origin: .zero, size: CGSize(width: 83, height: 39))
    static let priceMarkerLeftViewFrame = CGRect(origin: .zero, size: CGSize(width: 91, height: 31))
}

private extension CGFloat {
    static let triangleWidthForTopOrBottom: CGFloat = 18
    static let triangleWidthForLeftOrRight: CGFloat = 15
}
