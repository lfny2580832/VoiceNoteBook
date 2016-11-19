//
//  PlayerManager.swift
//  VoiceNoteBook
//
//  Created by 牛严 on 2016/11/18.
//  Copyright © 2016年 牛严. All rights reserved.
//

import AVFoundation

class PlayerManager: NSObject{
    
    static let VNPlayer = PlayerManager()

    let session:AVAudioSession = AVAudioSession.sharedInstance()
    var player:AVAudioPlayer!

    private override init() {
        super.init()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
    }
    
    ///播放最近录制的音频
    func playLatest()  {
        play(RecordManager.VNRecorder.latestFilePath!)
    }
    
    ///播放指定路径的音频
    func play(_ url:URL)  {
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        do {
            player = try AVAudioPlayer.init(contentsOf: url)
            player.prepareToPlay()
            player.volume = 10.0
            player.delegate = self
            player.play()
        } catch let error as NSError {
            self.player = nil
            print(error.localizedDescription)
        } catch {
            print("player初始化失败")
        }
    }
    
    ///停止当前正在播放的音频，如果有的话
    func stopPlaying() {
        if (player != nil) {
            player.stop()
        }
    }
}


extension PlayerManager : AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("播放是否完成： \(flag)")
        self.player = nil
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let e = error {
            print("\(e.localizedDescription)")
        }
    }
}
