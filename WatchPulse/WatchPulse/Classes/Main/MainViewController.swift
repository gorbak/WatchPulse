//
//  MainViewController.swift
//  WatchPulse
//
//  Created by Tomasz Gorbaczewski on 07.08.2018.
//  Copyright © 2018 GT. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func logout(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
}
