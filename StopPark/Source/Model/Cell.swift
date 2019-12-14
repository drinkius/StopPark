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
    case rang = "Должность"
    case policeName = "Ф.И.О."
    case userName = "Имя"
    case userSurname = "Фамилия"
    case userFatherName = "Отчество"
    case userOrganizationName = "Наименование организации"
    case userNumber = "Исходящий №"
    case userOrganizationDate = "Дата регистрации документа в организации"
    case userNumberLetter = "№ заказного письма"
    case userEmail = "Электронная почта"
    case userPhone = "Телефон"
    case eventPlace = "Место события (регион)"
    
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
        }
    }
}

struct Cell {
    let name: FormData
}
