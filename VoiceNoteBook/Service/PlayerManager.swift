//
//  PlayerManager.swift
//  VoiceNoteBook
//
//  Created by 牛严 on 2016/11/18.
//  Copyright © 2016年 牛严. All rights reserved.
//

import AVFoundation

@objc protocol PlayerManagerProtocal {
    
    @objc optional func playerManagerStart()
    @objc optional func playerManagerStop()
    @objc optional func playerManagerStartWithRecord(record:RecordModel)
    @objc optional func playerManagerStopWithRecord(record:RecordModel)
}

class PlayerManager: NSObject{
    
    static let VNPlayer = PlayerManager()

    let session:AVAudioSession = AVAudioSession.sharedInstance()
    var player:AVAudioPlayer!
    var aDelegate : PlayerManagerProtocal?

    var recordModel : RecordModel?
    
    private override init() {
        super.init()
    }
    
    ///设置session类型及状态（需与recorderer进行区分）
    private func setSessionStatus(isActive: Bool)  {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayback)
        try! session.setActive(isActive)
    }
    
    ///播放指定路径的音频
    func play( url:URL, aDelegate:PlayerManagerProtocal)  {
        stopPlaying()
        
        self.aDelegate = aDelegate
        setSessionStatus(isActive: true)
        do {
            player = try AVAudioPlayer.init(contentsOf: url)
            player.prepareToPlay()
            player.volume = 6.0
            player.delegate = self
            player.play()
            self.aDelegate?.playerManagerStart!()
        } catch let error as NSError {
            stopPlaying()
            print(error.localizedDescription)
        }
    }
    
    ///播放指定Model的音频
    func play( record:RecordModel! ,aDelegate:PlayerManagerProtocal)  {
        stopPlaying()

        self.aDelegate = aDelegate
        setSessionStatus(isActive: true)
        do {
            player = try AVAudioPlayer.init(contentsOf: record.path)
            record.playType = .playing
            self.recordModel = record
            self.aDelegate?.playerManagerStartWithRecord!(record: record)
        } catch let error as NSError {
            stopPlaying()
            print(error.localizedDescription)
            return
        }
        player.prepareToPlay()
        player.volume = 6.0
        player.delegate = self
        player.play()
        
    }
    
    ///停止当前正在播放的音频
    func stopPlaying() {
        if (player != nil) {
            player.stop()
            player = nil
            if self.recordModel != nil {
                self.recordModel?.playType = .stop
                self.aDelegate?.playerManagerStopWithRecord!(record: self.recordModel!)
                self.recordModel = nil
            }else {
                self.aDelegate?.playerManagerStop!()
            }
            setSessionStatus(isActive: false)
        }
    }
}


extension PlayerManager : AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {

        stopPlaying()
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let e = error {
            print("\(e.localizedDescription)")
        }
    }
}
