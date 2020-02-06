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
            let vc = RegistrationVC()
            vc.destination = .registration
            vc.title = "Регистрация"
            let nav = CustomNavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                baseVC.present(nav, animated: animated)
            }
        case .profile:
            let vc = RegistrationVC()
            vc.destination = .settings
            vc.title = "Ваш профиль"
            let nav = CustomNavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                baseVC.present(nav, animated: animated)
            }
        }
    }
    
    func enqueueRoute(with context: Any, animated: Bool) { }
    
    func dismiss(animated: Bool) { }

}

// MARK: - Support
extension RegistrationRouter {
    enum PresentationContext {
        case registration
        case profile
    }
    
    enum RouteContext {
    }
}
