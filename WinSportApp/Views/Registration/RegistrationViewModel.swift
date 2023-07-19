//
//  RegistrViewModel.swift
//  WinSportApp
//
//  Created by Илья Дубенский on 14.07.2023.
//

import UIKit


final class RegistrationViewModel {
    private let scheduler = DailyTaskScheduler()

    func validateFields(fields: [(UITextField, String)]) -> Bool {
        var isValid = true

        for (textField, warningPlaceholder) in fields {
            if let text = textField.text, text.isEmpty {
                textField.text = ""
                textField.placeholder = warningPlaceholder
                textField.shake()
                isValid = false
            }
        }

        return isValid
    }



    func saveUserModel(userName: String, userWeight: Int, userHeight: Int, userPoints: Int, userStrikes: Int) {
        let userModel = UserModel(name: userName, weight: userWeight, height: userHeight, points: userPoints, strikes: userStrikes)
        UserSettings.userModel = userModel
    }
}
