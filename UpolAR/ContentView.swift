//
//  ContentView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 17.11.2021.
//

import SwiftUI

struct ContentView: View {
    @State private var isPresented = false
    @State var numberBanner = 0
    
    let timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationView {
            List {
                // ar experience button
                arButton
                
                // menus
                aboutUniversity
                webLinks
            }
            .navigationTitle("Vítejte na UPOL")
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

// MARK: MENU DESIGN

extension ContentView {
    
    // MARK: ar button
    var arButton: some View {
        ZStack(alignment: .topTrailing) {
            Color.clear
                .frame(height: 185)
                .overlay(alignment: .bottomTrailing) {
                    Button {
                        //
                    } label: {
                        Text("AR poster".uppercased())
                            .padding(10)
                            .foregroundColor(.white)
                            .background(Color("AccentColor"))
                            .cornerRadius(10)
                            .padding(.vertical)
                    }

                }
                .background(
                    Image(banners[numberBanner])
                        .resizable()
                        .aspectRatio(1.77, contentMode: .fill)
                        .frame(height: 200, alignment: .topLeading)
                )
                .onReceive(timer) { _ in
                    if numberBanner < banners.count-1 {
                        numberBanner += 1
                    } else {
                        numberBanner = 0
                    }
                    }
            Image(systemName: "viewfinder")
                .padding(4)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .opacity(0.1)
                )
                .padding(.vertical)

        }
        .onTapGesture {
            isPresented.toggle()
        }
        .fullScreenCover(isPresented: $isPresented) {
            ARExperience()
        }
    }
    // MARK: about menu
    var aboutUniversity: some View {
        Section(header: Text("O univerzitě")) {
            ForEach(menuAbout, id: \.self) { item in
                NavigationLink {
                    if item.count > 2 {
                        AboutView(file: item[1], title: item[0], photo: item[2])
                    } else {
                        AboutView(file: item[1], title: item[0])
                    }
                } label: {
                    Text(item[0])
                }
            }
        }
    }
    
    // MARK: links menu
    var webLinks: some View {
        Section(header: Text("Internetové odkazy")) {
            ForEach(linksMenu, id: \.self) { link in
                Link(destination: URL(string: link[1])!) {
                    HStack {
                        Text(link[0])
                        Spacer()
                        Image(systemName: "link")
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
