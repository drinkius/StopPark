//
//  DistrictData.swift
//  StopPark
//
//  Created by Arman Turalin on 1/4/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import Foundation

enum DistrictData: Int, CaseIterable {
    case moscovCity = 77
    case peter = 78
    
    case volgograd = 34
    case voronezh = 36
    case krasnodar = 23
    case krasnoyarsk = 24
    case novosib = 54
    case novgorod = 53
    case omsk = 55
    case perm = 59
    case rostov = 61
    case samar = 63
    case chelyab = 74

    case adygeya = 01
    case bashkorstan = 02
    case buryatiya = 03
    case altay = 04
    case dagestan = 05
    case ingushetiya = 06
    case kabardin = 07
    case kalmykiya = 08
    case karachaevo = 09
    case kareliya = 10
    case komi = 11
    case mariy = 12
    case mordoviya = 13
    case saha = 14
    case osetiya = 15
    case tatarstan = 16
    case tyva = 17
    case udmurtiya = 18
    case hakasiya = 19
    case chuvashiya = 21
    case altayKray = 22
    case primorsk = 25
    case stavropol = 26
    case khabarovsk = 27
    case amur = 28
    case arhangel = 29
    case astrakhan = 30
    case balgorod = 31
    case bryansk = 32
    case vladimir = 33
    case vologodskaya = 35
    case ivanov = 37
    case irkutsk = 38
    case kalinin = 39
    case kaluzh = 40
    case kamchat = 41
    case kemer = 42
    case kirov = 43
    case kostroma = 44
    case kurgan = 45
    case kursk = 46
    case leningrad = 47
    case lipeck = 48
    case magadan = 49
    case moskvaObl = 50
    case murmansk = 51
    case nizhegorod = 52
    case orenburg = 56
    case orlov = 57
    case penza = 58
    case pskov = 60
    case ryazan = 62
    case saratov = 64
    case sahalin = 65
    case sverdlov = 66
    case smolensk = 67
    case tombov = 68
    case tver = 69
    case tomsk = 70
    case tulsk = 71
    case tumen = 72
    case ulyan = 73
    case zabaykal = 75
    case yaroslav = 76
    case eurey = 79
    case neneck = 83
    case hynty = 86
    case chukot = 87
    case yamal = 89
    case chechen = 95
    
