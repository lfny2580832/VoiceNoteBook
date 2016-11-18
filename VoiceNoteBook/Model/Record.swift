//
//  RecordModel.swift
//  VoiceNoteBook
//
//  Created by 牛严 on 2016/11/18.
//  Copyright © 2016年 牛严. All rights reserved.
//

import UIKit

public class Record: NSObject {
    
    ///录音文件标题
    public var title: String!
    
    ///录音文件存储路径
    public var filePath: URL!
    
    override public var description: String {
        return "标题\(title!),地址\(filePath!)"
    }
}
