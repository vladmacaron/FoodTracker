//
//  FoodTrackerApp.swift
//  FoodTracker
//
//  Created by Vladislav Mazurov on 11.02.22.
//

import SwiftUI

@main
struct FoodTrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
