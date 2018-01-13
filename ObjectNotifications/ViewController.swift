//
//  ViewController.swift
//  ObjectNotifications
//
//  Created by Ben Winters on 1/13/18.
//  Copyright © 2018 Proper Apps LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func didTapCreateTokens(_ sender: Any) {
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else {
            print("No app delegate")
            return
        }
        
        appDel.objectNotificationManager.setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

