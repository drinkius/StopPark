//
//  Analytics.swift
//  StopPark
//
//  Created by Arman Turalin on 1/15/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import Foundation
import FirebaseAnalytics

enum InvEvent {
    case loginPageOpened
    case appOpens
    
    case loginClickButton
    case loginSuccess
    case loginFail

    case homeClickSettings
    case homeClickGift
    case homeClickForm
    
    case settingsClickChangeProfile
    case settingsClickInfo
            
    case formClickCancel
    case formClickEditMessage
    case formClickAddImage
    case formClickDeleteImage
    case formClickSendForm
    
    case formEditMessageRejectNotFilled
    case formEditMessageRejectNoImage
    
    case formSendFormRejectNotFilled
    case formSendFormRejectNoImage
    case formSendFormImageNotify
    
    case formClickIgnoreImageNotify
    case formClickAcceptImageNotify
    
    case formClickRefreshCaptcha
    case formClickSendCaptcha
    
    case formSuccessSend
    
    case editorClickCancel
    case editorClickConfirm
}

enum GACategory: String {
    case app = "App"
    case login = "Login"
    case form = "Form"
    case home = "Home"
    case editor = "Editor"
    case settings = "Settings"
    case info = "Info"
}

enum GAAction: String {
    case appOpens = "App Opens"
    
    case loginPageOpened = "Login Page Opened"
    case loginClickButton = "Login Click Button"
    case loginSuccess = "Login Success"
    case loginFail = "Login Fail"
    
    case clickSettings = "Click Settings"
    case clickGift = "Click Gift"
    case clickForm = "Click Form"
    
    case clickChangeProfile = "Click Change Profile"
    case clickInfo = "Click Info"
    
    case clickEditMessage = "Click Edit Message"
    case clickAddImage = "Click Add Image"
    case clickDeleteImage = "Click Delete Image"
    case clickSendForm = "Click Send Form"
    
    case editMessageRejectNotFilled = "Edit Message Reject Not Filled"
    case editMessageRejectNoImage = "Edit Message Reject No Image"
    
    case sendFormRejectNotFilled = "Send Form Reject Not Filled"
    case sendFormRejectNoImage = "Send Form Reject No Image"
    case sendFormImageNotify = "Send Form Image Notify"
    
    case sendSuccess = "Send Success"
    
    case clickIgnoreImageNotify = "Click Ignore Image Notify"
    case clickAcceptImageNotify = "Click Accept Image Notify"
    
    case fillCaptcha = "Fill Captcha"
    case clickRefreshCaptcha = "Click Refresh Captcha"
    case clickSendCaptcha = "Click Send Captcha"
    
    case clickCancel = "Click Cancel"
    case clickConfirm = "Click Confirm"
    
    case fillRegion = "Fill Region"
    case fillRang = "Fill Rang"
    case fillPoliceName = "Fill Police Name"
    case fillRepeatedDivision = "Fill Repeated Region"
    case fillRepeatedDate = "Fill Repeated Date"
    case fillEventDate = "Fill Event Date"
    case fillAutoMark = "Fill Auto Mark"
    case fillAutoNumber = "Fill Auto Number"
    case fillEventAddress = "Fill Event Address"
    case fillPhotoDate = "Fill Photo Date"
    case fillEventViolation = "Fill Describe Event Violation"
}

class InvAnalytics {
    static let shared = InvAnalytics()
    static let uuid = UUID().uuidString
    
