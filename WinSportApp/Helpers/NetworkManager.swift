//
//  NetworkManager.swift
//  WinSportApp
//
//  Created by Илья Дубенский on 16.07.2023.
//

import Foundation


final class NetworkManager {

    static let shared: NetworkManager = .init()

    func fetchData<T: Decodable>(_ type: T.Type, from url: String?,
                   completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: url ?? "") else {
            completion(.failure(.invalidURL))
            print(NetworkError.invalidURL.rawValue)
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "No Error Description")
                return
            }
            do {
                let type = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(type))
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }

    func fetchImage(from url: URL?,
                    completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = url else {
            completion(.failure(.invalidURL))
            print(NetworkError.invalidURL.rawValue)
            return
        }
        DispatchQueue.global(qos: .utility).async {
            guard let imageData = try? Data(contentsOf: url) else {
                completion(.failure(.noData))
                print(NetworkError.noData.rawValue)
                return
            }
            DispatchQueue.main.async {
                completion(.success(imageData))
            }
        }
    }

    func postRequest(url: URL,
                     bodyData: Data,
                     completion: @escaping (Result<Data?, Error>) -> Void) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = bodyData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }

                if httpResponse.statusCode == 200 {
                    completion(.success(data))
                } else {
                    completion(.failure(NetworkError.statusCode))
                }
            }
            task.resume()
        }
}
