//
//  NoLocationView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 10.06.2023.
//

import SwiftUI

struct NoLocationView: View {
    var body: some View {
        Text("nemám data na určování vzdálenosti. Přejděte do nastavení a povolte polohové služby.")
    }
}

struct NoLocationView_Previews: PreviewProvider {
    static var previews: some View {
        NoLocationView()
    }
}
