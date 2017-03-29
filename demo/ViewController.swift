//
//  ViewController.swift
//  demo
//
//  Created by wpf on 2017/3/20.
//  Copyright © 2017年 wpf. All rights reserved.
//

import UIKit
import EventKit



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        Calendar.ckFirstWeekday = .sun
        
//        for i in 0 ..< 60 {
//            print(Date().dayByInterval(months: i).modelInMonth())
//            print("______")
//        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

