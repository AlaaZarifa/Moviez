//
//  TabView.swift
//  Moviez
//
//  Created by Alaa Abuzarifa on 03/06/2024.
//

import SwiftUI

struct MainTabView: View {
    
    @EnvironmentObject var viewModel: MovieViewModel
    
    @State private var selectedTab = 0
    
    var body: some View {
        CustomTabView(selectedTab: $selectedTab ).environmentObject(viewModel)
    }
}



struct CustomTabView: View {
    
    @Binding var selectedTab: Int
    @EnvironmentObject var viewModel : MovieViewModel
    
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            NavigationStack {
                NowPlayingView()
                    .environmentObject(viewModel)
                    .navigationTitle("Now Playing")
            }
            .tabItem {
                CustomTabItem(label: "Now Playing", imageName: "icon-now-playing", selected: selectedTab == 0)
            }
            .tag(0)
            
            
            
            NavigationStack {
                PopularView()
                    .environmentObject(viewModel)
                    .navigationTitle("Popular")
            }
            .tabItem {
                CustomTabItem(label: "Popular", imageName: "icon-popular", selected: selectedTab == 1)
            }
            .tag(1)
            
            
            
            NavigationStack {
                TopRatedView()
                    .environmentObject(viewModel)
                    .navigationTitle("Top Rated")
            }
            .tabItem {
                CustomTabItem(label: "Top Rated", imageName: "icon-top-rated", selected: selectedTab == 2)
            }
            .tag(2)
            
            
            
            NavigationStack {
                UpcomingView()
                    .environmentObject(viewModel)
                    .navigationTitle("Upcoming")
            }
            .tabItem {
                CustomTabItem(label: "Upcoming", imageName: "icon-upcoming", selected: selectedTab == 3)
            }
            .tag(3)
            
            
        }
        .tint(.red)
        .preferredColorScheme(.light)
        
    }
}

struct CustomTabItem: View {
    var label: String
    var imageName: String
    var selected: Bool
    
    var body: some View {
        VStack {
            Image(imageName)
                .renderingMode(.template)
            Text(label)
                .foregroundColor(selected ? .blue : .gray)
        }
    }
}


#Preview {
    MainTabView()
        .environmentObject(
            MovieViewModel(
                movieRepo: MovieRepositoryImpl(
                    networkManager: NetworkManager()
                )
            )
        )
}

