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
        NavigationView {
            ZStack {
                Color("BlueColor").ignoresSafeArea()
                VStack {
                    HStack {
                        Image("Lines")
                        Spacer()
                    }
                    Spacer()
                    
                }
                .ignoresSafeArea()
            
                // Zjistí jestli má aplikace přístup k poloze
                if locationManager.distanceToDestination != nil
                {
                    
                    // Zjistí jestli je uživatel v okruhu od místa definovaném v LocationManager
                    if locationManager.isUserInPlace {
                        
                        // View pro zobrazení v místě
                        CloseView()
                        
                    } else {
                        
                        // View pro zobrazení ve větší vzdálenosti
                        RemoteView(distance: $locationManager.distanceToDestination)
                    }
                }
                
                else {
                    
                    // View pokud aplikace nemá data o poloze
                    NoLocationView()
                }
            }
        }
        // Pokud aplikace nemá data o poloze zobrazí se sheet s požadavkem na udělení práv k používání polohy
        .sheet(isPresented: $viewModel.isLocationSheetShown) {
            LocationSheetView(isLocationSheetShown: $viewModel.isLocationSheetShown)
        }
        .statusBar(hidden: true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
