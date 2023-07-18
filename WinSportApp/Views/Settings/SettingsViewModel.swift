//
//  SettingsViewModel.swift
//  WinSportApp
//
//  Created by Илья Дубенский on 15.07.2023.
//

import Foundation

final class SettingsViewModel {
    var pushNotificationsIsOn = false

    func updateNotificationSettings() {
        if pushNotificationsIsOn {
            requestNotificationAuthorization()
        } else {
            disableNotifications()
        }
    }

    private func requestNotificationAuthorization() {
    }

    func disableNotifications() {
    }
}
