//
//  Form+View.swift
//  StopPark
//
//  Created by Arman Turalin on 2/6/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

// MARK: - ButtonFooterViewDelegate
extension FormVC: ButtonFooterViewDelegate {
    func view(_ view: ButtonFooterView, didEditButtonTouchUpInside button: UIButton) {
        view.endEditing(true)
        guard eventImages.count > 0 else {
            InvAnalytics.shared.sendEvent(event: .formEditMessageRejectNoImage)
            showErrorMessage(Str.Generic.errorNoImage)
            return
        }
        guard let date = eventInfoForm[.eventDate],
            let auto = eventInfoForm[.autoMark],
            let num = eventInfoForm[.autoNumber],
            let addr = eventInfoForm[.eventAddress],
            let photoDate = eventInfoForm[.photoDate] else {
                InvAnalytics.shared.sendEvent(event: .formEditMessageRejectNotFilled)
                showErrorMessage(Str.Generic.errorNotFilled)
                return
        }
        InvAnalytics.shared.sendEvent(event: .formClickEditMessage)
        let event = eventInfoForm[.eventViolation]
        let template = Strings.generateTemplateText(date: date, auto: auto, number: num, address: addr, photoDate: photoDate, eventViolation: event, imageCount: eventImages.count)
        let generatedMessage = eventInfoForm[.editedMessage] ?? template

        let context = FormRouter.RouteContext.edit(message: generatedMessage) { [weak self] text in self?.eventInfoForm[.editedMessage] = text }
        router.enqueueRoute(with: context)
    }
    
    func view(_ view: ButtonFooterView, didSetTemplate template: Template) {
        let cells = tableView.visibleCells
        cells.forEach {
            guard let textFieldCell = $0 as? TextFieldCell else { return }
            guard textFieldCell.titleText == FormData.eventViolation.rawValue else { return }
            textFieldCell.textFieldText = template.description
        }
        eventInfoForm[.eventViolation] = template.description
    }
    
    func view(_ view: ButtonFooterView, onActivateButtonTouchUpInside button: UIButton) {
//        let context = FormRouter.RouteContext.pay
//        router.enqueueRoute(with: context)
    }
}

// MARK: - SendFormViewDelegate
extension FormVC: SendFormViewDelegate {
    func view(_ view: SendFormView, didSendCaptcha captcha: String) {
        InvAnalytics.shared.sendEvent(event: .formClickSendCaptcha)
        webView.finalLoadData(with: captcha)
    }
    
    func view(_ view: SendFormView, didReceiveError error: String) {
        showErrorMessage(error)
    }
    
    func view(_ view: SendFormView, closeButtonTouchUpInside button: UIButton) {
        InvAnalytics.shared.sendEvent(event: .formClickCancel)
        Vibration.light.vibrate()
        dismiss(animated: true)
    }
    
    func view(_ view: SendFormView, cancelButtonTouchUpInside button: UIButton) {
        InvAnalytics.shared.sendEvent(event: .formClickCancel)
        Vibration.light.vibrate()
        dismiss(animated: true)
    }
    
    func view(_ view: SendFormView, changeCaptchaOn captchaView: CaptchaView) {
        webView.refreshCaptchaLoadData()
    }
}
