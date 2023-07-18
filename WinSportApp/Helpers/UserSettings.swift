//
//  UserSettings.swift
//  WinSportApp
//
//  Created by Илья Дубенский on 13.07.2023.
//

import Foundation

final class UserSettings {

    enum SettingsCase: String {
        case userModel
        case pushNotifications
    }

    static var userModel: UserModel! {
        get {
            let defaults = UserDefaults.standard
            let key = SettingsCase.userModel.rawValue
            let decoder = JSONDecoder()
            guard let savedUserData = defaults.object(forKey: key) as? Data,
                  let decodedModel = try? decoder.decode(UserModel.self, from: savedUserData) else { return nil}
            return decodedModel
        }
        set {
            let defaults = UserDefaults.standard
            let key = SettingsCase.userModel.rawValue
            let encoder = JSONEncoder()
            if let userModel = newValue {
                if let encodedUser = try? encoder.encode(userModel) {
                    defaults.set(encodedUser, forKey: key)
                }
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
}
