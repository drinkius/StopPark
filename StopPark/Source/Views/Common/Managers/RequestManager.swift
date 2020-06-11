//
//  Parameter.swift
//  StopPark
//
//  Created by Arman Turalin on 12/16/19.
//  Copyright © 2019 tech.telegin. All rights reserved.
//

import UIKit

typealias Parameters = [String: String]

class RequestManager {
    static let shared = RequestManager()
    
//    let step2 = ["agree": "on", "step": "2"]
    private var eventInfoData: [FormData: String]?

    func setFormData(_ data: [FormData: String]) {
        self.eventInfoData = data
    }

    func createFormURLEncodedBody(captcha: String = "") -> Data? {
        
        guard let firstName = UserDefaultsManager.getFormData(.userName) else { return Data() }
        guard let lastName = UserDefaultsManager.getFormData(.userSurname) else { return Data() }
        guard let email = UserDefaultsManager.getFormData(.userEmail) else { return Data() }
        guard let eventInfoForm = eventInfoData else { return nil }
        
        var params = [
            "surname": "\(lastName)",
            "firstname": "\(firstName)",
            "email": "\(email)",
            "step": "3",
            "agree": "on"]
        
        if let fatherName = UserDefaultsManager.getFormData(.userFatherName) {
            params["patronymic"] = "\(fatherName)"
        }
        
        if let phone = UserDefaultsManager.getFormData(.userPhone) {
            params["phone"] = "\(phone)"
        }
        
        if let orgName = UserDefaultsManager.getFormData(.userOrganizationName) {
            params["is_organization"] = "\(1)"
            params["org_name"] = "\(orgName)"
        } else {
            params["is_organization"] = "\(0)"
        }
        
        if let orgOut = UserDefaultsManager.getFormData(.userOrganizationNumber) {
            params["org_out"] = "\(orgOut)"
        }
        
        if let orgDate = UserDefaultsManager.getFormData(.userOrganizationDate) {
            params["org_date"] = "\(orgDate)"
        }
        
        if let orgLetter = UserDefaultsManager.getFormData(.userOrganizationLetter) {
            params["org_letter"] = "\(orgLetter)"
        }
                
        if let imageIDs = UserDefaultsManager.getUploadImagesIds() {
            for (i, id) in imageIDs.enumerated() {
                params["file\(i)"] = "\(id)"
            }
        }
        
        for (key, value) in eventInfoForm {
            switch key {
            case .district: params["region_code"] = "\(value)"
            case .subDivision: params["subunit"] = "\(value)"
            case .rang: params["post"] = "\(value)"
            case .policeName: params["fio"] = "\(value)"
            case .eventPlace: params["event_region"] = "\(value)"
            case .repeatedDivision: params["subunit_name"] = "\(value)"
            case .repeatedDate: params["subunit_date"] = "\(value)"
            default: break
            }
        }
        
        var message: String = ""
        
        if let editedMessage = eventInfoForm[.editedMessage] {
            message = editedMessage
        } else {
            guard let eventDate = eventInfoForm[.eventDate] else { return nil }
            guard let autoMark = eventInfoForm[.autoMark] else { return nil }
            guard let autoNumber = eventInfoForm[.autoNumber] else { return nil }
            guard let eventAddress = eventInfoForm[.eventAddress] else { return nil }
            guard let photoDate = eventInfoForm[.photoDate] else { return nil }
            let eventViolation = eventInfoForm[.eventViolation]
            
            message = Strings.generateTemplateText(date: eventDate, auto: autoMark, number: autoNumber, address: eventAddress, photoDate: photoDate, eventViolation: eventViolation)
        }

        params["captcha"] = "\(captcha)"
        params["message"] = "\(message)"
        
        return getFormURLEncodedData(params: params)
    }
    
    func createFormDataBody(with params: Parameters?, media: [Media]?, boundary: String) -> Data {
        let lineBreak = "\r\n"
        var body = Data()
        
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value + lineBreak)")
            }
            
            if let media = media {
                for photo in media {
                    body.append("--\(boundary + lineBreak)")
                    body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
                    body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                    body.append(photo.data)
                    body.append(lineBreak)
                }
            }
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        return body
    }
        
    public func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    func getFormURLEncodedData(params: [String: String]) -> Data? {
        var data = [String]()

        for (key, value) in params {
            
            if key.contains("file") {
                data.append("file" + "=\(value)")
                continue
            }
            
            data.append(key + "=\(value)")
        }
        print(data.map { String($0) }.joined(separator: "&"))
        return data.map { String($0) }.joined(separator: "&").data(using: .utf8)
    }
}

extension RequestManager {
    func initialRequest() -> URLRequest? {
        guard let url = URLs.mainRequestURL else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        return urlRequest
    }

