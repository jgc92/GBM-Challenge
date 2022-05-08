//
//  ViewModelHelper.swift
//  GBM-Challenge
//
//  Created by Joaquín González Cervantes on 08/05/22.
//

import Foundation

class ViewModelHelper {
    
    // Load JSON from url string
    func loadJson(fromURLString urlString: String,
                          completion: @escaping (Result<Data, Error>) -> Void) {
        if let url = URL(string: urlString) {
            let urlSession = URLSession(configuration: .default).dataTask(with: url) { (data, _, error) in
                if let error = error {
                    completion(.failure(error))
                }

                if let data = data {
                    completion(.success(data))
                }
            }

            urlSession.resume()
        }
    }

    // Parse data object. Return array of IPC
    func parse(jsonData: Data) -> [IPC]? {
        do {
            let decodedData = try JSONDecoder().decode([IPC].self, from: jsonData)
            return decodedData
        } catch {
            print("decode error")
            return nil
        }
    }
}
