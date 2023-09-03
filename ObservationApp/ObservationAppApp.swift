//
//  ObservationAppApp.swift
//  ObservationApp
//
//  Created by Jaime Escobar on 19/08/23.
//

import SwiftUI

@main
struct ObservationAppApp: App {
    @State private var globalState = GlobalState()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(globalState)
        }
    }
}
