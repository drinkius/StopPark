//
//  FormRouter.swift
//  StopPark
//
//  Created by Arman Turalin on 2/6/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

class FormRouter: RouterProtocol {
    
    weak var baseViewController: UIViewController?
    
    func present(on baseVC: UIViewController, animated: Bool, context: Any) {
        guard let context = context as? PresentationContext else {
            assertionFailure("The context type mismatch")
            return
        }
                        
        switch context {
        case .default:
            let vc = FormVC(router: self)
            let nav = CustomNavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                baseVC.present(nav, animated: animated)
            }
        }
    }
    
    func enqueueRoute(with context: Any, animated: Bool) {
        guard let routeContext = context as? RouteContext else {
            assertionFailure("The route type mismatch")
            return
        }
        
        guard let baseVC = baseViewController else {
            assertionFailure("baseViewController is not set")
            return
        }
        
        switch routeContext {
        case .pay:
            let router = PayRouter()
            let context = PayRouter.PresentationContext.pay
            router.present(on: baseVC, animated: animated, context: context)
        case let .edit(message, actionBlock):
            let router = EditorRouter()
            let context = EditorRouter.PresentationContext.default(message: message, actionBlock: actionBlock)
            router.present(on: baseVC, animated: animated, context: context)
        }
    }
    
    func dismiss(animated: Bool) { }

}

// MARK: - Support
extension FormRouter {
    enum PresentationContext {
        case `default`
    }
    
    enum RouteContext {
        case pay
        case edit(message: String, actionBlock: ((String?) -> Void)?)
    }
}
