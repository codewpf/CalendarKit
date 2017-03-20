//
//  CKExtensions.swift
//  demo
//
//  Created by wpf on 2017/3/20.
//  Copyright © 2017年 wpf. All rights reserved.
//

import Foundation

extension Bundle {

    class func ckBundle() -> Bundle? {
        guard let path = Bundle(for: CalendarKit.self).path(forResource: "CalendarKit", ofType: "bundle") ,
              let bundle = Bundle(path: path) else {
                return nil
        }
        return bundle
    }
    
    class func ckLocalizeString(key: String, value: String? = nil) -> String? {
    
        guard var language = NSLocale.preferredLanguages.first else {
            return nil
        }
        
        
        if language.hasPrefix("en") {
            language = "en"
        } else if language.hasPrefix("zh") {
            if language.range(of: "Hans") != nil {
                language = "zh-Hans"
            } else {
                language = "zh-Hant"
            }
        } else {
            language = "en"
        }
        

        guard let path = Bundle.ckBundle()?.path(forResource: language, ofType: "lproj") ,
              let bundle = Bundle(path: path) else {

            return nil
        }
        
        let v = bundle.localizedString(forKey: key, value: value, table: nil)
        return Bundle.main.localizedString(forKey: key, value: v, table: nil)
    }

}

