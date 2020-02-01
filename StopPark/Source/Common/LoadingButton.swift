//
//  LoadingButton.swift
//  StopPark
//
//  Created by Arman Turalin on 2/1/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

class LoadingButton: UIButton {
    
    private lazy var indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .white
        view.startAnimating()
        view.alpha = 0.0
        addSubview(view)
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        indicator.center = .init(x: frame.size.width / 2, y: frame.size.height / 2)
    }
    
    public var isAnimating: Bool {
        return indicator.alpha == 1.0
    }
    
    public func stopAnimating() {
        changeStatus(animated: true)
    }
            
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        changeStatus(animated: true)
    }
    
    
    private func changeStatus(animated: Bool) {
        var alpha: CGFloat = 0.0
        var reversedAlpha: CGFloat = 1.0
        isEnabled = false
        indicator.isHidden = false
        
        if isAnimating {
            alpha = 0.0
            reversedAlpha = 1.0
            isEnabled = true
            indicator.isHidden = true
        }
        
        if animated {
            UIView.animate(withDuration: 0.2) {
                self.titleLabel?.alpha = alpha
                self.imageView?.alpha = alpha
                self.indicator.alpha = reversedAlpha
            }
        } else {
            titleLabel?.alpha = alpha
            imageView?.alpha = alpha
            indicator.alpha = reversedAlpha
        }
        
    }
}
