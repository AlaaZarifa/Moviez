//
//  MovieViewModel.swift
//  Moviez
//
//  Created by Alaa Abuzarifa on 05/06/2024.
//

import Foundation
import SwiftUI


/*
   This class implements a single ViewModel approach for managing movie data for all tabs.
   While separate ViewModels could offer better maintainability and testability for larger projects,
   this approach is chosen for a simpler implementation focused on showcasing development skills.
 */
class MovieViewModel : ObservableObject, Observable {
    
    @Published var nowPlayingMovies: [Movie] = []
    @Published var nowPlayingTotalPages: Int = 10
    @Published var nowPlayingShouldLoadMoreData: Bool = false
    @Published var nowPlayingPage: Int = 1
    
    @Published var popularMovies: [Movie] = []
    @Published var popularTotalPages: Int = 10
    @Published var popularShouldLoadMoreData: Bool = false
    @Published var popularPage: Int = 1
    
    @Published var topRatedMovies: [Movie] = []
    @Published var topRatedTotalPages: Int = 10
    @Published var topRatedShouldLoadMoreData: Bool = false
    @Published var topRatedPage: Int = 1
    
    @Published var upcomingMovies: [Movie] = []
    @Published var upcomingTotalPages: Int = 10
    @Published var upcomingShouldLoadMoreData: Bool = false
    @Published var upcomingPage: Int = 1
    
    @Published var movie: Movie? = nil
    @Published var errorMessage: String? = nil
    
    
    private let movieRepo : MovieRepository
    
    init(movieRepo: MovieRepository) {
        self.movieRepo = movieRepo
    }
    
    
    // Clears the current data and reloads it
    func refreshData(type :MoviesListType) {
        switch type {
        case .NOW_PLAYING:
            nowPlayingMovies = []
            nowPlayingTotalPages = 10
            nowPlayingShouldLoadMoreData = false
            nowPlayingPage = 1
        case .POPULAR:
            popularMovies = []
            popularTotalPages = 10
            popularShouldLoadMoreData = false
            popularPage = 1
        case .TOP_RATED:
            topRatedMovies = []
            topRatedTotalPages = 10
            topRatedShouldLoadMoreData = false
            topRatedPage = 1
        case .UPCOMING:
            upcomingMovies = []
            upcomingTotalPages = 10
            upcomingShouldLoadMoreData = false
            upcomingPage = 1
        }
        
        fetchMovies(type: type)
        
    }
    
    // Pagination handling
    func loadMoreData(type :MoviesListType) {
        switch type {
        case .NOW_PLAYING:
            if nowPlayingShouldLoadMoreData  {
                nowPlayingPage += 1
                fetchMovies(type:type)
            }
        case .POPULAR:
            if popularShouldLoadMoreData {
                popularPage += 1
                fetchMovies(type:type)
            }
        case .TOP_RATED:
            if topRatedShouldLoadMoreData {
                topRatedPage += 1
                fetchMovies(type:type)
            }
        case .UPCOMING:
            if upcomingShouldLoadMoreData {
                upcomingPage += 1
                fetchMovies(type:type)
            }
        }
    }
    
    // Fetching movies data from the API
    func fetchMovies(type: MoviesListType) {
        Task {
            await MainActor.run {
                self.errorMessage = nil
            }
            
            let result = await self.movieRepo.getMovieList(page: getPage(for: type), type: type.rawValue)
            
            switch result {
            case .success(let data):
                
                if let movies = data.results {
                    let validMovies = movies.filter { $0.poster_path != nil }
                    
                    switch type {
                    case .NOW_PLAYING:
                        await MainActor.run {
                            nowPlayingMovies.append(contentsOf: validMovies.filter { !nowPlayingMovies.contains($0) })
                            nowPlayingTotalPages = data.total_pages ?? 10
                            nowPlayingShouldLoadMoreData = nowPlayingPage < nowPlayingTotalPages
                        }
                    case .POPULAR:
                        await MainActor.run {
                            popularMovies.append(contentsOf: validMovies.filter { !popularMovies.contains($0) })
                            popularTotalPages = data.total_pages ?? 10
                            popularShouldLoadMoreData = popularPage < popularTotalPages
                        }
                    case .TOP_RATED:
                        await MainActor.run {
                            topRatedMovies.append(contentsOf: validMovies.filter { !topRatedMovies.contains($0) })
                            topRatedTotalPages = data.total_pages ?? 10
                            topRatedShouldLoadMoreData = topRatedPage < topRatedTotalPages
                        }
                    case .UPCOMING:
                        await MainActor.run {
                            upcomingMovies.append(contentsOf: validMovies.filter { !upcomingMovies.contains($0) })
                            upcomingTotalPages = data.total_pages ?? 10
                            upcomingShouldLoadMoreData = upcomingPage < upcomingTotalPages
                        }
                    }
                }
                
                
            case .failure(let error):
                await MainActor.run {
                    errorMessage = handleError(error: error)
                    
                }
            }
        }
    }
    
    func getPage(for tab: MoviesListType) -> Int {
       switch tab {
       case .NOW_PLAYING:
         return nowPlayingPage
       case .POPULAR:
         return popularPage
       case .TOP_RATED:
         return topRatedPage
       case .UPCOMING:
         return upcomingPage
       }
     }
    
    /*
     This function was designed to fetch movie details, but data from the list screen is sufficient.
     It's kept for future reference, though separate requests might be better for complex projects.
     */
    func getMovieDetails(movieID: Int) {
        Task {
            await MainActor.run {
                self.errorMessage = nil
                self.movie = nil
            }
            
            let result = await self.movieRepo.getMovieDetails(Id: movieID)
            
            switch result {
            case .success(let data):
                await MainActor.run {
                    self.movie = data
                }
                
            case .failure(let error):
                await MainActor.run {
                    errorMessage = handleError(error: error)
                    
                }
            }
        }
    }
    
    
    /*
     Handling network-related error messages; better approaches could be implemented,
     but for the simplicity of the project, this will suffice.
     */
    func handleError( error: NetworkErrors)  -> String {
        switch error {
        case .noInternetConnection:
            return "No internet connection. Please check your network settings."
        case .decodingError(let decodingError):
            if let decodingError = decodingError {
                return "Decoding error: \(decodingError.localizedDescription)"
            } else {
                return "Decoding error occurred."
            }
        case .unknownError(let code):
            return "An unknown error occurred. Error Code: \(code)"
        case .invalidURL:
            return "Invalid URL. Please check the URL and try again."
        }
    }
    
 
}
