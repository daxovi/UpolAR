//
//  ContentView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 03.06.2023.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel = ContentViewModel()
    @ObservedObject var locationManager = LocationManager.shared
    
    var body: some View {
        ZStack {
            if let destination = $locationManager.distanceToDestination.wrappedValue
            {
                if destination < 500 {
                    CloseView()
                } else {
                    RemoteView(distance: $locationManager.distanceToDestination)
                }
            }
            else {
                Text("nemám data na určování vzdálenosti")
            }
            
        }
        .sheet(isPresented: $viewModel.isLocationSheetShown) {
            LocationSheetView(isLocationSheetShown: $viewModel.isLocationSheetShown)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
