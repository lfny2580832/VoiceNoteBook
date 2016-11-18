//
//  VoiceRecordVC.swift
//  VoiceNoteBook
//
//  Created by 牛严 on 2016/11/18.
//  Copyright © 2016年 牛严. All rights reserved.
//

import UIKit

class VoiceRecordVC: UIViewController {

    @IBOutlet weak var recordBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "录音"
        recordBtn.layer.cornerRadius = 50
    }

    @IBAction func pushRecordListVC(_ sender: AnyObject) {
        let listVC = RecordListVC()
        self.navigationController?.pushViewController(listVC, animated: true)
    }

    @IBAction func RecordBtnDownAction(_ sender: AnyObject) {
        print("按住");
    }
    
    @IBAction func RecordBtnUpAction(_ sender: AnyObject) {
        print("松开")
    }

}
