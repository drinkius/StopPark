//
//  Template.swift
//  StopPark
//
//  Created by Arman Turalin on 2/1/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import Foundation

enum Template: Int {
    case pavement = 0, pedestrianCrossing, pedestrianZone, wrongPlace
    
    var title: String {
        switch self {
        case .pavement: return "Тротуар"
        case .pedestrianCrossing: return "Пешеходный переход"
        case .pedestrianZone: return "Пешеходная зона"
        case .wrongPlace: return "Неположенное место"
        }
    }
    
    var description: String {
        switch self {
        case .pavement: return "Машина, стояла на тротуаре, мешала пройти прохожим."
        case .pedestrianCrossing: return "Перегородил пешеходный переход, и мешал движению пешеходов."
        case .pedestrianZone: return "Машина стояла на пешеходной зоне."
        case .wrongPlace: return "Нарушение правил стоянки либо остановки машины в месте отведенном для транспортных средств инвалидов без знака инвалида."
        }
    }
}
