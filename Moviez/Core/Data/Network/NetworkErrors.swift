//
//  NetworkErrors.swift
//  Moviez
//
//  Created by Alaa Abuzarifa on 04/06/2024.
//

import Foundation

enum NetworkErrors: Error {

      case noInternetConnection
      case decodingError(error: Error?)
      case unknownError(code: Int)
      case invalidURL
}
