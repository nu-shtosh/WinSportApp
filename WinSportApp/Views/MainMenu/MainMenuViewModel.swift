//
//  MainMenuViewModel.swift
//  WinSportApp
//
//  Created by Илья Дубенский on 15.07.2023.
//

import Foundation

final class MainMenuViewModel {
    let targetPoints = 25_000

    var userModel: UserModel? {
        return UserSettings.userModel
    }

    var userPoints: Int {
        return userModel?.points ?? 0
    }

    var progress: Float {
        guard targetPoints > 0 else { return 0 }
        return Float(userPoints) / Float(targetPoints)
    }
}
