//
//  TrainingViewModel.swift
//  WinSportApp
//
//  Created by Илья Дубенский on 16.07.2023.
//

import Foundation


protocol TrainingViewModelDelegate: AnyObject {
    func didFetchTrainingData(_ training: Training)
    func didFailFetchingTrainingData(with error: Error)
}

final class TrainingViewModel {
    weak var delegate: TrainingViewModelDelegate?

    var training: Training?

    func fetchTrainingData() {
        NetworkManager.shared.fetchData([Training].self, from: Constants.weekdayUrl) { [weak self] result in
            switch result {
            case .success(let trainings):
                guard let training = trainings.first else {
                    self?.delegate?.didFailFetchingTrainingData(with: NetworkError.invalidData)
                    return
                }
                self?.delegate?.didFetchTrainingData(training)
            case .failure(let error):
                self?.delegate?.didFailFetchingTrainingData(with: error)
            }
        }
    }

    func fetchImage(fromURL: String, completion: @escaping (Result<Data, Error>) -> Void) {
        NetworkManager.shared.fetchImage(from: URL(string: fromURL)) { result in
            switch result {
            case .success(let imageData):
                completion(.success(imageData))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func createFullScreenTextViewModel() -> FullScreenTextViewController {
        let fullScreenTextVC = FullScreenTextViewController()
        let fullScreenTextVM = FullScreenTextViewModel()

        fullScreenTextVM.training = training
        fullScreenTextVC.fullScreenTextViewModel = fullScreenTextVM

        return fullScreenTextVC
    }
}
