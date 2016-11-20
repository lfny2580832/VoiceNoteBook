//
//  RecordListVC.swift
//  VoiceNoteBook
//
//  Created by 牛严 on 2016/11/18.
//  Copyright © 2016年 牛严. All rights reserved.
//

import UIKit

class RecordListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var recordingList = [URL]()
    var modelList = [RecordModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "音频列表"
        recordingList = RecordManager.VNRecorder.recordingList()
        modelList = recordingModelList(list: recordingList)
        print(modelList)
    }
    
    func recordingModelList(list:[URL]!) -> [RecordModel] {
        return list.map { (url) -> RecordModel in
            let model = RecordModel()
            model.path = url
            model.playType = .stop
            return model
        }
    }
}

extension RecordListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordingList.count
    }
}

extension RecordListVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier : String = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! RecordListCell
        cell.textLabel?.text = recordingList[indexPath.row].lastPathComponent
        cell.filePath = recordingList[indexPath.row].absoluteURL
        return cell
    }
}
