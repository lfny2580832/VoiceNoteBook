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
    ///本地音频列表索引
    var records: [NSString]?
    let defaults = UserDefaults.standard
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    let session:AVAudioSession = AVAudioSession.sharedInstance()
    let recordSettings:[String : AnyObject] = [
        AVFormatIDKey:             NSNumber(value: kAudioFormatMPEG4AAC),
        AVEncoderAudioQualityKey : NSNumber(value:AVAudioQuality.max.rawValue),
        AVEncoderBitRateKey :      NSNumber(value:320000),
        AVNumberOfChannelsKey:     NSNumber(value:2),
        AVSampleRateKey :          NSNumber(value:44100.0)
    ]

    private override init() {
        super.init()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        records = recordingList()
    }

    ///开始录制
    func startRecording()  {
        try! session.setActive(true)
        initRecorder()
        recorder.prepareToRecord()
        recorder.record()
    }
    
    ///结束录制
    func stopRecording() {
        do{
            recorder.stop()
            try session.setActive(false)

        } catch let error as NSError {
            print("could not make session inactive")
            print(error.localizedDescription)
        }
    }
    
    ///初始化recorder
    func initRecorder() {
        
        do {
            latestFilePath = audioFilePath()
            recorder = try AVAudioRecorder(url: latestFilePath, settings: recordSettings)
            recorder.delegate = self
        } catch let error as NSError {
            recorder = nil
            print(error.localizedDescription)
        } catch {
            print("初始化失败")
        }
    }
    
    ///音频文件路径
    func audioFilePath() -> URL {
        return documentsDirectory.appendingPathComponent(fileName())
    }
    
    ///文件名
    func fileName() -> String {
        let format = DateFormatter()
        format.dateFormat="yyyy.MM.dd-HH:mm:ss"
        return "\(format.string(from: Date())).aac"
    }
    
    ///从UserDefault读取记录索引，本类初始化时调用
    func recordingList() -> [NSString]? {
        let temp: [NSString]? = defaults.array(forKey: UserDefaultRecords) as! [NSString]?
        if let r = temp {
            return r
        }else{
            return [NSString]()
        }
    }
    
    ///将最新的音频索引存入UserDefault
    func saveRecords() {
        records!.append(latestFilePath!.absoluteString as NSString)
        defaults.set(records!, forKey: UserDefaultRecords)
        defaults.synchronize()
    }
}


extension RecordManager: AVAudioRecorderDelegate{
    
    //录制完成
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder,successfully flag: Bool) {
        self.recorder = nil
        saveRecords()
        print("文件录制完成，准备上传七牛云");
        //上传七牛
    }
    
    //录制出错
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder,error: Error?) {
        if let e = error {
            print("\(e.localizedDescription)")
        }
    }
}
