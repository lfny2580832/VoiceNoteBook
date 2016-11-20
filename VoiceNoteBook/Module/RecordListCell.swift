//
//  RecordListCell.swift
//  VoiceNoteBook
//
//  Created by 牛严 on 2016/11/18.
//  Copyright © 2016年 牛严. All rights reserved.
//

import UIKit

protocol RecordListCellDelegate{
    func playWithModel(record:RecordModel)
}

class RecordListCell: UITableViewCell {

    @IBOutlet var playBtn: UIButton!
    
    var delegate : RecordListCellDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    @IBAction func playBtnClicked(_ sender: AnyObject) {
        self.delegate?.playWithModel(record: model)
    }
    
    var model : RecordModel! {
        didSet{
            self.textLabel?.text = model.path.lastPathComponent
            if(model.playType == .stop) {
                playBtn.setImage(UIImage.init(named: "start"), for: .normal)
            }else{
                playBtn.setImage(UIImage.init(named: "pause"), for: .normal)
            }
        }
    }
}

