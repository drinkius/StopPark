//
//  UserDefaultsManager.swift
//  StopPark
//
//  Created by Arman Turalin on 12/14/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import Foundation

let kDistrict: String = "kDistrict"
let kSubdivision: String = "kSubdivision"
let kRang: String = "kRang"
let kPoliceName: String = "kPoliceName"
let kUserName: String = "kUserName"
let kUserSurname: String = "kUserSurname"
let kUserFatherName: String = "kUserFatherName"
let kEmail: String = "kEmail"
let kPhone: String = "kPhone"

let kUserOrganizationName: String = "kUserOrganizationName"
let kUserOrganizationOut: String = "kUserOrganizationOut"
let kUserOrganizationDate: String = "kUserOrganizationDate"
let kUserOrganizationLetter: String = "kUserOrganizationLetter"

let kCaptureImage: String = "kCaptureImage"

let kUploadImageIds: String = "kUploadImageIds"
let kSession: String = "kUploadImageSession"

let kPreviousSelectedRegion: String = "kPreviousSelectedRegion"

let kAppeals: String = "kAppeals"

let kIAPTransactionHashValue: String = "kIAPTransactionHashValue"

struct UserDefaultsManager {
    
    static func setFormData(_ type: FormData, data: String?) {
        switch type {
        case .userName: UserDefaults.standard.set(data, forKey: kUserName)
        case .userSurname: UserDefaults.standard.set(data, forKey: kUserSurname)
        case .userFatherName: UserDefaults.standard.set(data, forKey: kUserFatherName)
        case .userOrganizationName: UserDefaults.standard.set(data, forKey: kUserOrganizationName)
        case .userOrganizationNumber: UserDefaults.standard.set(data, forKey: kUserOrganizationOut)
        case .userOrganizationDate: UserDefaults.standard.set(data, forKey: kUserOrganizationDate)
        case .userOrganizationLetter: UserDefaults.standard.set(data, forKey: kUserOrganizationLetter)
        case .userEmail: UserDefaults.standard.set(data, forKey: kEmail)
        case .userPhone: UserDefaults.standard.set(data, forKey: kPhone)
        case .district: UserDefaults.standard.set(data, forKey: kPreviousSelectedRegion)
        default: break
        }
    }
    
    static func getFormData(_ type: FormData) -> String? {
        switch type {
        case .userName: return UserDefaults.standard.string(forKey: kUserName)
        case .userSurname: return UserDefaults.standard.string(forKey: kUserSurname)
        case .userFatherName: return UserDefaults.standard.string(forKey: kUserFatherName)
        case .userOrganizationName: return UserDefaults.standard.string(forKey: kUserOrganizationName)
        case .userOrganizationNumber: return UserDefaults.standard.string(forKey: kUserOrganizationOut)
        case .userOrganizationDate: return UserDefaults.standard.string(forKey: kUserOrganizationDate)
        case .userOrganizationLetter: return UserDefaults.standard.string(forKey: kUserOrganizationLetter)
        case .userEmail: return UserDefaults.standard.string(forKey: kEmail)
        case .userPhone: return UserDefaults.standard.string(forKey: kPhone)
        case .district: return UserDefaults.standard.string(forKey: kPreviousSelectedRegion)
        default: return nil
        }
    }
    
// MARK: - Upload Images Ids
    static func setUploadImagesIds(_ ids: [String]?) {
        UserDefaults.standard.set(ids, forKey: kUploadImageIds)
    }
    
    static func getUploadImagesIds() -> [String]? {
        return UserDefaults.standard.array(forKey: kUploadImageIds) as? [String]
    }
    
    static func setSession(_ sessionId: String?) {
        UserDefaults.standard.set(sessionId, forKey: kSession)
    }
    
    static func getSession() -> String? {
        return UserDefaults.standard.string(forKey: kSession)
    }
    
    
    static func setSavedAppeals(_ value: [Appeal]?) {
        if let encodedData = try? PropertyListEncoder().encode(value) {
            UserDefaults.standard.set(encodedData, forKey: kAppeals)
        }
    }
    
    static func getSavedAppeals() -> [Appeal]? {
        if let decodedData = UserDefaults.standard.object(forKey: kAppeals) as? Data,
            let decodedAppeals = try? PropertyListDecoder().decode([Appeal].self, from: decodedData) {
            return decodedAppeals
        }
        return nil
    }
    
    static func setIAPTransactionHashValue(_ value: Int) {
        UserDefaults.standard.set(value, forKey: kIAPTransactionHashValue)
    }
    
    static func getIAPTransactionHashValue() -> Int {
        return UserDefaults.standard.integer(forKey: kIAPTransactionHashValue)
    }
}
