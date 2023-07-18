//
//  AnalyticsViewModel.swift
//  WinSportApp
//
//  Created by Илья Дубенский on 17.07.2023.
//

import Foundation

final class AnalyticsViewModel {
    
    let targetPoints = 25_000

    var userPoints = UserSettings.userModel.points
    var userWeight = UserSettings.userModel.weight
    var userStrikes = UserSettings.userModel.strikes

    var progress: Float {
        guard targetPoints > 0 else { return 0 }
        return Float(userPoints) / Float(targetPoints)
    }

    func countPoints(withSquats squats: Int, distance: Int, andUserWeight weight: Int) -> Int {
        (((distance * 1000) + squats * 10) * weight) / 10
    }

    func saveUserModel(userName: String, userWeight: Int, userHeight: Int, userPoints: Int, userStrike: Int) {
        let userModel = UserModel(name: userName, weight: userWeight, height: userHeight, points: userPoints, strikes: userStrike)
        UserSettings.userModel = userModel
    }
}
