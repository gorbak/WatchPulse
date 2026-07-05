//
//  LoginViewController.swift
//  WatchPulse
//
//  Created by Tomasz Gorbaczewski on 07.08.2018.
//  Copyright © 2018 GT. All rights reserved.
//

import UIKit

let image_Play = UIImage(systemName: "play.fill")
let image_Stop = UIImage(systemName: "stop.fill")

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
        let timeObject = TimeObject(seconds: secondsSinceStart)
        let minutesString = String(timeObject.minutes)
        let secondsString = String(format: "%02d", timeObject.seconds)
//        self.l_timer.text = "\(minutesString):\(secondsString)"
        
        if timeObject.hours > 0 {
            self.l_timer.text = String(
                format: "%d:%02d:%02d",
                timeObject.hours,
                timeObject.minutes,
                timeObject.seconds
            )
        } else {
            self.l_timer.text = String(
                format: "%d:%02d",
                timeObject.minutes,
                timeObject.seconds
            )
        }
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
            sender.setImage(image_Stop, for: .normal)
        }
        else
        {
            sender.setImage(image_Play, for: .normal)
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
