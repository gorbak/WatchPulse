//
//  Globals.swift
//  WatchPulse
//
//  Created by GT on 02.08.2018.
//  Copyright © 2018 GT. All rights reserved.
//

import UIKit
import WatchKit


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
