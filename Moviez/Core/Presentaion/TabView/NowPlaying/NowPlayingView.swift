//
//  NowPlayingView.swift
//  Moviez
//
//  Created by Alaa Abuzarifa on 03/06/2024.
//

import SwiftUI

struct NowPlayingView: View {
    
    @State private var isRefreshed = false
    @EnvironmentObject var viewModel : MovieViewModel
    private var columns: [GridItem] = [GridItem(.flexible()),GridItem(.flexible())]
    

    var body: some View {
        
        
        ScrollView {
            
            if let errorMessage = viewModel.errorMessage {
                // The error UI is currently displayed as plain text for simplicity; this could be improved for a better user experience.
                Text(errorMessage).padding([.top],100).foregroundColor(.red)
            }else{
                
                if viewModel.nowPlayingMovies.isEmpty {
                    
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .progressViewStyle(.circular)
                        .padding([.top],300)
                        .tint(.gray)
                        .onAppear{
                            // Fetching the data only when the screen is launched
                            if !isRefreshed {
                                viewModel.fetchMovies(type: .NOW_PLAYING)
                            }
                        }
                    
                }else {
                    LazyVGrid(columns: columns, spacing: 10) {
                        
                        ForEach(viewModel.nowPlayingMovies , id: \.self )  { movie in
                            
                            // Navigation link directs to MovieDetailsView when the item is clicked, and the label displays the UI for the movie item
                            NavigationLink() {
                                MovieDetailsView(viewModel:viewModel, movie: movie)
                                
                            } label :{
                                MovieCardView(movie: movie)
                                    .shadow(color: Color.black.opacity(0.5), radius: 10, x: 5, y: 5)
                                    .padding(5)
                            }
                            
                            
                        }
                        
                        // This progress indicator appears at the end of the list and triggers loading more data for pagination.
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .progressViewStyle(.circular)
                            .tint(.blue)
                            .opacity(viewModel.nowPlayingMovies.isEmpty ? 0.0 : 1.0)
                            .onAppear{
                                // Fetching more data
                                viewModel.loadMoreData(type: .NOW_PLAYING)
                            }
                        
                        
                        
                    }
                    .aspectRatio(16/9, contentMode: .fit)
                    .padding([.top],10)
                    .padding([.horizontal],10)
                    .onAppear{
                        // Reset the refresh state
                        isRefreshed = false
                    }
                    
                    
                    
                }
                
                
                
            }
            
            
        }.refreshable {
            isRefreshed = true
            viewModel.refreshData(type: .NOW_PLAYING)
        }
        
        
        
    }
    
}
