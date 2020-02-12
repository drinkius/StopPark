//
//  Form+Cell.swift
//  StopPark
//
//  Created by Arman Turalin on 2/5/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

// MARK: - ButtonTableViewCellDelegate
extension FormVC: ButtonTableViewCellDelegate {
    func cell(_ cell: ButtonTableViewCell, buttonTouchUpInside button: UIButton) {
        view.endEditing(true)
        guard Reachability.isConnectedToNetwork() else {
            showErrorMessage(Str.Generic.noConnection)
            return
        }
        
        guard eventImages.count > 0 else {
            InvAnalytics.shared.sendEvent(event: .formSendFormRejectNoImage)
            showErrorMessage(Str.Generic.errorNoImage)
            return
        }
        
        guard let code = eventInfoForm[.district] else {
            InvAnalytics.shared.sendEvent(event: .formSendFormRejectNotFilled)
            showErrorMessage(Str.Generic.errorNotFilledPoint + FormData.district.rawValue)
            return
        }

        guard let _ = eventInfoForm[.eventDate],
            let _ = eventInfoForm[.autoMark],
            let _ = eventInfoForm[.autoNumber],
            let _ = eventInfoForm[.eventAddress],
            let _ = eventInfoForm[.photoDate] else {
                InvAnalytics.shared.sendEvent(event: .formSendFormRejectNotFilled)
                showErrorMessage(Str.Generic.errorNoFilledMessageData)
                return
        }
        
        if eventImages.count < 5 {
            InvAnalytics.shared.sendEvent(event: .formSendFormImageNotify)
            let continueAction = UIAlertAction(title: Str.Generic.continue, style: .destructive, handler: { _ in
                InvAnalytics.shared.sendEvent(event: .formClickIgnoreImageNotify)
                self.continueSend(code: code)
            })
            let addMoreImagesAction = UIAlertAction(title: Str.Form.addMoreImages, style: .default) { _ in
                InvAnalytics.shared.sendEvent(event: .formClickAcceptImageNotify)
            }
            showMessage(Str.Form.imageRecomendation, addAction: [continueAction, addMoreImagesAction])
        } else {
            continueSend(code: code)
        }
    }
    
    private func continueSend(code: String) {
        InvAnalytics.shared.sendEvent(event: .formClickSendForm)
        Vibration.success.vibrate()
        openSendFormView()
                
        sendFormView.updateView(for: .uploadImages)
        webView.sendImageToServer(images: eventImages) { [weak self] result in
            switch result {
            case .failure(let text): self?.showErrorMessage(text)
            case .success(_): self?.sendPreFinalRequest(with: code)
            }
        }
    }
}

// MARK: - ImageCollectionViewCellDelegate
extension FormVC: ImagesTableViewCellDelegate, ImageCollectionViewCellDelegate {
    func cell(_ cell: ImagesTableViewCell, addButtonTouchUpInside buttonCell: UICollectionViewCell) {
        InvAnalytics.shared.sendEvent(event: .formClickAddImage)
        imagePicker.present()
    }

    func delete(image: UIImage?) {
        guard let image = image else {
            return
        }
        
        guard let index = eventImages.firstIndex(of: image) else {
            return
        }
        InvAnalytics.shared.sendEvent(event: .formClickDeleteImage)
        eventImages.remove(at: index)
        
        
        guard let buttonSectionIndex = sections.firstIndex(where: { $0.type.index == Section.SectionType.buttons.index }) else {
            return
        }

        let indexSet = IndexSet(integer: buttonSectionIndex)
        tableView.reloadSections(indexSet, with: .none)
    }
}

// MARK: - TextFieldCellDelegate
extension FormVC: TextFieldCellDelegate {
    func cell(_ cell: TextFieldCell, formData data: FormData?, didChangedTo text: String?) {
        guard let data = data else { return }
        guard let text = text, !text.isEmpty else {
            self.eventInfoForm[data] = nil
            return
        }

        InvAnalytics.shared.sendEvent(fillFormData: data)
        if data == .district {
            self.eventInfoForm[data] = DistrictData.getCode(from: text)
            UserDefaultsManager.setFormData(data, data: text)
            return
        }

        self.eventInfoForm[data] = text
    }
}

// MARK: - TimePickerCellDelegate
extension FormVC: TimePickerCellDelegate {
    func cell(_ cell: TimePickerCell, formData data: FormData?, didChangedTimeTo text: String?) {
        guard let data = data else { return }
        guard let text = text, !text.isEmpty else {
            self.eventInfoForm[data] = nil
            return
        }

        InvAnalytics.shared.sendEvent(fillFormData: data)
        
        self.eventInfoForm[data] = text
    }
}