    func emailVerificationRequest() -> URLRequest? {
        guard let session = UserDefaultsManager.getSession() else {
            return nil
        }
        var urlRequest = URLRequest(url: URLs.emailRequestURL)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue(.xRequestedWith)
        urlRequest.addValue(.requestMainRefer)
        urlRequest.addValue(.cookieWithRegion(Int(eventInfoData?[.district] ?? "") ?? 77, session))
        urlRequest.addValue(.defaultContentType)

        let dataBody = createFormURLEncodedBody()
        urlRequest.httpBody = dataBody

        return urlRequest
    }

    func sendVerificationCodeRequest(_ code: String) -> URLRequest? {
        guard let session = UserDefaultsManager.getSession() else {
            return nil
        }
        var urlRequest = URLRequest(url: URLs.checkEmailCodeURL)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue(.requestMainRefer)
        urlRequest.addValue(.xRequestedWith)
        urlRequest.addValue(.cookieWithRegion(Int(eventInfoData?[.district] ?? "") ?? 77, session))
        urlRequest.addValue(.defaultContentType)

        urlRequest.httpBody = RequestManager.shared.getFormURLEncodedData(params: ["key": code])

        return urlRequest
    }
    
    func preFinalRequest() -> URLRequest? {
        guard let url = URLs.mainRequestURL else {
            return nil
        }
        
        guard let session = UserDefaultsManager.getSession() else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue(.defaultContentType)
        urlRequest.addValue(.setCookieWithPath(session))
        
        let dataBody = createFormURLEncodedBody()
        urlRequest.httpBody = dataBody
        
        return urlRequest
    }
    
    
    func uploadDataRequest(image: UIImage) -> URLRequest? {
        guard let url = URLs.fileuploadURL else {
            return nil
        }
        
        guard let session = UserDefaultsManager.getSession() else {
            return nil
        }
        
        let boundary = RequestManager.shared.generateBoundaryString()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue(.formDataContentType(boundary))
        urlRequest.addValue(.requestMainRefer)
        urlRequest.addValue(.xRequestedWith)
        urlRequest.addValue(.host)
        urlRequest.addValue(.acceptEncoding)
        urlRequest.addValue(.accept)
        urlRequest.addValue(.cookieWithRegion(Int(eventInfoData?[.district] ?? "") ?? 77, session))
        
        let photo = Media(withImage: image, forKey: "file")
        let dataBody = RequestManager.shared.createFormDataBody(with: ["input_name": "file"], media: [photo!], boundary: boundary)
        urlRequest.httpBody = dataBody
                
        return urlRequest
    }
    
    func subUnitRequest(with code: String) -> URLRequest? {
        guard let url = URL(string: URLs.getSubUnit + code) else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue(.xRequestedWith)
        
        return urlRequest
    }
    
    func finalRequest(with captcha: String) -> URLRequest? {
        guard let url = URLs.mainRequestURL else {
            return nil
        }
        
        guard let session = UserDefaultsManager.getSession() else {
            return nil
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue(.requestMainRefer)
        urlRequest.addValue(.defaultContentType)
        urlRequest.addValue(.xRequestedWith)
        urlRequest.addValue(.setCookieWithPath(session))

        let dataBody = RequestManager.shared.createFormURLEncodedBody(captcha: captcha)
        urlRequest.httpBody = dataBody
        
        return urlRequest
    }
}

extension URLRequest {
    enum HeaderField {
        case defaultContentType
        case formDataContentType(String)
        case requestMainRefer
        case xRequestedWith
        case acceptEncoding
        case accept
        case host
        case setCookieWithPath(String)
        case cookieWithRegion(Int, String)
    }
    
    mutating func addValue(_ type: HeaderField) {
        switch type {
        case .defaultContentType:
            addValue("application/x-www-form-urlencoded; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        case .formDataContentType(let boundary):
            setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        case .requestMainRefer:
            setValue("https://xn--90adear.xn--p1ai/request_main/", forHTTPHeaderField: "Referer")
        case .host:
            setValue("xn--90adear.xn--p1ai", forHTTPHeaderField: "Host")
        case .acceptEncoding:
            setValue("gzip, deflate", forHTTPHeaderField: "Accept-Encoding")
        case .accept:
            addValue("*/*", forHTTPHeaderField: "Accept")
        case .xRequestedWith:
            setValue("XMLHttpRequest", forHTTPHeaderField: "x-requested-with")
        case .setCookieWithPath(let session):
            addValue("session=\(session); path=/", forHTTPHeaderField: "Set-Cookie")
        case .cookieWithRegion(let region, let session):
            addValue("regionCode=\(region); session=\(session)", forHTTPHeaderField: "Cookie")
        }
    }
}
