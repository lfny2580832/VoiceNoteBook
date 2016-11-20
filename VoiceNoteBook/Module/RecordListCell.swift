//
//  RecordListCell.swift
//  VoiceNoteBook
//
//  Created by 牛严 on 2016/11/18.
//  Copyright © 2016年 牛严. All rights reserved.
//

import UIKit

protocol PlayerManagerProtocal {
    
    func playerManagerStart()
    func playerManagerStop()
}


class RecordListCell: UITableViewCell {

    @IBOutlet var playBtn: UIButton!
    
    var filePath : URL!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }

    @IBAction func playBtnClicked(_ sender: AnyObject) {
        PlayerManager.VNPlayer.play(filePath, aDelegate: self as PlayerManagerProtocal)
    }
}

extension RecordListCell: PlayerManagerProtocal{
    
    func playerManagerStart() {
        self.playBtn.setImage(UIImage.init(named: "pause"), for: .normal)
    }
    
    func playerManagerStop() {
        self.playBtn.setImage(UIImage.init(named: "start"), for: .normal)
    }
}
