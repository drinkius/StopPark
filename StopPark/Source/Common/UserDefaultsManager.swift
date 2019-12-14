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
let kUserOrganizationName: String = "kUserOrganizationName"


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

    
    static func setOrganizationName(_ text: String?) {
        UserDefaults.standard.set(text, forKey: kUserOrganizationName)
    }
    
    static func getOrganizationName() -> String? {
        return UserDefaults.standard.string(forKey: kUserOrganizationName)
    }
}
