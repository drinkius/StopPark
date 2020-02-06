//
//  PayRouter.swift
//  StopPark
//
//  Created by Arman Turalin on 2/6/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

class PayRouter: RouterProtocol {
    
    weak var baseViewController: UIViewController?
    
    // MARK: - Methods
    func present(on baseVC: UIViewController, animated: Bool, context: Any) {
        guard let context = context as? PresentationContext else {
            assertionFailure("The context type mismatch")
            return
        }
                
        switch context {
        case .pay:
            let presenter = PayPresenter()
            presenter.destination = .pay
            let vc = PayVC(with: presenter)
            vc.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                baseVC.present(vc, animated: animated)
            }
        case .donate:
            let presenter = PayPresenter()
            presenter.destination = .donate
            let vc = PayVC(with: presenter)
            vc.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                baseVC.present(vc, animated: animated)
            }
        }
    }
    
    func enqueueRoute(with context: Any, animated: Bool) { }
    
    func dismiss(animated: Bool) { }

}

// MARK: - Support
extension PayRouter {
    enum PresentationContext {
        case pay
        case donate
    }
    
    enum RouteContext {
    }
}
