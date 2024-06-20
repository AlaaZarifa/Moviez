//
//  MoviezApp.swift
//  Moviez
//
//  Created by Alaa Abuzarifa on 03/06/2024.
//

import SwiftUI

@main
struct MoviezApp: App {
    
    let movieRepo = MovieRepositoryImpl(networkManager: NetworkManager())
    
    var body: some Scene {
        WindowGroup {
            MainTabView().environmentObject(MovieViewModel(movieRepo: movieRepo))
        }
    }
}
