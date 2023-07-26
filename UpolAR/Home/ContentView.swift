//
//  ContentView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 03.06.2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ContentViewModel()
    
    var body: some View {
        NavigationStack {
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
                if viewModel.distanceToDestination != nil {
                    // Zjistí jestli je uživatel ve vzdálenosti od místa definovaném v LocationManager
                    if viewModel.isUserInPlace {
                        // View pro zobrazení v místě
                        CloseView()
                    } else {
                        // View pro zobrazení ve větší vzdálenosti
                        RemoteView(distance: $viewModel.distanceToDestination)
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
            BoardingSheetView(isLocationSheetShown: $viewModel.isLocationSheetShown)
        }
        .statusBar(hidden: true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
