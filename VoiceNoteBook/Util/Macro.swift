//
//  Macro.swift
//  VoiceNoteBook
//
//  Created by 牛严 on 2016/11/18.
//  Copyright © 2016年 牛严. All rights reserved.
//

import UIKit

public let SCREEN_WIDTH = UIScreen.main.bounds.size.width
public let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

func RGBA (r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor{
    
    return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}
