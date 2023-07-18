//
//  LoadingViewController.swift
//  WinSportApp
//
//  Created by Илья Дубенский on 13.07.2023.
//

import UIKit


final class LoadingViewController: UIViewController {

    // MARK: - Private Properties
    private var timer: Timer!
    private var progress: Float = 0.0
    private let totalDuration: TimeInterval = 3.0
    private let updateInterval: TimeInterval = 0.1

    // MARK: - UIElements
    private lazy var backView: UIImageView = {
        Components.setupCustomBackground()
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
                                           size: 50)
    }()

    private lazy var sportLabel: UILabel = {
        Components.setupCustomLabel(withText: "SPORT",
                                           color: UIColor.white,
                                           size: 50)
    }()

    private lazy var loadingView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.tintColor = .systemOrange
        progressView.layer.cornerRadius = Constants.cornerRadius
        progressView.isUserInteractionEnabled = false
        progressView.backgroundColor = .white
        progressView.clipsToBounds = true
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()

    private lazy var loadingInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainView()
        timer = Timer.scheduledTimer(timeInterval: updateInterval,
                                     target: self,
                                     selector: #selector(updateProgress),
                                     userInfo: nil,
                                     repeats: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
    }


    // MARK: - Actions
    @objc private func updateProgress() {
        progress += Float(updateInterval / totalDuration)
        loadingView.setProgress(progress, animated: true)
        loadingInfoLabel.textColor = progress <= 0.5 ? .systemOrange : .white
        loadingInfoLabel.text = String(Int(progress * 100))  + "%"

        if progress >= 1.0 {
            timer.invalidate()
            let userDefaults = UserDefaults.standard
                    if userDefaults.object(forKey: UserSettings.SettingsCase.userModel.rawValue) != nil {
                        let mainMenuVC = MainMenuViewController()
                        mainMenuVC.modalPresentationStyle = .fullScreen
                        present(mainMenuVC, animated: true)
                    } else {
                let registrationVC = RegistrationViewController()
                registrationVC.modalPresentationStyle = .fullScreen
                present(registrationVC, animated: true)
            }
        }
    }

    // MARK: - Private Methods
    private func setupMainView() {
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        view.addSubview(backView)
        view.addSubview(winSportStack)
        view.addSubview(loadingView)
        loadingView.addSubview(loadingInfoLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: view.topAnchor),
            backView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            winSportStack.centerYAnchor.constraint(equalTo: backView.centerYAnchor),
            winSportStack.centerXAnchor.constraint(equalTo: backView.centerXAnchor),

            loadingView.centerXAnchor.constraint(equalTo: backView.centerXAnchor),
            loadingView.topAnchor.constraint(equalTo: winSportStack.bottomAnchor, constant: 8),
            loadingView.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 40),
            loadingView.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -40),
            loadingView.heightAnchor.constraint(equalToConstant: 20),

            loadingInfoLabel.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            loadingInfoLabel.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor)
        ])
    }
}
