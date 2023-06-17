//
//  MenuView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 07.06.2023.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
            Group {
                aboutUniversity
                webLinks
            }
            .foregroundColor(.white)
            .padding(.bottom)
    }
    
    // MARK: about menu
    var aboutUniversity: some View {
        VStack {
            HStack {
                Text("O univerzitě")
                Spacer()
            }
            .padding(.top)
            
            VStack(spacing: 1) {
                ForEach(menuAbout, id: \.self) { item in
                    NavigationLink {
                        if item.count > 2 {
                            AboutView(file: item[1], title: item[0], photo: item[2])
                        } else {
                            AboutView(file: item[1], title: item[0])
                        }
                    } label: {
                        MenuButtonView(title: item[0], iconName: "chevron.right")
                    }
                }
            }
            .cornerRadius(15)
        }
    }
    
    // MARK: links menu
    var webLinks: some View {
        
        VStack {
            HStack {
                Text("Internetové odkazy UPOL")
                Spacer()
            }
            .padding(.top)
            
            VStack(spacing: 1) {
                ForEach(linksMenu, id: \.self) { link in
                    Link(destination: URL(string: link[1])!) {
                        MenuButtonView(title: link[0], iconName: "link")
                    }
                }
            }
            .cornerRadius(15)
        }
    }
    
    // MARK: MENU DATA
    var menuAbout = [
        ["Univerzita Palackého v Olomouci", "about_university", "rektorat"],
        ["Přírodovědecká fakulta", "about_faculty", "prirodoveda"],
        ["Katedra Informatiky", "about_department"]
    ]
    
    var linksMenu = [
        ["Katedra Informatiky", "http://inf.upol.cz"],
        ["Přírodovědecká fakulta", "http://prf.upol.cz"],
        ["Univerzita Palackého", "http://www.upol.cz"],
        ["Město Olomouc", "http://www.olomouc.cz"]
    ]
    
    var banners = [
        "breakoutBanner",
        "pongBanner"
    ]
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ScrollView {
                MenuView()
            }
        }
        
    }
}
