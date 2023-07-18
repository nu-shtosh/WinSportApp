//
//  MainMenuViewController.swift
//  WinSportApp
//
//  Created by Илья Дубенский on 13.07.2023.
//

import UIKit


final class MainMenuViewController: UIViewController {

    // MARK: - View Model

    private let mainMenuVM = MainMenuViewModel()

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
                                    size: 20)
    }()

    private lazy var sportLabel: UILabel = {
        Components.setupCustomLabel(withText: "SPORT",
                                    color: UIColor.white,
                                    size: 20)
    }()

    private lazy var buttonsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [trainingButton,
                                                       analyticsButton,
                                                       questionButton,
                                                       settingsButton])
        stackView.spacing = 10
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var trainingButton: UIButton = {
        let button = Components.setupCustomButton(withTitle: "ТРЕНЕРОВКА")
        button.addTarget(self,
                         action: #selector(trainingButtonTapped),
                         for: .touchUpInside)
        return button
    }()

    private lazy var analyticsButton: UIButton = {
        let button = Components.setupCustomButton(withTitle: "АНАЛИТИКА")
        button.addTarget(self,
                         action: #selector(analyticsButtonTapped),
                         for: .touchUpInside)
        return button
    }()

    private lazy var questionButton: UIButton = {
        let button = Components.setupCustomButton(withTitle: "ВОПРОС ТРЕНЕРУ")
        button.addTarget(self,
                         action: #selector(questionButtonTapped),
                         for: .touchUpInside)
        return button
    }()

    private lazy var settingsButton: UIButton = {
        let button = Components.setupCustomButton(withTitle: "НАСТРОЙКИ")
        button.addTarget(self,
                         action: #selector(settingsButtonTapped),
                         for: .touchUpInside)
        return button
    }()

    private lazy var dayTargetLabel: UILabel = {
        Components.setupCustomLabel(withText: "ЦЕЛЬ НА ДЕНЬ:",
                                    color: UIColor.white,
                                    size: 30)
    }()

    private lazy var targetPointsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [pointsAmountLabel, pointsTextLabel])
        stackView.spacing = 1
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var pointsAmountLabel: UILabel = {
        Components.setupCustomLabel(withText: mainMenuVM.targetPoints.description,
                                    color: UIColor.orange,
                                    size: 30)
    }()

    private lazy var pointsTextLabel: UILabel = {
        Components.setupCustomLabel(withText: "POINTS",
                                    color: UIColor.white,
                                    size: 30)
    }()

    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.tintColor = .systemOrange
        progressView.layer.cornerRadius = Constants.cornerRadius
        progressView.isUserInteractionEnabled = false
        progressView.backgroundColor = .white
        progressView.clipsToBounds = true
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()

    private lazy var userPointsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .orange
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()


    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateProgressView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDefaults.standard.object(forKey: UserSettings.SettingsCase.userModel.rawValue) == nil {
            dismiss(animated: true, completion: nil)
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
        view.addSubview(buttonsStack)
        view.addSubview(dayTargetLabel)
        view.addSubview(targetPointsStack)
        view.addSubview(progressView)
        progressView.addSubview(userPointsLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: view.topAnchor),
            backView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            winSportStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            winSportStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            buttonsStack.topAnchor.constraint(equalTo: winSportStack.bottomAnchor, constant: 40),
            buttonsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStack.widthAnchor.constraint(equalToConstant: Constants.screen.width * 0.7),
            buttonsStack.heightAnchor.constraint(equalToConstant: Constants.screen.height * 0.3),

            dayTargetLabel.topAnchor.constraint(equalTo: buttonsStack.bottomAnchor, constant: 60),
            dayTargetLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            targetPointsStack.topAnchor.constraint(equalTo: dayTargetLabel.bottomAnchor, constant: 16),
            targetPointsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            progressView.centerXAnchor.constraint(equalTo: backView.centerXAnchor),
            progressView.topAnchor.constraint(equalTo: targetPointsStack.bottomAnchor, constant: 16),
            progressView.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 16),
            progressView.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -16),
            progressView.heightAnchor.constraint(equalToConstant: 20),

            userPointsLabel.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),
            userPointsLabel.centerYAnchor.constraint(equalTo: progressView.centerYAnchor)
        ])
    }

    private func updateProgressView() {
        userPointsLabel.text = "\(mainMenuVM.userPoints)"
        userPointsLabel.textColor = mainMenuVM.userPoints > (mainMenuVM.targetPoints / 2) ? .white : .systemOrange
        progressView.setProgress(mainMenuVM.progress, animated: true)
    }

    // MARK: - Actions
    @objc private func trainingButtonTapped() {
        let trainingVC = TrainingViewController()
        trainingVC.modalPresentationStyle = .fullScreen
        present(trainingVC, animated: true)
    }

    @objc private func analyticsButtonTapped() {
        let analyticsVC = AnalyticsViewController()
        analyticsVC.modalPresentationStyle = .fullScreen
        present(analyticsVC, animated: true)
    }

    @objc private func questionButtonTapped() {
        let questionVC = QuestionViewController()
        questionVC.modalPresentationStyle = .fullScreen
        present(questionVC, animated: true)
    }

    @objc private func settingsButtonTapped() {
        let settingsVC = SettingsViewController()
        settingsVC.modalPresentationStyle = .fullScreen
        present(settingsVC, animated: true)
    }
}
