//
//  RecordModel.swift
//  VoiceNoteBook
//
//  Created by 牛严 on 2016/11/20.
//  Copyright © 2016年 牛严. All rights reserved.
//

import UIKit

enum PlayType{
    case playing
    case stop
}

class RecordModel: NSObject {
    
    var path: URL!
    
    var playType: PlayType?
    
    override var description: String {
        return "\(path!):\(playType!)"
    }
}


