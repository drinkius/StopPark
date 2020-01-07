//
//  Strings.swift
//  StopPark
//
//  Created by Arman Turalin on 12/15/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import Foundation

struct Strings {
    
    static let informationText: String =
    """
    Ваше обращение в форме электронного документа будет рассмотрено в соответствии с Федеральным законом от 2 мая 2006 г. № 59-ФЗ «О порядке рассмотрения обращений граждан Российской Федерации» и приказом МВД России от 12 сентября 2013 г. № 707 «Об утверждении Инструкции об организации рассмотрения обращений граждан в системе Министерства внутренних дел Российской Федерации».
    Сообщения о происшествиях (преступлениях, событиях, угрожающих личной или общественной безопасности, а также иных обстоятельствах, требующих проверки возможных признаков преступления или административного правонарушения) круглосуточно принимаются и незамедлительно регистрируются в дежурных частях территориальных органов внутренних дел, по телефону 02 (со стационарных телефонов) или 102 (с мобильных средств связи).
    При заполнении формы обращения Вам в обязательном порядке следует указать: фамилию, имя, отчество (при наличии), адрес электронной почты для направления ответа или уведомления, суть обращения. Также Вы вправе приложить к обращению необходимые документы и материалы в электронной форме.
    В соответствии с названным Федеральным законом без ответа остаются обращения, в которых отсутствует фамилия, имя, отчество (при наличии) или адрес электронной почты. В случае, если текст обращения не позволяет определить суть предложения, заявления или жалобы, ответ на обращение не дается, о чем в течение семи дней со дня регистрации обращения направляется сообщение. Кроме того, без ответа по существу поставленных вопросов останется обращение, в котором содержатся нецензурные, либо оскорбительные выражения, угрозы жизни, здоровью и имуществу должностного лица, а также членов его семьи.
    Поступившие обращения регистрируются в трехдневный срок и рассматриваются в течение 30 дней со дня регистрации. При необходимости срок рассмотрения может быть продлен не более чем на 30 дней, о чем направляется уведомление.
    Если в обращении не содержится информация о результатах рассмотрения обозначенных вопросов соответствующими территориальными органами внутренних дел и разрешение этих вопросов не относится к исключительной компетенции подразделений центрального аппарата министерства, оно будет направлено для рассмотрения по существу в территориальные органы внутренних дел. При этом уведомление гражданину о переадресации обращения в органы, организации,и подразделения системы МВД России не направляется.
    Обращение, содержащее вопросы, решение которых не входит в компетенцию Министерства внутренних дел Российской Федерации, направляется в течение семи дней со дня регистрации в соответствующий орган или соответствующему должностному лицу, в компетенцию которых входит решение поставленных в обращении вопросов, с уведомлением об этом гражданина, направившего обращение.
    Ответ на обращение будет направлен в форме электронного документа на указанный Вами адрес электронной почты.
    Обжалование судебных решений осуществляется в соответствии с требованиями процессуального законодательства. Рассмотрение такого рода обращений не входит в компетенцию МВД России.
    Обращаем Ваше внимание на недопустимость злоупотребления правом на обращение в государственные органы и предусмотренную законодательством ответственность в этой сфере общественных отношений. В случае, если в обращении указаны заведомо ложные сведения, расходы, понесенные в связи с его рассмотрением, могут быть взысканы с автора.
    Просим Вас с пониманием отнестись к изложенным требованиям законодательства, внимательно заполнить все предложенные реквизиты и четко сформулировать суть проблемы.
    Информация о персональных данных, направленных в электронном виде, хранится и обрабатывается с соблюдением требований российского законодательства о персональных данных.
    """
    
    static func generateTemplateText(date: String, auto: String, number: String, address: String, photoDate: String) -> String {
        let count = UserDefaultsManager.getUploadImagesIds()?.count ?? 0
        let templateText: String =
        """
        Заявление
        \(date) я увидел автомобиль \(auto) с госномером \(number), расположенный на \(address). Знаков о допустимости подобной стоянки на тротуаре рядом нет, при такой парковке машина закрывает обзор поворачивающим с перекрёстка и не даёт увидеть переходящих пешеходов. Водителя в салоне либо рядом не было. С водителем либо собственником автомобиля я не знаком.

        Прилагаю фотографии машины (\(count)), сделанные мной в \(photoDate).

        На основании изложенных в заявлении сведений прошу:

        1. Привлечь лицо, допустившее стоянку автомобиля на тротуаре, к административной ответственности согласно ч. 3 ст. 12.19 КоАП.
        2. Сообщить мне на электронную почту о мерах, принятых на основании данного заявления.

        Согласно ст. 28.1.4 КоАП, фиксация нарушения средствами фото- и киносъемки, видеозаписи является поводом для возбуждения дела об административном правонарушении. Согласно примечанию к ст. 1.5 КоАП, презумпция невиновности не действует в случае административных правонарушений с использованием транспортных средств, если эти правонарушения были зафиксированы средствами фото- и киносъемки, видеозаписи.

        Я лично ознакомлен со ст. 51 Конституции, ст. 25.6 КоАП, ст. 17.7, 17.9, 19.7 КоАП, они мне ясны и понятны.

        Согласно ч. 2 ст. 6 Федерального закона от 02.05.2006 № 59-ФЗ «О порядке рассмотрения обращений граждан Российской Федерации», я не даю согласия на разглашение сведений, касающихся моих персональных данных.
        """
        return templateText
    }
    
    static let captchaError: String = "Не удалось загрузить капчу. Попробуйте снова, либо напишите, пожалуйста, нам на почту."
    static let wrongURL: String = "Ссылка неверная, напишите в поддержку."
    static let notConnected: String = "Проверьте интернет соединение."
    static let cantGetData: String = "Не смогли получить данные. Попробуйте еще раз."
}
