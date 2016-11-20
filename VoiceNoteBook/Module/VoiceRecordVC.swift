//
//  VoiceRecordVC.swift
//  VoiceNoteBook
//
//  Created by 牛严 on 2016/11/18.
//  Copyright © 2016年 牛严. All rights reserved.
//

import UIKit

class VoiceRecordVC: UIViewController {

    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet var playBtn: UIButton!
    
    var time : Int = 0
    var timer = CADisplayLink(target: self, selector: #selector(counting))

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "录音"
        playBtn.isHidden = true

        if isFirsLaunch()  {
            QiniuManager.sharedInstance.downloadRecords()
        }
        
        //提前触发权限，以免第一次会录一小段没用的声音
        RecordManager.VNRecorder.startRecording()
        RecordManager.VNRecorder.stopRecording(save: false)
    }
    
    func isFirsLaunch() -> Bool {
        let launchedBefore = UserDefaults.standard.bool(forKey: "isFirsLaunch")
        if launchedBefore  {
            return false
        } else {
            UserDefaults.standard.set(true, forKey: "isFirsLaunch")
            return true
        }
    }
    
    @IBAction func pushRecordListVC(_ sender: AnyObject) {
        let listVC = RecordListVC()
        self.navigationController?.pushViewController(listVC, animated: true)
    }

    @IBAction func recordBtnDownAction(_ sender: AnyObject) {
        print("开始录制");
        playBtn.isHidden = true
        
        startCounting()
        recordBtnTapAnimation()
        PlayerManager.VNPlayer.stopPlaying()
        RecordManager.VNRecorder.startRecording()
    }
    
    @IBAction func recordBtnUpAction(_ sender: AnyObject) {
        print("停止录制")
        playBtn.isHidden = false
        playBtn.setImage(UIImage.init(named: "start"), for: .normal)

        if(time < 30) {
            stopCounting()
            alert()
            playBtn.isHidden = true
            RecordManager.VNRecorder.stopRecording(save: false)
            return
        }
        stopCounting()
        RecordManager.VNRecorder.stopRecording(save: true)

    }
    
    @IBAction func playBtnTap(_ sender: AnyObject) {
        
        PlayerManager.VNPlayer.play(url:RecordManager.VNRecorder.latestFilePath, aDelegate: self as PlayerManagerProtocal)
    }
    
    ///点击录音按钮动画
    func recordBtnTapAnimation()  {
        UIView .animate(withDuration: 0.08, animations: {
            self.recordBtn.frame.size = CGSize(width:170,height:170)
            self.recordBtn.center = self.view.center
        }) { (finishi:Bool) in
            UIView .animate(withDuration: 0.08, animations: {
                self.recordBtn.frame.size = CGSize(width:150,height:150)
                self.recordBtn.center = self.view.center
            })
        }
    }
    
    ///开始计时
    func startCounting()  {
        timer = CADisplayLink(target: self, selector: #selector(counting))
        timer.preferredFramesPerSecond = 60
        timer.add(to: RunLoop.current, forMode: .commonModes)
    }
    
    ///计时
    func counting()  {
        time = time + 1
    }
    
    func stopCounting()  {
        time = 0
        timer.invalidate()
    }

    func alert() {
        let alert = UIAlertController(title: "按键时间太短",message: nil,preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确认", style: .default, handler: {action in }))
        self.present(alert, animated:true, completion:nil)
    }
}

extension VoiceRecordVC:PlayerManagerProtocal{
    func playerManagerStart() {
        self.playBtn.setImage(UIImage.init(named: "pause"), for: .normal)
    }
    
    func playerManagerStop() {
        self.playBtn.setImage(UIImage.init(named: "start"), for: .normal)
    }
}
