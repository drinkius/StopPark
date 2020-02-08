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
        UIView.animate(withDuration: 0.2, animations: {
            self.titleLabel?.alpha = 1.0
            self.imageView?.alpha = 1.0
            self.indicator.alpha = 0
        }, completion: { _ in
            self.indicator.alpha = 1.0
            self.indicator.isHidden = true
            self.isEnabled = true
        })
    }
    
    public func startAnimating() {
        indicator.alpha = 0
        indicator.isHidden = false
        self.isEnabled = false
        UIView.animate(withDuration: 0.2, animations: {
            self.titleLabel?.alpha = 0
            self.imageView?.alpha = 0
            self.indicator.alpha = 1.0
        })
    }
            
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        startAnimating()
    }
}
