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
        print(Date().dayByInterval(months: 0).modelInMonth())
        print("------")
        
        Calendar.ckFirstWeekday = .mon
        print(Date().dayByInterval(months: 0).modelInMonth())
        print("------")

        Calendar.ckFirstWeekday = .tue
        print(Date().dayByInterval(months: 0).modelInMonth())
        print("------")

        Calendar.ckFirstWeekday = .wed
        print(Date().dayByInterval(months: 0).modelInMonth())
        print("------")

        Calendar.ckFirstWeekday = .thr
        print(Date().dayByInterval(months: 0).modelInMonth())
        print("------")

        Calendar.ckFirstWeekday = .fri
        print(Date().dayByInterval(months: 0).modelInMonth())
        print("------")

        Calendar.ckFirstWeekday = .sat
        print(Date().dayByInterval(months: 0).modelInMonth())
        print("------")

        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

