//
//  UserDefaultsManager.swift
//  StopPark
//
//  Created by Arman Turalin on 12/14/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import Foundation

private let kDistrict: String = "kDistrict"
private let kSubdivision: String = "kSubdivision"
private let kRang: String = "kRang"
private let kPoliceName: String = "kPoliceName"
private let kUserName: String = "kUserName"
private let kUserSurname: String = "kUserSurname"
private let kUserFatherName: String = "kUserFatherName"
private let kEmail: String = "kEmail"
private let kPhone: String = "kPhone"

private let kUserOrganizationName: String = "kUserOrganizationName"
private let kUserOrganizationOut: String = "kUserOrganizationOut"
private let kUserOrganizationDate: String = "kUserOrganizationDate"
private let kUserOrganizationLetter: String = "kUserOrganizationLetter"

private let kCaptureImage: String = "kCaptureImage"

private let kUploadImageIds: String = "kUploadImageIds"
private let kSession: String = "kUploadImageSession"

private let kPreviousSelectedRegion: String = "kPreviousSelectedRegion"

private let kAppeals: String = "kAppeals"

private let kIAPTransactionHashValue: String = "kIAPTransactionHashValue"

struct UserDefaultsManager {

    private static var cache = [String: String]()

    private static func key(for type: FormData) -> String? {
        switch type {
        case .userName: return kUserName
        case .userSurname: return kUserSurname
        case .userFatherName: return kUserFatherName
        case .userOrganizationName: return kUserOrganizationName
        case .userOrganizationNumber: return kUserOrganizationOut
        case .userOrganizationDate: return kUserOrganizationDate
        case .userOrganizationLetter: return kUserOrganizationLetter
        case .userEmail: return kEmail
        case .userPhone: return kPhone
        default: return nil
        }
    }
    
    static func setFormData(_ type: FormData, data: String?) {
        guard let key = key(for: type) else {
            return
        }
        cache[key] = data
        UserDefaults.standard.set(data, forKey: key)
    }
    
    static func getFormData(_ type: FormData) -> String? {
        guard let key = key(for: type) else {
            return nil
        }
        guard let value = cache[key] else {
            let value = UserDefaults.standard.string(forKey: key)
            cache[key] = value
            return value
        }
        return value
    }
    
    static func setPreviousDistrict(_ value: String?) {
        UserDefaults.standard.set(value, forKey: kPreviousSelectedRegion)
    }
    
    static func getPreviousDistrict() -> String? {
        return UserDefaults.standard.string(forKey: kPreviousSelectedRegion)
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
