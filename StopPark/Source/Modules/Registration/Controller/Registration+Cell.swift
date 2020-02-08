//
//  Registration+Cell.swift
//  StopPark
//
//  Created by Arman Turalin on 2/6/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

extension RegistrationVC: TextFieldCellDelegate {
    func cell(_ cell: TextFieldCell, formData data: FormData?, didChangedTo text: String?) {
        guard let data = data else { return }
        
        guard let text = text, !text.isEmpty else {
            UserDefaultsManager.setFormData(data, data: nil)
            return
        }

        if data == .userEmail {
            let email = text.lowercased()
            UserDefaultsManager.setFormData(data, data: email)
            return
        }

        UserDefaultsManager.setFormData(data, data: text)
    }
}
