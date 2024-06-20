//
//  ApiServices.swift
//  Moviez
//
//  Created by Alaa Abuzarifa on 04/06/2024.
//

import Foundation

protocol ApiServices {
    
    func getMovieList(page: Int, type: String) async -> Result<ResponseBase, NetworkErrors>
    func getMovieDeatils (Id :Int)  async -> Result<Movie, NetworkErrors>
    
}
