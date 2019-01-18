//
//  ViewController.swift
//  TomatoClock
//
//  Created by shaojie on 2019/1/6.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var background: UIImageView!     //模糊背景图
    
    @IBOutlet weak var clearBackground: UIImageView!    //前景清晰背景图
    
    var op:Int!                                     //存储选择的变量
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //随机背景图片加载功能
        var imageNames=["1","2","6","7","8"]
        let random1 = arc4random_uniform(UInt32(imageNames.count))
        let backgroud_filename = imageNames[Int(random1)]
        background.image=UIImage(named: backgroud_filename)
        clearBackground.image=UIImage(named:backgroud_filename)
        
    }
  
    //三个按钮对应三个时间选择，然后把op传到Clock故事版
    @IBAction func setTime10(_ sender: Any) {
        op = 1
    }
    
    @IBAction func setTime25(_ sender: Any) {
        op = 2
    }
    
    @IBAction func setTime45(_ sender: Any) {
        op = 3
    }

    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        switch shortcutItem.type {
        case "one":
            //self.setTime10(<#Any#>)
            print("hello")
        //case "two":
            //self.setTime25(<#Any#>)
        default:
            break
        }
    }
    
    
    
    @IBAction func exitToHere(sender:UIStoryboardSegue){    //回退函数
        //no code needed
    }

    
}

