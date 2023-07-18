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
}
