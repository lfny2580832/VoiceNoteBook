//
//  VoiceSpectrumView.swift
//  VoiceNoteBook
//
//  Created by 牛严 on 2016/11/24.
//  Copyright © 2016年 牛严. All rights reserved.
//

import UIKit

typealias itemLevelPowerBlock = ()->Void

class VoiceSpectrumView: UIView {

    let soundSpace     :Double = 2
    let soundWaveWidth :Double = 4
    let soundOriginHeight :Double = 2
    
    var getLevelBlock   : (()->Void)?
    var leftItems       : [CALayer]?
    var rightItems      : [CALayer]?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initItems()

    }

    func soundPower(handler:@escaping ()->Void){
        getLevelBlock = handler
        let link = CADisplayLink.init(target: self, selector: #selector(doGetLevelBlock))
        link.preferredFramesPerSecond = 10
        link.add(to: RunLoop.current, forMode: .commonModes)
    }

    @objc private func doGetLevelBlock()  {
        if let block = getLevelBlock{
            block()
        }
    }
    
    func setLevel(_ level:Float?) {
        if let level = level{
            var height : Float = 0
            if abs(level)>=50 {
                height = 50
            }else if abs(level)<=10 {
                height = 10
            }else{
                height = abs(level)
            }
            let finalHeight = (50 - height)/5 * 1.5
            print("--\(level)--\(height)--\(finalHeight)")

            rightItemsAnimate(height: finalHeight)
            leftItemsAnimate(height: finalHeight)
        }
    }
    
    func rightItemsAnimate(height:Float) {
        if let rightItems = self.rightItems {
            let layer = rightItems[0]
            layer.bounds = CGRect(x:0,y:0,width:soundWaveWidth,height:Double(3 + height))
            for i in (1..<10).reversed() {
                let preLayer = rightItems[i]
                let layer = rightItems[i-1]
                preLayer.bounds = layer.bounds
            }
        }
    }
    
    func leftItemsAnimate(height:Float) {
        if let leftItems = self.leftItems {
            let layer = leftItems[9]
            layer.bounds = CGRect(x:0,y:0,width:soundWaveWidth,height:Double(3 + height))
            for i in 0..<9 {
                let preLayer = leftItems[i]
                let layer = leftItems[i+1]
                preLayer.bounds = layer.bounds
            }
        }
        
        let _ = CGRect(x:1.0,y:0,width:1,height:1)
    }
    
    func initItems() {
        initLeftItems()
        initRightItems()
    }
    
    func initLeftItems() {
        leftItems = NSArray.init() as? [CALayer]
        for i in 0..<10 {
            let item = CALayer.init()
            item.backgroundColor = UIColor.blue.cgColor
            item.position = CGPoint(x:(Double(i)*soundWaveWidth + soundSpace*Double(i+1)),y:10)
            item.bounds = CGRect(x:0,y:0,width:soundWaveWidth,height:3)
            leftItems?.append(item )
            layer.addSublayer(item)
        }
    }
    
    func initRightItems() {
        rightItems = NSArray.init() as? [CALayer]
        for i in 0..<10 {
            let item = CALayer.init()
            item.backgroundColor = UIColor.blue.cgColor
            let x: Double = 100 + Double(i)*soundWaveWidth + soundSpace*Double(i+1)
            item.position = CGPoint(x:x,y:10)
            item.bounds = CGRect(x:0,y:0,width:soundWaveWidth,height:3)
            rightItems?.append(item )
            layer.addSublayer(item)
        }
    }
}
