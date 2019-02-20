//
//  ITAboutAppVC.swift
//  iTalker
//
//  Created by Winston on 2018/4/23.
//  Copyright © 2018年 ihtc.cc @Winston. All rights reserved.
//

import UIKit

class ITAboutAppVC: UIViewController {

    @IBOutlet weak var logoImgView: UIImageView!
    
    @IBOutlet weak var appNameLbl: UILabel!
    @IBOutlet weak var versionLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var copylightLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}

extension ITAboutAppVC
{
    func setupUI() {
        self.title = "关于\(kAppName)"
        
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .never
        }
        
        guard (self.logoImgView != nil) else {
            return
        }
        
        self.logoImgView.image = #imageLiteral(resourceName: "iEnglish")
        self.logoImgView.layer.cornerRadius = 8
        self.logoImgView.layer.masksToBounds = true
        self.appNameLbl.text = kAppName
        self.versionLbl.text = "v" + KAppVersion
        self.contentLbl.text = "\(kAppName) 为一款英语初学者提供基础英文单词学习的应用，正确的单词发音、必备的分类单词，不断努力打造更简单更好方式呈现更有趣的英语知识，让大家在零碎时间也可以快速和简单的学习get!"
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy"
        let yearString = formatter.string(from: Date.init())
        self.copylightLbl.text = "Copyright © 2018-" + yearString + " Winston"
    }
}


