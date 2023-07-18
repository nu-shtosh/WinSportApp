//
//  Components.swift
//  WinSportApp
//
//  Created by Илья Дубенский on 13.07.2023.
//

import UIKit

enum Components {
    static func setupCustomTextField(withPlaceholder placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.textColor = .white
        textField.font = .systemFont(ofSize: 20, weight: .bold)
        textField.layer.cornerRadius = 8
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.borderWidth = 3.0
        let foregroundColor = NSAttributedString.Key.foregroundColor
        let attributedPlaceholder = NSAttributedString(string: placeholder,
                                                       attributes: [foregroundColor: UIColor.white])
        textField.attributedPlaceholder = attributedPlaceholder
        textField.leftView = UIView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: 20,
                                                  height: textField.frame.height))
        textField.leftViewMode = .always
        return textField
    }

    static func setupCustomLabel(withText text: String, color: UIColor, size: Double) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: size, weight: .bold)
        label.textColor = color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    static func setupCustomBackground() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "RonaldoBack")
        imageView.contentMode = .scaleAspectFill

        let overlayView = UIView()
            overlayView.translatesAutoresizingMaskIntoConstraints = false
            overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            imageView.addSubview(overlayView)

            NSLayoutConstraint.activate([
                overlayView.topAnchor.constraint(equalTo: imageView.topAnchor),
                overlayView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
                overlayView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
                overlayView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor)
            ])

        return imageView
    }

    static func setupCustomButton(withTitle title: String) -> UIButton {
        let button = UIButton(type: .roundedRect)
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
//        button.titleLabel?.font = UIFont.italicSystemFont(ofSize: 18)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.8, alpha: 0.6)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}
