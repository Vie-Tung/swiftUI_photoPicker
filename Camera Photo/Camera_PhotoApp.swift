//
//  Camera_PhotoApp.swift
//  Camera Photo
//
//  Created by Tung Viet on 29/08/2024.
//

import SwiftUI
import SwiftData

@main
struct Camera_PhotoApp: App {
    var body: some Scene {
        WindowGroup {
            PhotoListView()
        }
        .modelContainer(for: SampleModel.self)
    }
}
