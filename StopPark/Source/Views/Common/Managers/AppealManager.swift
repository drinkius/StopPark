//
//  AppealManager.swift
//  StopPark
//
//  Created by Arman Turalin on 1/7/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import Foundation

class AppealManager {
    static let shared = AppealManager()
    
    var appeals: [Appeal]
    
    func saveNewAppeal(_ appeal: Appeal) {
        appeals.append(appeal)
        UserDefaultsManager.setSavedAppeals(appeals)
    }
    
    private init() {
        guard let appeals = UserDefaultsManager.getSavedAppeals() else {
            self.appeals = []
            return
        }
        self.appeals = appeals
    }
}
