//
//  Form.swift
//  StopPark
//
//  Created by Arman Turalin on 12/15/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import Foundation

class Form {
    enum Destination {
        case registrationUser
        case registrationOrganization
        case requestToServer
    }

    public var data: [Section] = []
    
    public func updateData(for destination: Destination) {
        fillForm(destination)
    }
    
    private let toSomeone = [Cell(name: .district),
                             Cell(name: .subDivision),
                             Cell(name: .rang),
                             Cell(name: .policeName)]
    private let userData = [Cell(name: .userName),
                            Cell(name: .userSurname),
                            Cell(name: .userFatherName)]
    private let organizationData = [Cell(name: .userName),
                                    Cell(name: .userSurname),
                                    Cell(name: .userFatherName),
                                    Cell(name: .userOrganizationName),
                                    Cell(name: .userNumberLetter),
                                    Cell(name: .userOrganizationDate),
                                    Cell(name: .userNumberLetter)]
    private let userContactInformation = [Cell(name: .userEmail),
                                          Cell(name: .userPhone)]
    
    private func fillForm(_ destination: Destination) {
        let toSomeoneSection = Section(name: "Куда адресовано", cells: toSomeone)
        let atUserSection = Section(name: "Заявитель", cells: userData)
        let atOrganizationSection = Section(name: "Заявитель", cells: organizationData)
        let responceAddressSection = Section(name: "Адрес для ответа", cells: userContactInformation)
        
        switch destination {
        case .registrationUser:
            data = [atUserSection, responceAddressSection]
        case .registrationOrganization:
            data = [atOrganizationSection, responceAddressSection]
        case .requestToServer:
            data = [toSomeoneSection]
        }
    }
    
    init(_ destination: Destination) {
        fillForm(destination)
    }
}
