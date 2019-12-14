//
//  Form.swift
//  StopPark
//
//  Created by Arman Turalin on 12/15/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import Foundation

class Form {
    
    var data: [Section] = []
    
    private let toSomeone = [Cell(name: .district),
                             Cell(name: .subDivision),
                             Cell(name: .rang),
                             Cell(name: .policeName)]
    private let userData = [Cell(name: .userName),
                            Cell(name: .userSurname),
                            Cell(name: .userFatherName),
                            Cell(name: .userOrganizationName),
                            Cell(name: .userNumberLetter),
                            Cell(name: .userOrganizationDate),
                            Cell(name: .userNumberLetter)]
    private let userContactInformation = [Cell(name: .userEmail),
                                          Cell(name: .userPhone),
                                          Cell(name: .eventPlace)]
    
    private func fillForm() {
        let toSomeoneSection = Section(name: "Куда адресовано", cells: toSomeone)
        let atUserSection = Section(name: "Заявитель", cells: userData)
        let responceAddressSection = Section(name: "Адрес для ответа", cells: userContactInformation)
        
        data = [toSomeoneSection, atUserSection, responceAddressSection]
    }
    
    init() {
        fillForm()
    }
}
