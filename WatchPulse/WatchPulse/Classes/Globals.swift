//
//  Globals.swift
//  WatchPulse
//
//  Created by GT on 02.08.2018.
//  Copyright © 2018 GT. All rights reserved.
//

import UIKit
import WatchKit

struct status
{
    static let ok = 200
    static let success = "SUCCESS"
    static let expired = "EXPIRED"
    static let error = "BAD_REQUEST"
    struct invalidCredentials
    {
        static let key = "INCORRECT_CREDENTIALS"
        static let message = NSLocalizedString("ERROR_InvalidCredentials", comment: "")
    }
    static let invalidArgumentType = "INVALID_ARGUMENT_TYPE"
    static let unauthorized  = "UNAUTHORIZED"
    static let unknownError  = "UNKNOWN_ERROR"
    static let unknown       = "UNKNOWN"
    static let malformedJson = "MALFORMED_JSON"
    static let databaseError = "DB_ERROR"
    static let notFound      = "NOT_FOUND"
}

func secondsToHoursMinutesSeconds (seconds : Int) -> (hours: Int, minutes: Int, seconds: Int)
{
    return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
}

extension Array
{
    var avg: Int
    {
        var sum:  Int = 0
        var count:Int = 0
        
        for obj in self
        {
            sum   += obj as! Int
            count += 1
        }
        
        return sum / count
    }
    
    var max: Int
    {
        var highest = 0
        
        for obj in self
        {
            if(highest < obj as! Int)
            {
                highest = obj as! Int
            }
        }
        
        return highest
    }
}

extension Dictionary
{
    mutating func merge(dict: [Key: Value])
    {
        for (k, v) in dict
        {
            updateValue(v, forKey: k)
        }
    }
}
