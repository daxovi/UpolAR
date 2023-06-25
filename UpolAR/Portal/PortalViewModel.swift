//
//  PortalViewModel.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 15.06.2023.
//

import SwiftUI

class PortalViewModel: ViewModel {
    
    private var roomNr: Int
    private let images: [String]
    
    let fileExtension: String
    
    @Published var roomFileName: String
    
    override init() {
        self.roomNr = 0
        self.images = ["christmas", "sunset", "oldcity", "beach"]
        self.fileExtension = "jpg"
        
        self.roomFileName = self.images[self.roomNr]
        super.init()
    }
    
    func nextRoom() {
        self.roomNr = (self.roomNr + 1) % images.count
        self.roomFileName = images[roomNr]
        print("DEBUG: viewmodel init. roomNr: \(roomNr)")
    }
    
    func prevRoom() {
        self.roomNr = (self.roomNr - 1 + images.count) % images.count
        self.roomFileName = images[roomNr]
    }
}
