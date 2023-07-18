//
//  UserProfile.swift
//  WinSportApp
//
//  Created by Илья Дубенский on 13.07.2023.
//

import UIKit


final class RegistrationViewController: UIViewController {

    private let registrationVM = RegistrationViewModel()

    // MARK: - UI Elements
    private lazy var backView: UIImageView = {
        Components.setupCustomBackground()
    }()

    private lazy var beginTrainingLabel: UILabel = {
        let label = UILabel()
        label.text = "НАЧАТЬ ТРЕНЕРОВКУ"
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.numberOfLines = 2
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
                                    size: 14)
    }()

    private lazy var sportLabel: UILabel = {
        Components.setupCustomLabel(withText: "SPORT",
                                    color: UIColor.white,
                                    size: 14)
    }()

    private lazy var textFieldsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameTextField,
                                                       weightTextField,
                                                       heightTextField])
        stackView.spacing = 10
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var nameTextField: UITextField = {
        Components.setupCustomTextField(withPlaceholder: "ИМЯ")
    }()

    private lazy var weightTextField: UITextField = {
        Components.setupCustomTextField(withPlaceholder: "ВЕС")
    }()

    private lazy var heightTextField: UITextField = {
        Components.setupCustomTextField(withPlaceholder: "РОСТ")
    }()

    private lazy var startButton: UIButton = {
        let button = Components.setupCustomButton(withTitle: "НАЧАТЬ")
        button.addTarget(self,
                         action: #selector(startButtonTapped),
                         for: .touchUpInside)
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
        view.addSubview(winSportStack)
        view.addSubview(beginTrainingLabel)
        view.addSubview(textFieldsStack)
        view.addSubview(startButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: view.topAnchor),
            backView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            winSportStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            winSportStack.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),

            beginTrainingLabel.centerXAnchor.constraint(equalTo: backView.centerXAnchor),
            beginTrainingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            beginTrainingLabel.widthAnchor.constraint(equalToConstant: 180),

            textFieldsStack.centerXAnchor.constraint(equalTo: backView.centerXAnchor),
            textFieldsStack.heightAnchor.constraint(equalToConstant: Constants.screen.height * 0.25),
            textFieldsStack.topAnchor.constraint(equalTo: beginTrainingLabel.bottomAnchor, constant: 26),
            textFieldsStack.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 26),
            textFieldsStack.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -26),

            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.topAnchor.constraint(equalTo: textFieldsStack.bottomAnchor, constant: 20),
            startButton.widthAnchor.constraint(equalToConstant: 160),
            startButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    // MARK: - Actions

    @objc private func startButtonTapped() {
        guard let userName = nameTextField.text?.trimmingCharacters(in: .whitespaces),
              let userWeightString = weightTextField.text,
              let userHeightString = heightTextField.text else { return }

        let fields = [
            (nameTextField, "ВВЕДИТЕ ИМЯ"),
            (weightTextField, "ВВЕДИТЕ ВЕС"),
            (heightTextField, "ВВЕДИТЕ РОСТ")
        ]

        if registrationVM.validateFields(fields: fields) {
            if let userWeight = Int(userWeightString) {
                if let userHeight = Int(userHeightString) {
                    registrationVM.saveUserModel(userName: userName,
                                                 userWeight: userWeight,
                                                 userHeight: userHeight,
                                                 userPoints: 0)
                    clearTextFields()
                    navigateToNextScreen()
                } else {
                    heightTextField.text = ""
                    heightTextField.placeholder = "ВВЕДИТЕ РОСТ"
                    heightTextField.shake()
                }
            } else {
                weightTextField.text = ""
                weightTextField.placeholder = "ВВЕДИТЕ ВЕС"
                weightTextField.shake()
            }
        }
    }

    private func clearTextFields() {
        nameTextField.text = ""
        weightTextField.text = ""
        heightTextField.text = ""
    }

    private func navigateToNextScreen() {
        let mainMenuVC = MainMenuViewController()
        mainMenuVC.modalPresentationStyle = .fullScreen
        present(mainMenuVC, animated: true)
    }
}
