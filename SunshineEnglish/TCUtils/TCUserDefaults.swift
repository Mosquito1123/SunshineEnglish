//
//  TCUserDefaults.swift
//  SunshineEnglish
//
//  Created by Winston on 2018/6/11.
//  Copyright © 2018年 Winston. All rights reserved.
//

import UIKit

class TCUserDefaults: NSObject {

    static let shared = TCUserDefaults()
    let df = UserDefaults.standard
    
}


extension TCUserDefaults
{
    func setTCValue(value: Any?, forKey key: String){
        df.set(value, forKey: key)
        df.synchronize()
    }
    
    func getTCValue(key: String) -> Any? {
        return df.value(forKey: key)
    }
}

// MARK: 语言设置
extension TCUserDefaults
{
    func getIELanguage() -> String {
        if let language = getTCValue(key: "IELanguageKey") as? String {
            return language
        }
        return  "zh_CN"
    }
    
    func setIElanguage(value: String) {
        setTCValue(value: value, forKey: "IELanguageKey")
    }
}
