//
//  QuestionViewModel.swift
//  WinSportApp
//
//  Created by Илья Дубенский on 17.07.2023.
//

import Foundation


final class QuestionViewModel {

    func sendQuestion(question: String,
                      questionID: String,
                      completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: Constants.askUrl) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        let parameters = ["ask": question, "id": questionID]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters)

            NetworkManager.shared.postRequest(url: url, bodyData: jsonData) { result in
                switch result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }

    func fetchResponse(questionID: String,
                       completion: @escaping (Result<String, Error>) -> Void) {
        let urlString = Constants.responseUrl + questionID

        NetworkManager.shared.fetchData(Response.self,
                                        from: urlString) { result in
            switch result {
            case .success(let response):
                completion(.success(response.response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func generateQuestionID() -> String {
        return UUID().uuidString
    }
}
