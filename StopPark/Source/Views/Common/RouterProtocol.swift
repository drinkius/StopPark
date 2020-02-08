//
//  RouterProtocol.swift
//  StopPark
//
//  Created by Arman Turalin on 2/6/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

protocol RouterProtocol: class {
    var baseViewController: UIViewController? { get set }
    
    func present(on baseViewController: UIViewController, animated: Bool, context: Any)
    func enqueueRoute(with context: Any, animated: Bool)
    func dismiss(animated: Bool)
}

extension RouterProtocol {
    func present(on baseViewController: UIViewController, context: Any) {
        present(on: baseViewController, animated: true, context: context)
    }
    
    func enqueueRoute(with context: Any) {
        enqueueRoute(with: context, animated: true)
    }
    
    func dismiss() {
        dismiss(animated: true)
    }
}
