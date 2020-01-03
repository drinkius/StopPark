//
//  CellModel.swift
//  StopPark
//
//  Created by Arman Turalin on 12/14/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import Foundation

enum FormData: String {
    case district = "Регион"
    case subDivision = "Подразделение"
    case rang = "Должность (Опционально)"
    case policeName = "Ф.И.О. (Опционально)"
    case userName = "Имя"
    case userSurname = "Фамилия"
    case userFatherName = "Отчество (Опционально)"
    case userOrganizationName = "Наименование организации (Опционально)"
    case userNumber = "Исходящий № (Опционально)"
    case userOrganizationDate = "Дата регистрации документа в организации (Опционально)"
    case userNumberLetter = "№ заказного письма (Опционально)"
    case userEmail = "Электронная почта"
    case userPhone = "Телефон (Опционально)"
    case eventPlace = "Место события (регион) (Опционально)"
    case repeatedDivision = "Подразделение (Опционально)"
    case repeatedDate = "Дата (Опционально)"
    // Body
    case eventDate = "Дата произошедшего"
    case autoMark = "Марка автомобиля"
    case autoNumber = "Госномер автомобиля"
    case eventAddress = "Адресс, где распологался автомобиль"
    case photoDate = "Дата сделанного фото"
    case eventViolation = "Опишите нарушение (Опционально)"
    
    func formDataAction() -> ((String) -> Void) {
        switch self {
        case .district: return {(text) in UserDefaultsManager.setDistrict(text)}
        case .subDivision: return {(text) in UserDefaultsManager.setSubdivision(text)}
        case .rang: return {(text) in UserDefaultsManager.setRang(text)}
        case .policeName: return {(text) in UserDefaultsManager.setPoliceName(text)}
        case .userName: return {(text) in UserDefaultsManager.setUserName(text)}
        case .userSurname: return {(text) in UserDefaultsManager.setUserSurname(text)}
        case .userFatherName: return {(text) in UserDefaultsManager.setUserFatherName(text)}
        case .userOrganizationName: return {(text) in UserDefaultsManager.setOrganizationName(text)}

        case .userNumber: return {(text) in UserDefaultsManager.setDistrict(text)}
        case .userOrganizationDate: return {(text) in UserDefaultsManager.setDistrict(text)}
        case .userNumberLetter: return {(text) in UserDefaultsManager.setDistrict(text)}
        case .userEmail: return {(text) in UserDefaultsManager.setDistrict(text)}
        case .userPhone: return {(text) in UserDefaultsManager.setDistrict(text)}
        case .eventPlace: return {(text) in UserDefaultsManager.setDistrict(text)}
        case .repeatedDivision: return {(text) in }
        case .repeatedDate: return {(text) in }
        case .eventDate: return {(text) in }
        case .autoMark: return {(text) in }
        case .autoNumber: return {(text) in }
        case .eventAddress: return {(text) in }
        case .photoDate: return {(text) in }
        case .eventViolation: return {(text) in }
        }
    }
}

struct Cell {
    let name: FormData
}