    public func sendEvent(fillFormData data: FormData) {
        switch data {
        case .district:
            let action = GAAction.fillRegion.rawValue
            let category = GACategory.form.rawValue
            sendGoogleAnalytics(category: category, event: action, label: InvAnalytics.uuid)
        case .rang:
            let action = GAAction.fillRang.rawValue
            let category = GACategory.form.rawValue
            sendGoogleAnalytics(category: category, event: action, label: InvAnalytics.uuid)
        case .policeName:
            let action = GAAction.fillPoliceName.rawValue
            let category = GACategory.form.rawValue
            sendGoogleAnalytics(category: category, event: action, label: InvAnalytics.uuid)
        case .eventPlace:
            let action = GAAction.fillEventAddress.rawValue
            let category = GACategory.form.rawValue
            sendGoogleAnalytics(category: category, event: action, label: InvAnalytics.uuid)
        case .repeatedDivision:
            let action = GAAction.fillRepeatedDivision.rawValue
            let category = GACategory.form.rawValue
            sendGoogleAnalytics(category: category, event: action, label: InvAnalytics.uuid)
        case .repeatedDate:
            let action = GAAction.fillRepeatedDate.rawValue
            let category = GACategory.form.rawValue
            sendGoogleAnalytics(category: category, event: action, label: InvAnalytics.uuid)
        
        case .eventDate:
            let action = GAAction.fillEventDate.rawValue
            let category = GACategory.form.rawValue
            sendGoogleAnalytics(category: category, event: action, label: InvAnalytics.uuid)
        case .autoMark:
            let action = GAAction.fillAutoMark.rawValue
            let category = GACategory.form.rawValue
            sendGoogleAnalytics(category: category, event: action, label: InvAnalytics.uuid)
        case .autoNumber:
            let action = GAAction.fillAutoNumber.rawValue
            let category = GACategory.form.rawValue
            sendGoogleAnalytics(category: category, event: action, label: InvAnalytics.uuid)
        case .eventAddress:
            let action = GAAction.fillEventAddress.rawValue
            let category = GACategory.form.rawValue
            sendGoogleAnalytics(category: category, event: action, label: InvAnalytics.uuid)
        case .photoDate:
            let action = GAAction.fillPhotoDate.rawValue
            let category = GACategory.form.rawValue
            sendGoogleAnalytics(category: category, event: action, label: InvAnalytics.uuid)
        case .eventViolation:
            let action = GAAction.fillEventViolation.rawValue
            let category = GACategory.form.rawValue
            sendGoogleAnalytics(category: category, event: action, label: InvAnalytics.uuid)
        default: break
        }
    }
    
