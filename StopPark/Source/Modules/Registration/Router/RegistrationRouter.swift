//
//  RegistrationRouter.swift
//  StopPark
//
//  Created by Arman Turalin on 2/6/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

class RegistrationRouter: RouterProtocol {
    
    weak var baseViewController: UIViewController?
    
    func present(on baseVC: UIViewController, animated: Bool, context: Any) {
        guard let context = context as? PresentationContext else {
            assertionFailure("The context type mismatch")
            return
        }
                
        baseViewController = baseVC
        
        switch context {
        case .registration:
            let vc = RegistrationVC(router: self)
            vc.destination = .registration
            vc.title = Str.Registration.titleReg
            let nav = CustomNavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                baseVC.present(nav, animated: animated)
            }
        case .profile:
            let vc = RegistrationVC(router: self)
            vc.destination = .settings
            vc.title = Str.Registration.titleProfile
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
        case .home:
            let router = HomeRouter()
            let context = HomeRouter.PresentationContext.default
            router.present(on: baseVC, animated: animated, context: context)
        }
    }
    
    func dismiss(animated: Bool) { }

}

// MARK: - Support
extension RegistrationRouter {
    enum PresentationContext {
        case registration
        case profile
    }
    
    enum RouteContext {
        case home
    }
}
