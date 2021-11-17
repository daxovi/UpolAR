//
//  ContentView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 17.11.2021.
//

import SwiftUI

struct ContentView: View {
    
    var text: String = TextLoad(textFile: "about_university")
                        
     var body: some View {
         
         ScrollView {
             Image("rektorat")
                 .resizable()
                 .scaledToFit()
             Text(.init(text))
                 .padding()
         }
         .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func TextLoad(textFile: String) -> String {
    let path = Bundle.main.path(forResource: textFile, ofType: "md")
    do { return try String(contentsOfFile: path!)
    } catch {
        return "error loading text"
    }
}
