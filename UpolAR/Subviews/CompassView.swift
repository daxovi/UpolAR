//
//  CompassView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 24.06.2023.
//

import SwiftUI

struct CompassView: View {
    @StateObject var locationManager = LocationManager.shared
    var body: some View {
        if let rotation = locationManager.headingToDestination {
            ZStack {
                Circle()
                    .fill(.white)
                    .frame(width: 70)
                Image(systemName: "arrow.up")
                    .rotationEffect(.degrees(rotation))
                    .font(.title)
                    .foregroundColor(Color("BlueColor"))
            }
        } else {
            ZStack {
                Circle()
                    .fill(.white.opacity(0.0))
            }
        }
    }
}

struct CompassView_Previews: PreviewProvider {
    static var previews: some View {
        CompassView()
    }
}
