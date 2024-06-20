//
//  MovieViewModelManager.swift
//  Moviez
//
//  Created by Alaa Abuzarifa on 13/06/2024.
//

import Foundation

class MovieViewModelManager {
  static let shared = MovieViewModelManager()
  private var viewModel: MovieViewModel!
  
  private init() {
    viewModel = MovieViewModel(movieRepo: MovieRepositoryImpl(networkManager: NetworkManager()))
  }
  
  func getViewModel() -> MovieViewModel {
    return viewModel
  }
}
