//
//  SettingsViewController.swift
//  WinSportApp
//
//  Created by Илья Дубенский on 14.07.2023.
//

import UIKit


final class SettingsViewController: UIViewController {

    // MARK: - View Model

    private let settingsViewModel = SettingsViewModel()

    // MARK: - UI Elements

    private lazy var backView: UIImageView = {
        Components.setupCustomBackground()
    }()

    private lazy var settingsLabel: UILabel = {
        Components.setupCustomLabel(withText: "НАСТРОЙКИ",
                                           color: UIColor.white,
                                           size: 36)
    }()

    private lazy var winSportStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [winLabel, sportLabel])
        stackView.spacing = 0
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var winLabel: UILabel = {
        Components.setupCustomLabel(withText: "WIN",
                                           color: UIColor.systemOrange,
                                           size: 20)
    }()

    private lazy var sportLabel: UILabel = {
        Components.setupCustomLabel(withText: "SPORT",
                                           color: UIColor.white,
                                           size: 20)
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        button.addTarget(self,
                         action: #selector(cancelButtonTapped),
                         for: .touchUpInside)
        button.clipsToBounds = true
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var notificationLabel: UILabel = {
        Components.setupCustomLabel(withText: "УВЕДОМЛЕНИЯ",
                                           color: .systemOrange,
                                           size: 26)
    }()

    private lazy var notificationSwitch: UISwitch = {
        let switchControl = UISwitch()
        switchControl.isOn = settingsViewModel.pushNotificationsIsOn
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        switchControl.onTintColor = .orange
        switchControl.thumbTintColor = .white
        switchControl.tintColor = .gray
        switchControl.layer.borderWidth = 1
        switchControl.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 0.7)
        switchControl.layer.cornerRadius = 14
        switchControl.addTarget(self, action: #selector(notificationSwitchValueChanged), for: .valueChanged)
        return switchControl
    }()

    private lazy var clearUserDefaultsButton: UIButton = {
        let button = UIButton(type: .system)
        let buttonTitle = "ОЧИСТИТЬ\nДАННЫЕ"
        let attributedString = NSMutableAttributedString(string: buttonTitle)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 8
        attributedString.addAttribute(.paragraphStyle,
                                      value: paragraphStyle,
                                      range: NSMakeRange(0, attributedString.length))
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(self,
                         action: #selector(clearUserDefaultsButtonTapped),
                         for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        button.setTitleColor(UIColor.systemOrange, for: .normal)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.lineBreakMode = .byWordWrapping
        return button
    }()

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainView()
    }

    // MARK: - Private Methods

    private func setupMainView() {
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        view.addSubview(backView)
        view.addSubview(cancelButton)
        view.addSubview(winSportStack)
        view.addSubview(settingsLabel)
        view.addSubview(notificationLabel)
        view.addSubview(notificationSwitch)
        view.addSubview(clearUserDefaultsButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: view.topAnchor),
            backView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.sixteen),
            cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.sixteen),

            winSportStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.sixteen),
            winSportStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            settingsLabel.topAnchor.constraint(equalTo: winLabel.bottomAnchor, constant: 36),
            settingsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            notificationLabel.topAnchor.constraint(equalTo: settingsLabel.bottomAnchor, constant: 36),
            notificationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.sixteen),

            notificationSwitch.centerYAnchor.constraint(equalTo: notificationLabel.centerYAnchor),
            notificationSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.sixteen),

            clearUserDefaultsButton.topAnchor.constraint(equalTo: notificationLabel.bottomAnchor, constant: Constants.sixteen),
            clearUserDefaultsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.sixteen),
            clearUserDefaultsButton.widthAnchor.constraint(equalToConstant: 200),
        ])
    }

    // MARK: - Actions

    @objc private func notificationSwitchValueChanged() {
        settingsViewModel.pushNotificationsIsOn.toggle()
        settingsViewModel.updateNotificationSettings()
    }

    @objc private func clearUserDefaultsButtonTapped() {
        showAlert()
    }

    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Show Alert

    private func showAlert() {
        let alertController = UIAlertController(title: "Подтверждение",
                                                message: "Вы уверены, что хотите очистить данные?",
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Отмена",
                                         style: .cancel)
        let key = UserSettings.SettingsCase.userModel.rawValue
        let clearAction = UIAlertAction(title: "Очистить",
                                        style: .destructive) { _ in
            UserDefaults.standard.removeObject(forKey: key)
            self.settingsViewModel.disableNotifications()
            self.dismiss(animated: true, completion: nil)
        }

        alertController.addAction(cancelAction)
        alertController.addAction(clearAction)

        present(alertController, animated: true, completion: nil)
    }
}
