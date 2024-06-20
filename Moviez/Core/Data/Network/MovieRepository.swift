//
//  MovieRepository.swift
//  Moviez
//
//  Created by Alaa Abuzarifa on 05/06/2024.
//

import Foundation


protocol MovieRepository {
    
    func getMovieList(page :Int, type:String)  async -> Result<ResponseBase,NetworkErrors>
    
    func getMovieDetails (Id :Int) async -> Result<Movie,NetworkErrors>
    
}
