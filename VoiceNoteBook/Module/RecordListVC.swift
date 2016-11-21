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
    }
    
    func recordingModelList(list:[URL]!) -> [RecordModel] {
        var i : Int = 0
        return list.map { (url) -> RecordModel in
            let model = RecordModel()
            model.path = url
            model.playType = .stop
            model.index = i
            i = i + 1
            return model
        }
    }
}

extension RecordListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelList.count
    }
}

extension RecordListVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier : String = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? RecordListCell
        cell?.model = modelList[indexPath.row]
        cell?.delegate = self
        return cell!
    }

}

extension RecordListVC: RecordListCellDelegate {
    func playWithModel(record:RecordModel) {
        PlayerManager.VNPlayer.play(record: record, aDelegate: self)
    }
}

extension RecordListVC: PlayerManagerProtocal{
    func playerManagerStopWithRecord(record: RecordModel) {
        reloadModel(record: record)
    }
    
    func playerManagerStartWithRecord(record: RecordModel) {
        reloadModel(record: record)
    }
    
    func reloadModel(record:RecordModel) {
        self.modelList.remove(at: record.index)
        self.modelList.insert(record, at: record.index)
        self.tableView.reloadRows(at: [IndexPath.init(row: record.index, section: 0)], with: .none)
    }
}
