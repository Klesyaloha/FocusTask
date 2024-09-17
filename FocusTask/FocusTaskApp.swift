//
//  FocusTaskApp.swift
//  FocusTask
//
//  Created by Klesya Loha on 12/09/2024.
//

import SwiftUI

@main
struct FocusTaskApp: App {
    @EnvironmentObject var myAppData: MyAppData
    
    var body: some Scene {
        WindowGroup {
            TasksView()
                .environmentObject(MyAppData())
        }
    }
}
