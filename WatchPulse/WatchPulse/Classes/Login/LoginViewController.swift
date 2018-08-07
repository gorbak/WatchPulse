//
//  LoginViewController.swift
//  WatchPulse
//
//  Created by Tomasz Gorbaczewski on 07.08.2018.
//  Copyright © 2018 GT. All rights reserved.
//

import UIKit

let textImage_Play: String = "▸"
let textImage_Stop: String = "▪︎"

class LoginViewController: UIViewController
{
    @IBOutlet weak var l_timer: UILabel!
    var timer = Timer()
    var startDate: Date = Date()
    
    private var email: String { return tf_email.text ?? "" }
    private var pass: String { return tf_password.text ?? "" }
    
    var emailAndPasswordEntered: Bool { return (!email.isEmpty && !pass.isEmpty) }
    
    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var tf_password: UITextField!
    
    var isCounting = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    
    func tick()
    {
        
    }
    
    // Timer expects @objc selector
    @objc func eventWith(timer: Timer!) {
        let info = timer.userInfo as Any
//        print(info)

        let secondsSinceStart = Int( Date().timeIntervalSince(self.startDate) )
        let secondsAndMinutes = secondsToHoursMinutesSeconds(seconds: secondsSinceStart)
        let minutesString = String(secondsAndMinutes.minutes)
        let secondsString = String(format: "%02d", secondsAndMinutes.seconds)
        self.l_timer.text = "\(minutesString):\(secondsString)"
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool
    {
        if(!emailAndPasswordEntered)
        {
            return false
        }
        
        return true
    }
    
    @IBAction func loginAction(_ sender: Any)
    {
        if(emailAndPasswordEntered)
        {
            API.shared.verifyUser(email: tf_email.text!, password: tf_password.text!)
        }
    }
    
    @IBAction func startStopTimer(_ sender: UIButton)
    {
        isCounting = !isCounting
        if(isCounting)
        {
            sender.setTitle(textImage_Stop, for: .normal)
            sender.titleEdgeInsets.bottom = -5
        }
        else
        {
            sender.setTitle(textImage_Play, for: .normal)
            sender.titleEdgeInsets.bottom = 7
        }
        
        startDate = Date()
        
        if(isCounting)
        {
            timer = Timer.scheduledTimer(timeInterval: 1.0,
                                         target: self,
                                         selector: #selector(eventWith(timer:)),
                                         userInfo: [ "foo" : "bar" ],
                                         repeats: true)
        }
        else
        {
            self.l_timer.text = "0:00"
            timer.invalidate()
        }
    }
}
