//
//  AnalyticsViewController.swift
//  WinSportApp
//
//  Created by Илья Дубенский on 14.07.2023.
//

import UIKit


final class AnalyticsViewController: UIViewController {

    // MARK: - View Model

    private var analyticsViewModel = AnalyticsViewModel()

    // MARK: - UIElements

    private lazy var backView: UIImageView = {
        Components.setupCustomBackground()
    }()

    private lazy var winSportStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [winLabel,
                                                       sportLabel])
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

    private lazy var analyticsLabel: UILabel = {
        Components.setupCustomLabel(withText: "АНАЛИТИКА",
                                           color: UIColor.white,
                                           size: 36)
    }()

    private lazy var inputDataLabel: UILabel = {
        Components.setupCustomLabel(withText: "ВНЕСИТЕ ДАННЫЕ",
                                           color: UIColor.white,
                                           size: 12)
    }()

    private lazy var textFieldsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [distanceTextField,
                                                       squatsTextField])
        stackView.spacing = 10
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var distanceTextField: UITextField = {
        let textField = Components.setupCustomTextField(withPlaceholder: "РАССТОЯНИЕ (КМ)")
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        return textField
    }()

    private lazy var squatsTextField: UITextField = {
        let textField = Components.setupCustomTextField(withPlaceholder: "ПРИСЕДАНИЯ (РАЗ)")
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        return textField
    }()

    private lazy var strikeStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [strikeLabel,
                                                       multiplierLabel])
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var strikeLabel: UILabel = {
        Components.setupCustomLabel(withText: "УДАРЫ:",
                                           color: UIColor.systemOrange,
                                           size: 20)
    }()

    private lazy var multiplierLabel: UILabel = {
        Components.setupCustomLabel(withText: analyticsViewModel.userStrikes.description + "X",
                                           color: UIColor.white,
                                           size: 50)
    }()

    private lazy var enterDataButton: UIButton = {
        let button = Components.setupCustomButton(withTitle: "ВНЕСТИ")
        button.addTarget(self,
                         action: #selector(enterDataButtonTapped),
                         for: .touchUpInside)
        return button
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

    // MARK: - Actions
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func enterDataButtonTapped() {

        let fields = [(squatsTextField, "ВВЕДИТЕ ПРИСЕДАНИЯ"),
                      (distanceTextField, "ВВЕДИТЕ РАССТОЯНИЕ")]

        let isValidate = analyticsViewModel.validateFields(fields: fields)

        guard let squats = squatsTextField.text, let squats = Int(squats),
              let distance = distanceTextField.text, let distance = Int(distance) else { return }

        if isValidate {
            let userWeight = analyticsViewModel.userWeight
            
            analyticsViewModel.userPoints += analyticsViewModel.countPoints(withSquats: squats,
                                                                            distance: distance,
                                                                            andUserWeight: userWeight)
            analyticsViewModel.userStrikes += 1
            analyticsViewModel.saveUserModel(userName: UserSettings.userModel.name,
                                             userWeight: UserSettings.userModel.weight,
                                             userHeight: UserSettings.userModel.height,
                                             userPoints: analyticsViewModel.userPoints,
                                             userStrike: analyticsViewModel.userStrikes)
            updateMultiplierLabel()
            updateProgressView()
        }
    }
}

// MARK: - Private Methods

private extension AnalyticsViewController {
    private func setupMainView() {
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        view.addSubview(backView)
        view.addSubview(cancelButton)
        view.addSubview(winSportStack)
        view.addSubview(analyticsLabel)
        view.addSubview(inputDataLabel)
        view.addSubview(textFieldsStack)
        view.addSubview(strikeStack)
        view.addSubview(enterDataButton)
        view.addSubview(progressView)
        progressView.addSubview(userPointsLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: view.topAnchor),
            backView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),

            winSportStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            winSportStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            analyticsLabel.topAnchor.constraint(equalTo: winLabel.bottomAnchor, constant: 36),
            analyticsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            inputDataLabel.topAnchor.constraint(equalTo: analyticsLabel.bottomAnchor, constant: 16),
            inputDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            textFieldsStack.centerXAnchor.constraint(equalTo: backView.centerXAnchor),
            textFieldsStack.heightAnchor.constraint(equalToConstant: Constants.screen.height * 0.20),
            textFieldsStack.topAnchor.constraint(equalTo: inputDataLabel.bottomAnchor, constant: 26),
            textFieldsStack.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 26),
            textFieldsStack.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -26),

            strikeStack.topAnchor.constraint(equalTo: textFieldsStack.bottomAnchor, constant: 26),
            strikeStack.centerXAnchor.constraint(equalTo: backView.centerXAnchor),

            enterDataButton.topAnchor.constraint(equalTo: strikeStack.bottomAnchor, constant: 26),
            enterDataButton.heightAnchor.constraint(equalToConstant: 60),
            enterDataButton.widthAnchor.constraint(equalToConstant: 200),
            enterDataButton.centerXAnchor.constraint(equalTo: backView.centerXAnchor),

            progressView.centerXAnchor.constraint(equalTo: backView.centerXAnchor),
            progressView.topAnchor.constraint(equalTo: enterDataButton.bottomAnchor, constant: 16),
            progressView.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 16),
            progressView.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -16),
            progressView.heightAnchor.constraint(equalToConstant: 20),

            userPointsLabel.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),
            userPointsLabel.centerYAnchor.constraint(equalTo: progressView.centerYAnchor)
        ])
    }

    private func updateProgressView() {
        userPointsLabel.text = analyticsViewModel.userPoints.description
        userPointsLabel.textColor = analyticsViewModel.pointsIsMoreThenHalf ? .white : .systemOrange
        progressView.setProgress(analyticsViewModel.progress, animated: true)
    }

    private func updateMultiplierLabel() {
        multiplierLabel.text = analyticsViewModel.userStrikesDescription
    }
}

// MARK: - Touches Began

extension AnalyticsViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super .touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}
