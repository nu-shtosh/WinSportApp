//
//  LoadingViewModel.swift
//  WinSportApp
//
//  Created by Илья Дубенский on 15.07.2023.
//

import UIKit


final class LoadingViewModel {
    private var timer: Timer?
    private var progress: Float = 0.0
    private let totalDuration: TimeInterval = 3.0
    private let updateInterval: TimeInterval = 0.1
    private let scheduler = DailyTaskScheduler()


    var updateProgress: ((Float, String) -> Void)?
    var navigationCompleted: (() -> Void)?

    func startProgressUpdate() {
        timer = Timer.scheduledTimer(timeInterval: updateInterval,
                                     target: self,
                                     selector: #selector(updateProgress(_:)),
                                     userInfo: nil,
                                     repeats: true)
    }

    func stopProgressUpdate() {
        timer?.invalidate()
        timer = nil
    }

    @objc private func updateProgress(_ timer: Timer) {
        progress += Float(updateInterval / totalDuration)
        let progressText = String(Int(progress * 100)) + "%"
        updateProgress?(progress, progressText)

        if progress >= 1.0 {
            stopProgressUpdate()
            navigationCompleted?()
        }
    }
}
