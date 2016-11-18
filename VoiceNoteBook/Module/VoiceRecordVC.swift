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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "录音"
        recordBtn.layer.cornerRadius = 50
        playBtn.isHidden = true
    }

    @IBAction func pushRecordListVC(_ sender: AnyObject) {
        let listVC = RecordListVC()
        self.navigationController?.pushViewController(listVC, animated: true)
    }

    @IBAction func recordBtnDownAction(_ sender: AnyObject) {
        print("开始录制");
        playBtn.isHidden = true
        PlayerManager.VNPlayer.stopPlaying()
        RecordManager.VNRecorder.startRecording()
    }
    
    @IBAction func recordBtnUpAction(_ sender: AnyObject) {
        print("停止录制")
        playBtn.isHidden = false
        RecordManager.VNRecorder.stopRecording()
    }
    
    @IBAction func playBtnTap(_ sender: AnyObject) {
        print("播放最近录制成功的音频")
        PlayerManager.VNPlayer.playLatest()
    }

}
