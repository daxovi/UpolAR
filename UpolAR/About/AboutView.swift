//
//  AboutView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 19.11.2021.
//

import SwiftUI

struct AboutView: View {
    var file: String
    var title: String
    var photo: String?
    
    var body: some View {
        ScrollView {
            VStack {
                if photo != nil {
                    Image(photo!)
                        .resizable()
                        .scaledToFill()
                }
                Text(.init(TextLoad(textFile: self.file)))
                    .padding()
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView(file: "about_university", title: "O fakultě", photo: "rektorat")
    }
}

func TextLoad(textFile: String) -> String {
    let path = Bundle.main.path(forResource: textFile, ofType: "md")
    do { return try String(contentsOfFile: path!)
    } catch {
        return "error loading text"
    }
}
