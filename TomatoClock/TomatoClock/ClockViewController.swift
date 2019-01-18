//
//  ClockViewController.swift
//  TomatoClock
//
//  Created by shaojie on 2019/1/6.
//

import UIKit

import AudioToolbox //系统声音服务

import AVFoundation //多媒体服务

class ClockViewController: UIViewController {

    @IBOutlet weak var ClockBackground: UIImageView!        //背景图片
    @IBOutlet weak var ClockSecond: UILabel!                //计秒
    @IBOutlet weak var ClockMinute: UILabel!                //计分
    var audioPlayer:AVAudioPlayer!                  //背景声音播放控件
    var time:Int!                                   //计时器时间

    
    let btn:UIButton = UIButton(frame: CGRect(x: 75, y: 530, width: 45, height: 45))        //创建计时器按钮
    var Option:Int!             //接收上个界面传回的“时间选择”变量
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playBgMusic()      //初始化音乐播放器
    
        //加载场景时随机换背景
        var imageNames=["1","2","6","7","8"]
        let random1 = arc4random_uniform(UInt32(imageNames.count))
        let backgroud_filename = imageNames[Int(random1)]
        ClockBackground.image=UIImage(named: backgroud_filename)
        
        //计时器按钮初始化，绑定事件
        btn.setBackgroundImage(UIImage(named: "bofang"), for: UIControl.State.normal)
        view.addSubview(btn)
        btn.addTarget(self, action: #selector(timeChange), for: .touchUpInside)
        
    }
    
    @objc func timeChange() {       // 启动时间源
        
        Option = (presentingViewController as! ViewController ).op  //P291
        switch Option {             //计时器时间设置，上一个故事板传回选择op值
        case 1:
            time = 20            //调试暂时修改，原为600
        case 2:
            time = 1500
        case 3:
            time = 2700
        default:
            time = 10
        }
        
        //计时器核心部分
        let codeTimer = DispatchSource.makeTimerSource(flags: .init(rawValue: 0), queue: DispatchQueue.global())
        codeTimer.schedule(deadline: .now(), repeating: .milliseconds(1000))  //此处方法与Swift 3.0 不同
        codeTimer.setEventHandler {
            
            self.time = self.time  - 1
            
            DispatchQueue.main.async {
                self.btn.isEnabled = false
            }
            
             if self.time < 0 {
                codeTimer.cancel()
                DispatchQueue.main.async {
                    self.btn.isEnabled = true
                    //这里是计时器完成计时之后的操作，在这里控制计时器按钮的变化，也在这里控制提醒功能
                    //self.btn.setImage(UIImage(named: "shuaxin"), for: UIControl.State.normal)    //此处改为刷新图标，可以再次点击开始新的一轮计时
                    
                    if self.audioPlayer.isPlaying{      //计时完成的时候，如果音乐在播放就停止
                        self.audioPlayer.stop()
                    }
                    self.systemAlert()          //计时完成，调用提醒函数！
                }
                return
            }
            
            DispatchQueue.main.async {          //此处对主界面的label进行刷新操作，关于时间的标准化也写在这里
                var min:Int = self.time/60
                var sec:Int = self.time%60
                self.ClockMinute.text="\(min)"      //对于分钟的标准化
                if sec<10{                          //对于秒钟的标准化
                    self.ClockSecond.text="0\(sec)"
                }
                else {
                    self.ClockSecond.text="\(sec)"
                }
            }
            
        }
        
        codeTimer.activate()
        
    }
    
    func playBgMusic(){                 //背景音乐播放器的参数设置
        let musicPath = Bundle.main.path(forResource: "bgmusic", ofType: "mp3")
        let musicURL = NSURL(fileURLWithPath: musicPath!)
        do{
            self.audioPlayer = try AVAudioPlayer(contentsOf: musicURL as URL)
        }catch let error as NSError {
            print(error.description)
        }
        audioPlayer.numberOfLoops = -1      //-1为循环播放
        audioPlayer.volume = 1              //0～1的值表示音量大小
        audioPlayer.prepareToPlay()         //将声音文件载入到缓冲区
    }
    
    
    @IBAction func systemAlert (){              //这里是提醒函数，发出声音
        var soundID:SystemSoundID = 0;                  //计时完成提示音播放控件
        let path = Bundle.main.path(forResource: "alert", ofType: "wav")
        let baseURL = NSURL(fileURLWithPath: path!)
        AudioServicesCreateSystemSoundID(baseURL, &soundID)
        AudioServicesPlayAlertSound(soundID)
    }
    
    @IBAction func PlayButton(_ sender: Any) {  //音乐播放控制
        if !audioPlayer.isPlaying{
            audioPlayer.play()
        }
        else{
            audioPlayer.stop()
        }
        
    }
    
    
    @IBAction func stopMusicWhenExit(_ sender: Any) {   //退出计时界面的时候把音乐关闭
        if audioPlayer.isPlaying{
            audioPlayer.stop()
        }
        self.time=99999             //转场之后计时器其实没有停止，给他放大在不可能的值防止后台播放
        //audioPlayer = nil       //退出场景的时候销毁这个播放器，防止多重播放
    }
    
}

