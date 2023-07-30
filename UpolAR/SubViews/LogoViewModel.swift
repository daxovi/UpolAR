//
//  LogoViewModel.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 26.06.2023.
//

import SwiftUI

class LogoViewModel: ObservableObject {
    var tapCounter: Int = 0
    func tap() {
        self.tapCounter = self.tapCounter + 1
        if tapCounter > 5 {
            self.tapCounter = 0
            LocationManager.shared.fakeDistance()
        }
    }
}
