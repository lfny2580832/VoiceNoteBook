//
//  RecordService.swift
//  VoiceNoteBook
//
//  Created by 牛严 on 2016/11/18.
//  Copyright © 2016年 牛严. All rights reserved.
//

import UIKit
import AVFoundation


class RecordManager: NSObject{

    static let VNRecorder = RecordManager()
    
    var recorder: AVAudioRecorder!
    
    let recordSettings:[String : AnyObject] = [
        AVFormatIDKey:             NSNumber(value: kAudioFormatAppleLossless),
        AVEncoderAudioQualityKey : NSNumber(value:AVAudioQuality.max.rawValue),
        AVEncoderBitRateKey :      NSNumber(value:320000),
        AVNumberOfChannelsKey:     NSNumber(value:2),
        AVSampleRateKey :          NSNumber(value:44100.0)
    ]

    private override init() {
        super.init()

        
    }

    func startRecording()  {
        initRecorder()
        recorder.prepareToRecord()
        recorder.record()
    }
    
    func stopRecording() {
        
    }
    
    

    func initRecorder() {
        
        let url: URL! = filePath()
        print("文件路径: '\(url)'")
        
        do {
            recorder = try AVAudioRecorder(url: filePath(), settings: recordSettings)
            recorder.delegate = self
            recorder.isMeteringEnabled = true
            recorder.prepareToRecord()
        } catch let error as NSError {
            recorder = nil
            print(error.localizedDescription)
        }
    }
    
    func filePath() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsDirectory.appendingPathComponent(fileName())
    }
    
    func fileName() -> String {
        let format = DateFormatter()
        format.dateFormat="yyyy年MM月dd日HH时mm分ss秒"
        return "\(format.string(from: Date()))的录音.m4a"
    }

}


extension RecordManager: AVAudioRecorderDelegate{
    
    //录制完成
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder,successfully flag: Bool) {

        
    }
    
    //录制出错
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder,error: Error?) {
        
        if let e = error {
            print("\(e.localizedDescription)")
        }
    }

}
