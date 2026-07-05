//
//  API.swift
//  WatchPulse
//
//  Created by Tomasz Gorbaczewski on 07.08.2018.
//  Copyright © 2018 GT. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

final class API {

    static let shared = API()

    private enum Endpoint {
        static let key = "{session-auth-key}"

        static let webProtocol = "https://"
        static let domain = "health.YourDomain.pl"
        static let baseAddress = webProtocol + domain

        static let verifyUser = baseAddress + "/Thingworx/Things/WebApiThing/Services/VerifyUser"
        static let registerUser = baseAddress
        static let postMessage  = baseAddress + ":443/ProjectHealthWebhook/postMessage"

        enum Headers {
            static var basic: HTTPHeaders {
                return [
                    "Content-Type": "application/json",
                    "Accept": "application/json"
                ]
            }

            static var secure: HTTPHeaders {
                var headers = basic
                headers.add(name: "appKey", value: Endpoint.key)
                return headers
            }
        }
    }

    private let session: Session

    private init() {
        let configuration = URLSessionConfiguration.default

        /*
         Alamofire 5 replacement for:
         ServerTrustPolicyManager(policies: ...)
         .disableEvaluation

         WARNING:
         DisabledTrustEvaluator should only be used for development/testing.
         Do not ship this in production.
         */
        let serverTrustManager = ServerTrustManager(
            evaluators: [
                Endpoint.domain: DisabledTrustEvaluator()
            ]
        )

        self.session = Session(
            configuration: configuration,
            serverTrustManager: serverTrustManager
        )
    }
}

// MARK: - Requests

extension API {

    func verifyUser(email: String, password: String) {
        var headers = Endpoint.Headers.basic
        headers.add(name: "Userid", value: email)
        headers.add(name: "Password", value: password)

        session.request(
            Endpoint.verifyUser,
            method: .post,
            headers: headers
        )
        .validate()
        .responseJSON { response in
            self.debugResponse("VerifyUser", response: response)

            switch response.result {
            case .success:
                guard let data = response.data else { return }
                let json = JSON(data)
                print("VerifyUser - JSON RESPONSE: \(json)")

            case .failure(let error):
                print("VerifyUser - ERROR: \(error)")
            }
        }

        print(Endpoint.verifyUser)
    }

    func registerUser() {
        let headers = Endpoint.Headers.secure

        /*
         TODO:
         Add parameters/body here if the API expects them.

         Example:
         let parameters: [String: Any] = [
             "emailAddress": "testUser@gmail.com",
             "password": "testPasstestPass",
             "firstName": "Janusz",
             "lastName": "Testowy"
         ]
         */

        session.request(
            Endpoint.registerUser,
            method: .post,
            headers: headers
        )
        .validate()
        .responseJSON { response in
            self.debugResponse("RegisterUser", response: response)

            switch response.result {
            case .success:
                guard let data = response.data else { return }
                let json = JSON(data)
                print("RegisterUser - JSON RESPONSE: \(json)")

            case .failure(let error):
                print("RegisterUser - ERROR: \(error)")
            }
        }

        print(Endpoint.registerUser)
        print(Endpoint.key)
    }

    func postMessage() {
        let headers = Endpoint.Headers.basic

        /*
         TODO:
         Add JSON body here if required.

         Example:
         let parameters: [String: Any] = [
             "deviceIMEI": "15847e15e9f672649d5e3199e34f7ad9",
             "locationLatitude": "53.1325",
             "locationLongitude": "23.1688",
             "owner": "testUser@gmail.com",
             "values": [
                 [
                     "name": "heart-rate",
                     "date": "2018-08-07T13:11:45.000",
                     "value": 87.0,
                     "unit": "bpm",
                     "sourceName": "Apple Watch Series 3"
                 ]
             ]
         ]

         Then pass:
         parameters: parameters,
         encoding: JSONEncoding.default
         */

        session.request(
            Endpoint.postMessage,
            method: .post,
            headers: headers
        )
        .validate()
        .responseJSON { response in
            self.debugResponse("PostMessage", response: response)

            switch response.result {
            case .success:
                guard let data = response.data else { return }
                let json = JSON(data)
                print("PostMessage - JSON RESPONSE: \(json)")

            case .failure(let error):
                print("PostMessage - ERROR: \(error)")
            }
        }

        print(Endpoint.postMessage)
    }
}

// MARK: - Debug

private extension API {

    func debugResponse<T>(_ name: String, response: AFDataResponse<T>) {
        print("----- \(name) -----")
        print("REQUEST:", response.request as Any)
        print("STATUS:", response.response?.statusCode as Any)
        print("HEADERS:", response.response?.allHeaderFields as Any)

        if let data = response.data {
            print("BODY:", String(data: data, encoding: .utf8) ?? "<non-utf8 body>")
        }

        if let error = response.error {
            print("AF ERROR:", error)
        }

        print("-------------------")
    }
}
