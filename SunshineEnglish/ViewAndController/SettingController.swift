//
//  SettingController.swift
//  SunshineEnglish
//
//  Created by Winston on 2018/6/5.
//  Copyright © 2018年 Winston. All rights reserved.
//

import UIKit
import StoreKit
import SafariServices

class SettingController: UIViewController {
    
    // MARK:- Lify Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var isNewVersion = false
    
    // MARK:- 懒加载
    lazy var tableView: UITableView = {
        var tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenH-49), style: .grouped)
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: -49, right: 0)
        tableView.sectionFooterHeight = 0.1;
        tableView.estimatedRowHeight = 55
        return tableView
    }()
    
    //你想知道的单词都在这里
    fileprivate var titles = ["0": "单词搜索:更多单词搜索,语言设置:设置英文单词翻译成的语言",
        "1": "应用内评分:欢迎给\(kAppName)打评分！,AppStore评价:欢迎给\(kAppName)写评论!,分享给朋友:与身边的好友一起分享！",
        "2": "隐私条款:用户服务使用说明,意见反馈:欢迎到AppStore提需求或bug问题,邮件联系:如有问题欢迎来信,开源地址:未来逐步开放代码，欢迎关注,关于应用:\(kAppName)"] as [String : String]
    
}


extension SettingController
{
    func setupUI() {
        title = "Setting"
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.largeTitleTextAttributes = [ NSAttributedString.Key.foregroundColor : UIColor.white ]
        } 
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let views = ["tableView": tableView]
        let widthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[tableView]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views)
        let heightConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[tableView]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views)
        NSLayoutConstraint.activate(widthConstraints)
        NSLayoutConstraint.activate(heightConstraints)
    }
    
    func gotoAppstore(isAssessment: Bool) {
        guard let url = URL.init(string: kAppDownloadURl + (isAssessment ? kReviewAction: "")) else {return}
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:]) { (completed) in
                
            }
        }
    }
}

// MARK: Tableview Delegate
extension SettingController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.titles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let string = self.titles["\(section)"]
        let titleArray = string?.components(separatedBy: ",")
        return (titleArray?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "ITProgrammerVCViewCell")
        if (cell  == nil) {
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: "ITProgrammerVCViewCell")
            cell!.accessoryType = .disclosureIndicator
            cell!.selectedBackgroundView = UIView.init(frame: cell!.frame)
            cell!.selectedBackgroundView?.backgroundColor = kColorAppMain.withAlphaComponent(0.7)
            cell?.textLabel?.font = UIFont.systemFont(ofSize: DeviceType.IS_IPAD ? 20:16.5)
            cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: DeviceType.IS_IPAD ? 16:12.5)
            cell?.detailTextLabel?.sizeToFit()
        }
        
        let string = self.titles["\(indexPath.section)"]
        let titleArray = string?.components(separatedBy: ",")
        let titles = titleArray?[indexPath.row]
        let titleA = titles?.components(separatedBy: ":")
        cell!.textLabel?.text = titleA?[0]
        cell?.detailTextLabel?.text = titleA?[1]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let section = indexPath.section;
        let row = indexPath.row;
        
        switch section {
        case 0:
            if row == 0 {
                var url = "https://m.youdao.com/dict?"
                if UIDevice.current.userInterfaceIdiom == .pad {
                    url = "https://dict.youdao.com/w/eng/"
                }
                let urlEncoding = url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
                let URLs = URL.init(string: urlEncoding!)!
                if #available(iOS 9.0, *) {
                    let sfvc = SFSafariViewController.init(url: URLs)
                    sfvc.hidesBottomBarWhenPushed = true
                    sfvc.title = "Search"
                    if #available(iOS 10.0, *) {
                        sfvc.preferredBarTintColor = kColorAppMain
                        sfvc.preferredControlTintColor = UIColor.white
                    }
                    if #available(iOS 11.0, *) {
                        sfvc.dismissButtonStyle = .close
                        sfvc.navigationItem.largeTitleDisplayMode = .never
                    }
                    self.navigationController?.pushViewController(sfvc, animated: true)
                } else {
                    // Fallback on earlier versions
                    if UIApplication.shared.canOpenURL(URLs) {
                        UIApplication.shared.openURL(URLs)
                    }
                }
            }
            if row == 1 {
                let vc = IELanguageTableViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            break;
        case 1:
            if row == 0 {
                if #available(iOS 10.3, *) {
                    SKStoreReviewController.requestReview()
                } else {
                    gotoAppstore(isAssessment: true)
                }
            }
            if row == 1 {
                gotoAppstore(isAssessment: true)
            }
            if row == 2 {
                
                let image = #imageLiteral(resourceName: "iEnglish")
                let url = NSURL(string: kAppDownloadURl)
                let string = "Hello, \(kAppName)! 这是英语初学者必备的单词学习的好工具，强烈推荐给你哦！希望它能成为你英语学习的快速阶梯！" + "iOS下载链接：" + kAppDownloadURl
                let activityController = UIActivityViewController(activityItems: [image ,url!,string], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)
                
                //                ITCommonAPI().checkAppUpdate(newHandler: { (isNew, version, error) in
                //                    if isNew {
                //
                //                    }
                //                })
            }
            
            break
        case 2:
            if row == 0 {
                openWebview(url: "https://raw.githubusercontent.com/Winston/iEnglish/master/LICENSE")
            }
            if row == 1 {
                gotoAppstore(isAssessment: true)
            }
            if row == 2 {
                let message = "欢迎来信，写下你的问题吧" + "\n\n\n\n" + kMarginLine + "\n 当前\(kAppName)版本：" + KAppVersion + "， 系统版本：" + String(Version.SYS_VERSION_FLOAT) + "， 设备信息：" + UIDevice.init().modelName
                
                ITCommonAPI.sharedInstance.sendEmail(recipients: [kEmail], messae: message, vc: self)
            }
            if row == 3 {
                openWebview(url: kGithubURL)
            }
            if row == 4 {
                let vc = ITAboutAppVC()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            break
            
        default: break
            
        }
    }
    
    
    func openWebview(url: String) {
        if #available(iOS 9.0, *) {
            let sfvc = SFSafariViewController(url: URL(string: url
                )!, entersReaderIfAvailable: true)
            if #available(iOS 10.0, *) {
                sfvc.preferredBarTintColor = kColorAppMain
                sfvc.preferredControlTintColor = UIColor.white
            }
            if #available(iOS 11.0, *) {
                sfvc.dismissButtonStyle = .close
                sfvc.navigationItem.largeTitleDisplayMode = .never
            }
            present(sfvc, animated: true)
        } else {
            if UIApplication.shared.canOpenURL(URL.init(string: url )!) {
                UIApplication.shared.openURL(URL.init(string: url)!)
            }
        }
    }
}
