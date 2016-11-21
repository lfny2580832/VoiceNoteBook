//
//  RecordListCell.swift
//  VoiceNoteBook
//
//  Created by 牛严 on 2016/11/18.
//  Copyright © 2016年 牛严. All rights reserved.
//

import UIKit

@objc protocol RecordListCellDelegate{
    func playWithModel(record:RecordModel)
}

class RecordListCell: UITableViewCell {

    @IBOutlet var playBtn: UIButton!
    
    weak var delegate : RecordListCellDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    @IBAction func playBtnClicked(_ sender: AnyObject) {
        if let model = self.recordModel {
            self.delegate?.playWithModel(record: model)
        }
    }
    
    var recordModel : RecordModel? {
        didSet{
            self.textLabel?.text = recordModel?.path.lastPathComponent
            if(recordModel?.playType == .stop) {
                playBtn.setImage(UIImage.init(named: "start"), for: .normal)
            }else{
                playBtn.setImage(UIImage.init(named: "pause"), for: .normal)
            }
        }
    }
}

