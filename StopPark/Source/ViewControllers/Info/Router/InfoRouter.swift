//
//  InfoRouter.swift
//  StopPark
//
//  Created by Arman Turalin on 2/6/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

class InfoRouter: RouterProtocol {
    
    weak var baseViewController: UIViewController?
    
    // MARK: - Methods
    func present(on baseVC: UIViewController, animated: Bool, context: Any) {
        guard let context = context as? PresentationContext else {
            assertionFailure("The context type mismatch")
            return
        }
        
        guard let navigationController = baseVC.navigationController else {
            assertionFailure("Navigation controller is not set")
            return
        }
                
        switch context {
        case .default:
            let vc = InfoVC()
            vc.title = Str.Info.title
            DispatchQueue.main.async {
                navigationController.pushViewController(vc, animated: animated)
            }
        }
    }
    
    func enqueueRoute(with context: Any, animated: Bool) { }
    
    func dismiss(animated: Bool) { }

}

// MARK: - Support
extension InfoRouter {
    enum PresentationContext {
        case `default`
    }
    
    enum RouteContext {
    }
}
