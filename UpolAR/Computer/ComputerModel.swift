//
//  ComputerModel.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 25.06.2023.
//

import Foundation

class ComputerModel {
    var screenWidth: Float
    var screenHeight: Float
    var anchorName: String
    var videoName: String
    
    init(screenWidth: Float, screenHeight: Float, anchorName: String, videoName: String) {
        self.screenWidth = screenWidth
        self.screenHeight = screenHeight
        self.anchorName = anchorName
        self.videoName = videoName
    }
}
