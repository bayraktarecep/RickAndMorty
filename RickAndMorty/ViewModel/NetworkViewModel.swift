//
//  NetworkViewModel.swift
//  RickAndMorty
//
//  Created by Recep Bayraktar on 19.03.2021.
//

import UIKit

class NetworkVM {
    
    static let shared = NetworkVM()
    private init() {}
    
    private let baseUrl = "https://rickandmortyapi.com/api/character"
    
    //MARK: - Data Networking with Error Handlers
    func fetchData(pageNumber: Int, completed: @escaping (Result<Characters,NetworkError>) -> Void) {
        
        let endpoint = baseUrl + "?page=\(pageNumber)"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidURL))
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let _ = error {
                completed(.failure(.invalidRequest))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let safeData = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodeData = try decoder.decode(Characters.self, from: safeData)
                return completed(.success(decodeData))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        dataTask.resume()
    }
    
    //MARK: - Filter Data Networking with Error Handlers
    func filterData(name: String?, status: String?, completion: @escaping (Result<Characters, NetworkError>) -> Void) {
        
        guard let _ = URL(string: baseUrl) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var requestString = ""
        
        if let name = name {
            requestString = baseUrl + "?name=" + name
        }
        
        if let status = status {
            requestString = baseUrl + "?status=" + status
        }
        
        if let name = name, let status = status {
            requestString = baseUrl + "?name=" + name + "&" + "status=" + status
        }
        
        guard let requestURL = URL(string: requestString) else {
            return
        }
        
        let request = URLRequest(url: requestURL)
        let session = URLSession.shared
        
        session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            guard let result = try? JSONDecoder().decode(Characters.self, from: data),
                  let _ = result.results else {
                completion(.failure(.invalidData))
                return
            }
            
            completion(.success(result))
            
        }.resume()
    }
}
