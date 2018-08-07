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

class API
{
    public static let shared = API()
    let Almgr : Alamofire.SessionManager = {
        // Create the server trust policies
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "health.ttpsc.pl": .disableEvaluation
        ]
        // Create custom manager
        let configuration = URLSessionConfiguration.default
//        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        let man = Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        return man
    }()
    
    private struct endpoint
    {
        static let key = "c06cf9c4-5c05-4f9a-b91d-06b0e6aff45a"
        static let domain = "https://health.ttpsc.pl"
        
        static let verifyUser = domain + "/Thingworx/Things/WebApiThing/Services/VerifyUser"
        static let registerUser = domain
        static let postMessage  = domain + ":443/ProjectHealthWebhook/postMessage"
        
        struct headers
        {
            static let basic: HTTPHeaders = [
                "Content-Type": "application/json",
                "Accept": "application/json"
            ]
            
            static var secure: HTTPHeaders
            {
                let basicHeaders = basic
                var appKeyHeader = [ "appKey": endpoint.key ]
                appKeyHeader.merge(dict: basicHeaders)
                
                return appKeyHeader
            }
        }
    }
}

extension API
{
    func verifyUser(email: String, password: String)
    {
        var headers: HTTPHeaders =
        [
            "Userid"  : email,
            "Password": password
        ]
        
        headers.merge(dict: endpoint.headers.basic)
        
        Almgr.request(endpoint.verifyUser, method: .post, headers: headers).responseJSON { (response) in
            let statusCode = response.response?.statusCode

            if(statusCode == status.ok)
            {
                if let data = response.data
                {
                    let json = JSON(data)
                    
                    print("VerifyUser - JSON RESPONSE: \(json)")
                }
            }
        }
    
        print(endpoint.verifyUser)
    }
    
    func registerUser()
    {
        var headers = endpoint.headers.secure
        // TODO: add get params into post request? (Query type)
        /*
         [{"key":"emailAddress","value":"testUser@gmail.com","equals":true,"description":"","enabled":true},{"key":"password","value":"testPasstestPass","equals":true,"description":"","enabled":true},{"key":"firstName","value":"Janusz","equals":true,"description":"","enabled":true},{"key":"lastName","value":"Testowy","equals":true,"description":"","enabled":true}]
         */
        Almgr.request(endpoint.registerUser, method: .post, headers: headers).responseJSON { (response) in
            let statusCode = response.response?.statusCode
            
            if(statusCode == status.ok)
            {
                if let data = response.data
                {
                    let json = JSON(data)
                    
                    print("VerifyUser - JSON RESPONSE: \(json)")
                }
            }
        }
        print(endpoint.registerUser)
        print(endpoint.key)
    }
    
    func postMessage()
    {
        var headers = endpoint.headers.basic
        // TODO: add raw data ex.:
        /*
         {"deviceIMEI": "15847e15e9f672649d5e3199e34f7ad9",
         "locationLatitude": "53.1325",
         "locationLongitude": "23.1688",
         "owner": "testUser@gmail.com",
         "values":
         [{"name":"heart-rate",
         "date":"2018-08-07T13:11:45.000",
         "value":87.0,
         "unit":"bpm",
         "sourceName":"Apple Watch Series 3"}]
         }
         */
        
        Almgr.request(endpoint.postMessage, method: .post, headers: headers).responseJSON { (response) in
            let statusCode = response.response?.statusCode
            
            if(statusCode == status.ok)
            {
                if let data = response.data
                {
                    let json = JSON(data)
                    
                    print("VerifyUser - JSON RESPONSE: \(json)")
                }
            }
        }
        print(endpoint.postMessage)
    }
}
