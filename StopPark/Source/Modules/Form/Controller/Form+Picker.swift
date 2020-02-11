//
//  Form+Picker.swift
//  StopPark
//
//  Created by Arman Turalin on 2/12/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

// MARK: - UIPickerView
extension FormVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    enum PickerRowType {
        case section(String)
        case row(String)
    }
    
    var pickerRows: [PickerRowType] {
        var pickerRows: [PickerRowType] = [.section("")]
        pickerRows += DistrictData.bigCities.map { .row($0.title) }
        pickerRows += [.section("Остальные миллионники по алфавиту")]
        pickerRows += DistrictData.anotherBigCities.map { .row($0.title) }
        pickerRows += [.section("Остальные по алфавиту")]
        pickerRows += DistrictData.anotherCities.map { .row($0.title) }
        return pickerRows
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerRows.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerRows[row] {
        case let .section(text): return text
        case let .row(text): return text
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? TextFieldCell else { return }
        switch pickerRows[row] {
        case .section: break
        case let .row(text): cell.textFieldText = text
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.sizeToFit()
        label.textAlignment = .center
        
        switch pickerRows[row] {
        case let .section(text):
            label.font = .systemFont(ofSize: 11)
            label.text = text
            label.textColor = .lightGray
            return label
        case let .row(text):
            label.text = text
            label.font = .systemFont(ofSize: 14)
            label.textColor = .black
            return label
        }
    }
}