    var title: String {
        switch self {
        case .adygeya:          return "Республика Адыгея (01)"
        case .bashkorstan:      return "Республика Башкортостан (02)"
        case .buryatiya:        return "Республика Бурятия (03)"
        case .altay:            return "Республика Алтай (04)"
        case .dagestan:         return "Республика Дагестан (05)"
        case .ingushetiya:      return "Республика Ингушетия (06)"
        case .kabardin:         return "Кабардино-Балкарская Республика (07)"
        case .kalmykiya:        return "Республика Калмыкия (08)"
        case .karachaevo:       return "Республика Карачаево-Черкессия (09)"
        case .kareliya:         return "Республика Карелия (10)"
        case .komi:             return "Республика Коми (11)"
        case .mariy:            return "Республика Марий Эл (12)"
        case .mordoviya:        return "Республика Мордовия (13)"
        case .saha:             return "Республика Саха (Якутия) (14)"
        case .osetiya:          return "Республика Северная Осетия-Алания (15)"
        case .tatarstan:        return "Республика Татарстан (16)"
        case .tyva:             return "Республика Тыва (17)"
        case .udmurtiya:        return "Удмуртская Республика (18)"
        case .hakasiya:         return "Республика Хакасия (19)"
        case .chuvashiya:       return "Чувашская Республика (21)"
        case .altayKray:        return "Алтайский край (22)"
        case .krasnodar:        return "Краснодарский край (23)"
        case .krasnoyarsk:      return "Красноярский край (24)"
        case .primorsk:         return "Приморский край (25)"
        case .stavropol:        return "Ставропольский край (26)"
        case .khabarovsk:       return "Хабаровский край (27)"
        case .amur:             return "Амурская область (28)"
        case .arhangel:         return "Архангельская область (29)"
        case .astrakhan:        return "Астраханская область (30)"
        case .balgorod:         return "Белгородская область (31)"
        case .bryansk:          return "Брянская область (32)"
        case .vladimir:         return "Владимирская область (33)"
        case .volgograd:        return "Волгоградская область (34)"
        case .vologodskaya:     return "Вологодская область (35)"
        case .voronezh:         return "Воронежская область (36)"
        case .ivanov:           return "Ивановская область (37)"
        case .irkutsk:          return "Иркутская область (38)"
        case .kalinin:          return "Калининградская область (39)"
        case .kaluzh:           return "Калужская область (40)"
        case .kamchat:          return "Камчатский край (41)"
        case .kemer:            return "Кемеровская область - Кузбасс (42)"
        case .kirov:            return "Кировская область (43)"
        case .kostroma:         return "Костромская область (44)"
        case .kurgan:           return "Курганская область (45)"
        case .kursk:            return "Курская область (46)"
        case .leningrad:        return "Ленинградская область (47)"
        case .lipeck:           return "Липецкая область (48)"
        case .magadan:          return "Магаданская область (49)"
        case .moskvaObl:        return "Московская область (50)"
        case .murmansk:         return "Мурманская область (51)"
        case .nizhegorod:       return "Нижегородская область (52)"
        case .novgorod:         return "Новгородская область (53)"
        case .novosib:          return "Новосибирская область (54)"
        case .omsk:             return "Омская область (55)"
        case .orenburg:         return "Оренбургская область (56)"
        case .orlov:            return "Орловская область (57)"
        case .penza:            return "Пензенская область (58)"
        case .perm:             return "Пермский край (59)"
        case .pskov:            return "Псковская область (60)"
        case .rostov:           return "Ростовская область (61)"
        case .ryazan:           return "Рязанская область (62)"
        case .samar:            return "Самарская область (63)"
        case .saratov:          return "Саратовская область (64)"
        case .sahalin:          return "Сахалинская область (65)"
        case .sverdlov:         return "Свердловская область (66)"
        case .smolensk:         return "Смоленская область (67)"
        case .tombov:           return "Тамбовская область (68)"
        case .tver:             return "Тверская область (69)"
        case .tomsk:            return "Томская область (70)"
        case .tulsk:            return "Тульская область (71)"
        case .tumen:            return "Тюменская область (72)"
        case .ulyan:            return "Ульяновская область (73)"
        case .chelyab:          return "Челябинская область (74)"
        case .zabaykal:         return "Забайкальский край (75)"
        case .yaroslav:         return "Ярославская область (76)"
        case .moscovCity:       return "г. Москва (77)"
        case .peter:            return "г. Санкт-Петербург (78)"
        case .eurey:            return "Еврейская автономная область (79)"
        case .neneck:           return "Ненецкий автономный округ (83)"
        case .hynty:            return "Ханты-Мансийский автономный округ - Югра (86)"
        case .chukot:           return "Чукотский автономный округ (87)"
        case .yamal:            return "Ямало-Ненецкий автономный округ (89)"
        case .chechen:          return "Чеченская Республика (95)"
        }
    }
    
    static func getCode(from text: String?) -> String? {
        guard let text = text else { return nil }
        
        let districtDatas = DistrictData.allCases.filter { $0.title == text}
        guard let districtData = districtDatas.first else { return nil }
        
        return String(districtData.rawValue)
    }
    
    static var bigCities: [DistrictData] {
        return [.moscovCity, .peter]
    }
    
    static var otherBigCities: [DistrictData] {
        return [.volgograd, .voronezh, .krasnodar, .krasnoyarsk, .novosib, .novgorod, .omsk, .perm, .rostov, .samar, .chelyab]
    }
    
    static var allCities: [DistrictData] {
        let all = DistrictData.allCases
            .sorted { $0.title.lowercased() < $1.title.lowercased() }
        return all
    }
}
