//
//  MovieRepositoryImpl.swift
//  Moviez
//
//  Created by Alaa Abuzarifa on 05/06/2024.
//

import Foundation


class MovieRepositoryImpl : MovieRepository {
    
    
    private let networkManager :NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    
    func getMovieList(page: Int, type: String) async -> Result<ResponseBase, NetworkErrors> {
        return await networkManager.getMovieList(page: page, type: type)
    }
    
    func getMovieDetails(Id: Int) async -> Result<Movie, NetworkErrors> {
        return await networkManager.getMovieDeatils(Id: Id)

    }
    
    
}
