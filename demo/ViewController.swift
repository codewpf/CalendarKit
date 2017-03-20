//
//  ViewController.swift
//  demo
//
//  Created by wpf on 2017/3/20.
//  Copyright © 2017年 wpf. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        for i in 0 ..< 7 {
            print(Date().dayByInterval(days: Double(i)).weekdayName())
        }
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

