//
//  StoreItemController.swift
//  iTunesSearch
//
//  Created by Ibrahim Syed on 09/21/2024
//

import UIKit

class StoreItemController {
    func fetchItems(matching query: [String: String], completion: @escaping (Result<[StoreItem], Error>) -> Void) {
        var urlComponents = URLComponents(string: "https://itunes.apple.com/search")!
        urlComponents.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
        let task = URLSession.shared.dataTask(with: urlComponents.url!) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let searchResponse = try decoder.decode(SearchResponse.self, from: data)
                    completion(.success(searchResponse.results))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    enum PhotoInfoError: Error, LocalizedError {
        case imageDataMissing
    }
    
    func fetchImage(from url: URL, completion: @escaping
       (Result<UIImage, Error>) -> Void) {
        var urlComponents = URLComponents(url: url,
               resolvingAgainstBaseURL: true)
            urlComponents?.scheme = "https"
        
        let task = URLSession.shared.dataTask(with:
               urlComponents!.url!) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                completion(.success(image))
            } else if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(PhotoInfoError.imageDataMissing))
            }
        }
        task.resume()
    }
}
