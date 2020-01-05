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
                             Cell(name: .rang),
                             Cell(name: .policeName)]
    private let userData = [Cell(name: .userName),
                            Cell(name: .userSurname),
                            Cell(name: .userFatherName)]
    private let organizationData = [Cell(name: .userName),
                                    Cell(name: .userSurname),
                                    Cell(name: .userFatherName),
                                    Cell(name: .userOrganizationName),
                                    Cell(name: .userOrganizationLetter),
                                    Cell(name: .userOrganizationDate),
                                    Cell(name: .userOrganizationLetter)]
    private let userContactInformation = [Cell(name: .userEmail),
                                          Cell(name: .userPhone)]
    private let repeatedRequest = [Cell(name: .repeatedDivision),
                                   Cell(name: .repeatedDate)]
    private let appeal = [Cell(name: .eventDate),
                          Cell(name: .autoMark),
                          Cell(name: .autoNumber),
                          Cell(name: .eventAddress),
                          Cell(name: .photoDate),
                          Cell(name: .eventViolation)]
    
    private func fillForm(_ destination: Destination) {
        let toSomeoneSection = Section(name: "Куда адресовано", cells: toSomeone)
        let atUserSection = Section(name: "Заявитель", cells: userData)
        let atOrganizationSection = Section(name: "Заявитель", cells: organizationData)
        let responceAddressSection = Section(name: "Адрес для ответа", cells: userContactInformation)
        let repeatedRequestSection = Section(name: "Уже обращались по данному вопросу?", cells: repeatedRequest)
        let appealSection = Section(name: "Генерация текста обращения", cells: appeal)
        
        switch destination {
        case .registrationUser:
            data = [atUserSection, responceAddressSection]
        case .registrationOrganization:
            data = [atOrganizationSection, responceAddressSection]
        case .requestToServer:
            data = [toSomeoneSection, repeatedRequestSection, appealSection]
        }
    }
    
    init(_ destination: Destination) {
        fillForm(destination)
    }
}
