//
//  AuthorizationManager.swift
//  StopPark
//
//  Created by Arman Turalin on 12/17/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import Foundation

struct AuthorizationManager {
    static var authorized: Bool {
        guard let _ = UserDefaultsManager.getFormData(.userName) else { return false }
        guard let _ = UserDefaultsManager.getFormData(.userSurname) else { return false }
        guard let _ = UserDefaultsManager.getFormData(.userEmail) else { return false }
        return true
    }
}
