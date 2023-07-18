//
//  UserModel.swift
//  WinSportApp
//
//  Created by Илья Дубенский on 13.07.2023.
//

import Foundation

final class UserModel: Codable {
    let name: String
    let weight: Int
    let height: Int
    var points: Int
    var strikes: Int

    internal init(name: String, weight: Int, height: Int, points: Int, strikes: Int) {
        self.name = name
        self.weight = weight
        self.height = height
        self.points = points
        self.strikes = strikes
    }

    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(weight, forKey: "weight")
        coder.encode(height, forKey: "height")
        coder.encode(points, forKey: "points")
        coder.encode(strikes, forKey: "strikes")

    }

    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as? String ?? ""
        weight = coder.decodeInteger(forKey: "weight")
        height = coder.decodeInteger(forKey: "height")
        points = coder.decodeInteger(forKey: "points")
        strikes = coder.decodeInteger(forKey: "strikes")

    }
}
