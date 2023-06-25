//
//  ViewModel.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 25.06.2023.
//

import SwiftUI

class ViewModel: ObservableObject {
    @Published var showingAlert: Bool
    
    init() {
        self.showingAlert = false
    }
    
    func showAlert() {
        self.showingAlert = true
    }
}
