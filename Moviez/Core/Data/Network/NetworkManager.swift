//
//  NetworkManager.swift
//  Moviez
//
//  Created by Alaa Abuzarifa on 04/06/2024.
//

import Foundation



class NetworkManager : ApiServices{
    
    /*
     The API KEY is stored as an environment variable in the current scheme for security reasons.
     While there are more secure methods to manage API keys, this approach is sufficient for this project.
     You can easily obtain an API key from: https://developer.themoviedb.org/docs/authentication-application
     */
    private let apiKey: String = ProcessInfo.processInfo.environment["MD_API_KEY"] ?? ""
    
    
    func getMovieList(page: Int, type: String) async -> Result<ResponseBase, NetworkErrors> {
        
        print("1")
        
        // Check for internet connection
        guard await isReachable() else {
            return .failure(.noInternetConnection)
        }
        
        print("2")
        
        
        // Get the URL
        guard let url = getMovieListURL(type: type, page: page, apiKey: apiKey) else {
            return .failure(.invalidURL)
        }
        
        // Requesting the API and parsing the response
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                print("Error unknownError: \(response)")
                let code = (response as? HTTPURLResponse)?.statusCode
                return .failure(.unknownError(code: code ?? 500))
            }
            let decodedResponse = try JSONDecoder().decode(ResponseBase.self, from: data)
            return .success(decodedResponse)
        } catch {
            print("Error error: \(error.localizedDescription)")
            return .failure(.decodingError(error: error))
        }
    }
    
    
    func getMovieDeatils(Id: Int) async -> Result<Movie, NetworkErrors> {
        
        guard await isReachable() else {
            return .failure(.noInternetConnection)
        }
        
        guard let url = getMovieDetailsURL(Id: Id, apiKey: apiKey) else {
            return .failure(.invalidURL)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                return .failure(.unknownError(code:500))
            }
            let movieData = try JSONDecoder().decode(Movie.self, from: data)
            return .success(movieData)
        } catch{
            return .failure(.decodingError(error: error))
        }
        
    }
    
    
    // Checks for internet connection
    func isReachable() async -> Bool {
        do {
            let (data, _) = try await URLSession.shared.data(from: URL(string: "https://google.com")!)
            return !data.isEmpty ? true : false // Assuming an empty response indicates no connection
        } catch {
            print("3 \(error.localizedDescription)")
            return false
        }
    }
    
    
}



private extension NetworkManager {
    
    
    func getMovieListURL(type: String, page: Int, apiKey: String) -> URL? {
        var components = URLComponents()
        components.scheme = NetworkConstants.baseUrl.starts(with: "http") ? "" : "https"
        components.host = NetworkConstants.baseUrl
        
        
        components.path = "/\(NetworkConstants.version)/movie/\(type)"
        
        // Query items with error handling and dynamic page value
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "page", value: String(page)))
        queryItems.append(URLQueryItem(name: "api_key", value: apiKey))
        components.queryItems = queryItems
        
        return components.url
    }
    
    
    func getMovieDetailsURL(Id: Int, apiKey: String) -> URL? {
        var components = URLComponents()
        components.scheme = NetworkConstants.baseUrl.starts(with: "http") ? "" : "https" 
        components.host = NetworkConstants.baseUrl
        
        // Path construction with dynamic type
        components.path = "/\(NetworkConstants.version)/movie/\(Id)"
        
        // Query items with error handling and dynamic page value
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "api_key", value: apiKey))
        components.queryItems = queryItems
        
        return components.url
    }
    
}
