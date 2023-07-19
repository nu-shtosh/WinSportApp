//
//  LoadingViewController.swift
//  WinSportApp
//
//  Created by Илья Дубенский on 13.07.2023.
//

import UIKit


final class LoadingViewController: UIViewController {

    // MARK: - View Model

    private let loadingViewModel = LoadingViewModel()

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
        setupViewModel()
    }

    override func viewWillDisappear(_ animated: Bool) {
        loadingViewModel.stopProgressUpdate()
    }
}

// MARK: - Private Methods

private extension LoadingViewController {
    
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
            loadingView.topAnchor.constraint(equalTo: winSportStack.bottomAnchor,
                                             constant: Constants.eight),
            loadingView.leadingAnchor.constraint(equalTo: backView.leadingAnchor,
                                                 constant: Constants.forty),
            loadingView.trailingAnchor.constraint(equalTo: backView.trailingAnchor,
                                                  constant: -Constants.forty),
            loadingView.heightAnchor.constraint(equalToConstant: Constants.sixteen),

            loadingInfoLabel.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            loadingInfoLabel.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor)
        ])
    }

    private func setupViewModel() {
        loadingViewModel.updateProgress = { [weak self] progress, infoText in
            self?.loadingView.setProgress(progress, animated: true)
            self?.loadingInfoLabel.textColor = progress <= 0.5 ? .systemOrange : .white
            self?.loadingInfoLabel.text = infoText
        }
        loadingViewModel.navigationCompleted = { [weak self] in
            self?.navigateToNextScreen()
        }
        loadingViewModel.startProgressUpdate()
    }

    private func navigateToNextScreen() {
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
