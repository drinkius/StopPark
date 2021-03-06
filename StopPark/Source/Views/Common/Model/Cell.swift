//
//  CellModel.swift
//  StopPark
//
//  Created by Arman Turalin on 12/14/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import Foundation

enum FormData: String, CaseIterable {

// MARK: - Registration Info
    case userName = "Имя"
    case userSurname = "Фамилия"
    case userFatherName = "Отчество (Опционально)"
    case userOrganizationName = "Наименование организации (Опционально)"
    case userOrganizationNumber = "Исходящий № (Опционально)"
    case userOrganizationDate = "Дата регистрации документа в организации (Опционально)"
    case userOrganizationLetter = "№ заказного письма (Опционально)"
    case userEmail = "Электронная почта"
    case userPhone = "Телефон (Опционально)"

// MARK: - Request Info
    case district = "Регион"
    case subDivision = "Подразделение"
    case rang = "Должность (Опционально)"
    case policeName = "Ф.И.О. должностного лица (Опционально)"
    case eventPlace = "Место события (регион) (Опционально)"
    case repeatedDivision = "Подразделение (Опционально)"
    case repeatedDate = "Дата (Опционально)"
    
// MARK: - Message Info
    case eventDate = "Дата и время произошедшего"
    case autoMark = "Марка автомобиля"
    case autoNumber = "Гос. номер автомобиля"
    case eventAddress = "Адрес, где располагался автомобиль"
    case photoDate = "Дата сделанного фото"
    case eventViolation = "Опишите нарушение (Опционально)"
    case editedMessage
    
    static var userPrivacyData: [FormData] = [.userName, .userSurname, .userFatherName, .userEmail, .userPhone, .userOrganizationName, .userOrganizationDate, .userOrganizationLetter, .userOrganizationNumber]

    static var messageData: [FormData] {
        return [.eventDate, .autoMark, .autoNumber, .eventAddress, .photoDate, .eventViolation]
    }
    
    static var reapeatedToData: [FormData] {
        return [.repeatedDivision, .repeatedDate]
    }
    
    static var toData: [FormData] {
        return [.district]
//        return [.district, .rang, .policeName]
    }
    
    static var fromData: [FormData] {
        var array: [FormData] = []
        for formData in FormData.allCases {
            if let _ = UserDefaultsManager.getFormData(formData) {
                array.append(formData)
            }
        }
        return array
    }
    
    static var userData: [FormData] {
        return [.userName, .userSurname, .userFatherName]
    }
    
    static var orgData: [FormData] {
        return [.userName, .userSurname, .userFatherName, .userOrganizationName, .userOrganizationNumber, .userOrganizationDate, .userOrganizationLetter]
    }
    
    static var contactInfo: [FormData] {
        return [userEmail, .userPhone]
    }
}

struct Cell {
    let name: FormData
}
