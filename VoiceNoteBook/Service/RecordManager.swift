//
//  RecordService.swift
//  VoiceNoteBook
//
//  Created by 牛严 on 2016/11/18.
//  Copyright © 2016年 牛严. All rights reserved.
//

import AVFoundation

let UserDefaultRecords = "userDefaultRecords"

class RecordManager: NSObject{

    static let VNRecorder = RecordManager()
    
    var recorder: AVAudioRecorder!
    ///每次录音完成后赋值，确保player可以播放最近一次的录音
    var latestFilePath: URL!

    let defaults = UserDefaults.standard
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    let recordSettings:[String : AnyObject] = [
        AVFormatIDKey:             NSNumber(value: kAudioFormatMPEG4AAC),
        AVEncoderAudioQualityKey : NSNumber(value:AVAudioQuality.max.rawValue),
        AVEncoderBitRateKey :      NSNumber(value:320000),
        AVNumberOfChannelsKey:     NSNumber(value:2),
        AVSampleRateKey :          NSNumber(value:44100.0)
    ]

    private override init() {
        super.init()
    }
    
    ///开始录制
    func startRecording()  {
        setSessionStatus(isActive: true)
        initRecorder()
        recorder.prepareToRecord()
        recorder.record()
    }
    
    ///结束录制
    func stopRecording() {
        recorder.stop()
        setSessionStatus(isActive: false)
    }
    
    ///获取本地音频文件路径
    func recordingList() -> [URL] {
        do {
            let urls = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
            return urls.filter( { (name: URL) -> Bool in
                return name.lastPathComponent.hasSuffix(".aac")
            })
            
        } catch let error as NSError {
            print(error.localizedDescription)
            return [URL]()
        }
    }
    
    ///设置session类型及状态（需与player进行区分）
    private func setSessionStatus(isActive: Bool)  {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try! session.setActive(isActive)
    }

    ///初始化recorder
    private func initRecorder() {
        do {
            latestFilePath = audioFilePath()
            recorder = try AVAudioRecorder(url: latestFilePath, settings: recordSettings)
            recorder.delegate = self
        } catch let error as NSError {
            stopRecording()
            print(error.localizedDescription)
        }
    }
    
    ///音频文件路径
     private func audioFilePath() -> URL {
        return documentsDirectory.appendingPathComponent(fileName())
    }
    
    ///文件名
    private func fileName() -> String {
        let format = DateFormatter()
        format.dateFormat="yyyy-MM-dd HH:mm:ss"
        return "\(format.string(from: Date())).aac"
    }
}


extension RecordManager: AVAudioRecorderDelegate{
    
    //录制完成
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder,successfully flag: Bool) {
        stopRecording()
        //上传七牛
        let name = latestFilePath!.lastPathComponent
        let path = (latestFilePath! as NSURL).path
        DispatchQueue.global().async {
            QiniuManager.sharedInstance.uploadRecord(name: name,path: path)
        }
    }
    
    //录制出错
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder,error: Error?) {
        if let e = error {
            print("\(e.localizedDescription)")
        }
    }
}