    public func sendEvent(event: InvEvent) {
        switch event {
        case .appOpens:
            let action = GAAction.appOpens.rawValue
            let category = GACategory.app.rawValue
            sendGoogleAnalytics(category: category, event: action, label: InvAnalytics.uuid)
            
        case .loginPageOpened:
            let action = GAAction.loginPageOpened.rawValue
            let category = GACategory.login.rawValue
            sendGoogleAnalytics(category: category, event: action, label: InvAnalytics.uuid)
        case .loginClickButton:
            let action = GAAction.loginClickButton.rawValue
            let category = GACategory.login.rawValue
            sendGoogleAnalytics(category: category, event: action, label: InvAnalytics.uuid)
        case .loginSuccess:
            let action = GAAction.loginSuccess.rawValue
            let category = GACategory.login.rawValue
            sendGoogleAnalytics(category: category, event: action, label: InvAnalytics.uuid)
        case .loginFail:
            let action = GAAction.loginFail.rawValue
            let category = GACategory.login.rawValue
            sendGoogleAnalytics(category: category, event: action, label: InvAnalytics.uuid)
            
        case .homeClickSettings:
            let action = GAAction.clickSettings.rawValue
            let category = GACategory.home.rawValue
            sendGoogleAnalytics(category: category, event: action, label: InvAnalytics.uuid)
        case .homeClickGift:
            let action = GAAction.clickGift.rawValue
            let category = GACategory.home.rawValue
            sendGoogleAnalytics(category: category, event: action, label: InvAnalytics.uuid)
        case .homeClickForm:
            let action = GAAction.clickForm.rawValue
            let category = GACategory.home.rawValue
            sendGoogleAnalytics(category: category, event: action, label: InvAnalytics.uuid)
            
        case .settingsClickChangeProfile:
            let action = GAAction.clickChangeProfile.rawValue
            let category = GACategory.settings.rawValue
            sendGoogleAnalytics(category: category, event: action, label: InvAnalytics.uuid)
        case .settingsClickInfo:
            let action = GAAction.clickInfo.rawValue
            let category = GACategory.settings.rawValue
            sendGoogleAnalytics(category: category, event: action, label: InvAnalytics.uuid)
            
        case .formClickCancel:
            let action = GAAction.clickCancel.rawValue
            let category = GACategory.form.rawValue
            sendGoogleAnalytics(category: category, event: action, label: InvAnalytics.uuid)
        case .formClickEditMessage:
            let action = GAAction.clickEditMessage.rawValue
            let category = GACategory.form.rawValue
            sendGoogleAnalytics(category: category, event: action, label: InvAnalytics.uuid)
        case .formClickAddImage:
            let action = GAAction.clickAddImage.rawValue
            let category = GACategory.form.rawValue
            sendGoogleAnalytics(category: category, event: action, label: InvAnalytics.uuid)
        case .formClickDeleteImage:
            let action = GAAction.clickDeleteImage.rawValue
            let category = GACategory.form.rawValue
            sendGoogleAnalytics(category: category, event: action, label: InvAnalytics.uuid)
        case .formClickSendForm:
            let action = GAAction.clickSendForm.rawValue
            let category = GACategory.form.rawValue
            sendGoogleAnalytics(category: category, event: action, label: InvAnalytics.uuid)
        case .formEditMessageRejectNotFilled:
            let action = GAAction.editMessageRejectNotFilled.rawValue
            let category = GACategory.form.rawValue
            sendGoogleAnalytics(category: category, event: action, label: InvAnalytics.uuid)
        case .formEditMessageRejectNoImage:
            let action = GAAction.editMessageRejectNoImage.rawValue
            let category = GACategory.form.rawValue
            sendGoogleAnalytics(category: category, event: action, label: InvAnalytics.uuid)
        case .formSendFormRejectNotFilled:
            let action = GAAction.sendFormRejectNotFilled.rawValue
            let category = GACategory.form.rawValue
            sendGoogleAnalytics(category: category, event: action, label: InvAnalytics.uuid)
        case .formSendFormRejectNoImage:
            let action = GAAction.sendFormRejectNoImage.rawValue
            let category = GACategory.form.rawValue
            sendGoogleAnalytics(category: category, event: action, label: InvAnalytics.uuid)
        case .formSendFormImageNotify:
            let action = GAAction.sendFormImageNotify.rawValue
            let category = GACategory.form.rawValue
            sendGoogleAnalytics(category: category, event: action, label: InvAnalytics.uuid)
        case .formClickIgnoreImageNotify:
            let action = GAAction.clickIgnoreImageNotify.rawValue
            let category = GACategory.form.rawValue
            sendGoogleAnalytics(category: category, event: action, label: InvAnalytics.uuid)
        case .formClickAcceptImageNotify:
            let action = GAAction.clickAcceptImageNotify.rawValue
            let category = GACategory.form.rawValue
            sendGoogleAnalytics(category: category, event: action, label: InvAnalytics.uuid)
        case .formClickRefreshCaptcha:
            let action = GAAction.clickRefreshCaptcha.rawValue
            let category = GACategory.form.rawValue
            sendGoogleAnalytics(category: category, event: action, label: InvAnalytics.uuid)
        case .formClickSendCaptcha:
            let action = GAAction.clickSendCaptcha.rawValue
            let category = GACategory.form.rawValue
            sendGoogleAnalytics(category: category, event: action, label: InvAnalytics.uuid)
        case .formSuccessSend:
            let action = GAAction.sendSuccess.rawValue
            let category = GACategory.form.rawValue
            sendGoogleAnalytics(category: category, event: action, label: InvAnalytics.uuid)

        case .editorClickCancel:
            let action = GAAction.clickCancel.rawValue
            let category = GACategory.editor.rawValue
            sendGoogleAnalytics(category: category, event: action, label: InvAnalytics.uuid)
        case .editorClickConfirm:
            let action = GAAction.clickConfirm.rawValue
            let category = GACategory.editor.rawValue
            sendGoogleAnalytics(category: category, event: action, label: InvAnalytics.uuid)
        }
    }
    
    private func sendGoogleAnalytics(category: String, event: String, label: String) {
        let underEvent = event.replacingOccurrences(of: " ", with: "_")
        let underLabel = label.replacingOccurrences(of: " ", with: "_")
                               .replacingOccurrences(of: "@", with: "_")
                               .replacingOccurrences(of: ".", with: "_")
        Analytics.logEvent(underEvent, parameters: [
            "label" : underLabel,
            "action" : event,
            "category" : category,
        ])
    }
}
