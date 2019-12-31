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
let kUploadImageSession: String = "kUploadImageSession"

struct UserDefaultsManager {
    static func setDistrict(_ text: String?) {
        UserDefaults.standard.set(text, forKey: kDistrict)
    }
    
    static func getDistrict() -> String? {
        return UserDefaults.standard.string(forKey: kDistrict)
    }
    
    
    static func setSubdivision(_ text: String?) {
        UserDefaults.standard.set(text, forKey: kSubdivision)
    }
    
    static func getSubdivision() -> String? {
        return UserDefaults.standard.string(forKey: kSubdivision)
    }
    
    
    static func setRang(_ text: String?) {
        UserDefaults.standard.set(text, forKey: kRang)
    }
    
    static func getRang() -> String? {
        return UserDefaults.standard.string(forKey: kRang)
    }
    
    
    static func setPoliceName(_ text: String?) {
        UserDefaults.standard.set(text, forKey: kPoliceName)
    }
    
    static func getPoliceName() -> String? {
        return UserDefaults.standard.string(forKey: kPoliceName)
    }
    
// MARK: - User Info
    static func setUserName(_ text: String?) {
        UserDefaults.standard.set(text, forKey: kUserName)
    }
    
    static func getUserName() -> String? {
        return UserDefaults.standard.string(forKey: kUserName)
    }

    
    static func setUserSurname(_ text: String?) {
        UserDefaults.standard.set(text, forKey: kUserSurname)
    }
    
    static func getUserSurname() -> String? {
        return UserDefaults.standard.string(forKey: kUserSurname)
    }
    
    
    static func setUserFatherName(_ text: String?) {
        UserDefaults.standard.set(text, forKey: kUserFatherName)
    }
    
    static func getUserFatherName() -> String? {
        return UserDefaults.standard.string(forKey: kUserFatherName)
    }
    
    
    static func setEmail(_ text: String?) {
        UserDefaults.standard.set(text, forKey: kEmail)
    }
    
    static func getEmail() -> String? {
        return UserDefaults.standard.string(forKey: kEmail)
    }

    
    static func setPhone(_ text: String?) {
        UserDefaults.standard.set(text, forKey: kPhone)
    }
    
    static func getPhone() -> String? {
        return UserDefaults.standard.string(forKey: kPhone)
    }

    
// MARK: - Organization
    static func setOrganizationName(_ text: String?) {
        UserDefaults.standard.set(text, forKey: kUserOrganizationName)
    }
    
    static func getOrganizationName() -> String? {
        return UserDefaults.standard.string(forKey: kUserOrganizationName)
    }
    
    static func setOrganizationOut(_ text: Int?) {
        UserDefaults.standard.set(text, forKey: kUserOrganizationOut)
    }
    
    static func getOrganizationOut() -> String? {
        return UserDefaults.standard.string(forKey: kUserOrganizationOut)
    }

    static func setOrganizationDate(_ text: String?) {
        UserDefaults.standard.set(text, forKey: kUserOrganizationDate)
    }
    
    static func getOrganizationDate() -> String? {
        return UserDefaults.standard.string(forKey: kUserOrganizationDate)
    }

    static func setOrganizationLetter(_ text: Int?) {
        UserDefaults.standard.set(text, forKey: kUserOrganizationLetter)
    }
    
    static func getOrganizationLetter() -> String? {
        return UserDefaults.standard.string(forKey: kUserOrganizationLetter)
    }

// MARK: - Capture Image
    static func setCaptureImageText(_ text: String?) {
        UserDefaults.standard.set(text, forKey: kCaptureImage)
    }
    
    static func getCapruteImageText() -> String? {
        return UserDefaults.standard.string(forKey: kCaptureImage)
    }
    
// MARK: - Upload Images Ids
    static func setUploadImagesIds(_ ids: [String]?) {
        UserDefaults.standard.set(ids, forKey: kUploadImageIds)
    }
    
    static func getUploadImagesIds() -> [String]? {
        return UserDefaults.standard.array(forKey: kUploadImageIds) as? [String]
    }
    
    static func setUploadImagesSession(_ sessionId: String?) {
        UserDefaults.standard.set(sessionId, forKey: kUploadImageSession)
    }
    
    static func getUploadImagesSession() -> String? {
        return UserDefaults.standard.string(forKey: kUploadImageSession)
    }
}
