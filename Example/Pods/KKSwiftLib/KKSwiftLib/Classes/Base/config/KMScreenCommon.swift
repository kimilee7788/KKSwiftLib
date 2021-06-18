//
//  KMScreenCommon.swift
//  Scanner7
//
//  Created by lee kimi on 2021/5/8.
//

import Foundation

let SCREENWIDTH:CGFloat = UIScreen.main.bounds.size.width
let SCREENHEIGHT:CGFloat = UIScreen.main.bounds.size.height
var isFullScreen: Bool {
    guard #available(iOS 11.0, *) else {
        return false
    }
    return UIApplication.shared.windows[0].safeAreaInsets.bottom > 0
}

let IS_PAD:Bool = UIDevice.current.userInterfaceIdiom == .pad

let NAV_STATUS:CGFloat = isFullScreen ? CGFloat(44):CGFloat(20)

let TAB_SPACE:CGFloat = isFullScreen ? CGFloat(34):CGFloat(0)

let TAB_HEIGHT:CGFloat = isFullScreen ? CGFloat(83):CGFloat(49)

let NAV_HEIGHT:CGFloat = isFullScreen ? CGFloat(88):CGFloat(64)

// The default is 0, 0 for full screen return, and also for distance.（默认为0，0为全屏返回，也可指定距离）
let KMDistanceToStart:CGFloat! = 50

public enum KMInterfaceStyle : Int {

    case unspecified = 0

    case light = 1

    case dark = 2
}


