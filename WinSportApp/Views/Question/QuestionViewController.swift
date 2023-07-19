//
//  QuestionViewController.swift
//  WinSportApp
//
//  Created by Илья Дубенский on 14.07.2023.
//

import UIKit

final class QuestionViewController: UIViewController {

    // MARK: - View Model

    private let questionViewModel = QuestionViewModel()

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

    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        button.clipsToBounds = true
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self,
                         action: #selector(cancelButtonTapped),
                         for: .touchUpInside)
        return button
    }()

    private lazy var questionLabel: UILabel = {
        Components.setupCustomLabel(withText: "ВОПРОС ТРЕНЕРУ",
                                    color: UIColor.white,
                                    size: 36)
    }()

    private lazy var questionTextField: UITextField = {
        let textField = Components.setupCustomTextField(withPlaceholder: "Введите вопрос")
        textField.rightViewMode = .always

        let sendQuestionButton = UIButton(type: .custom)
        sendQuestionButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        sendQuestionButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        sendQuestionButton.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        sendQuestionButton.translatesAutoresizingMaskIntoConstraints = false
        sendQuestionButton.tintColor = .white

        sendQuestionButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)

        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        rightView.addSubview(sendQuestionButton)

        sendQuestionButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sendQuestionButton.topAnchor.constraint(equalTo: rightView.topAnchor),
            sendQuestionButton.leadingAnchor.constraint(equalTo: rightView.leadingAnchor),
            sendQuestionButton.trailingAnchor.constraint(equalTo: rightView.trailingAnchor, constant: -24),
            sendQuestionButton.bottomAnchor.constraint(equalTo: rightView.bottomAnchor)
        ])

        textField.rightView = rightView
        return textField
    }()

    private lazy var blurView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        view.layer.cornerRadius = 8
        return view
    }()

    private lazy var responseLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = .max
        label.textAlignment = .left
        return label
    }()

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainView()
    }

    // MARK: - Actions

    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func playButtonTapped() {
        guard let question = questionTextField.text else { return }
        let questionID = questionViewModel.generateQuestionID()
        questionViewModel.sendQuestion(question: question, questionID: questionID) {_ in }

        responseLabel.text = "Ответ обрабатывается"

        self.questionViewModel.fetchResponse(questionID: questionID) { [self] result in
            switch result {
            case .success(let response):
                responseLabel.text = (questionTextField.text ?? "") + "\nОТВЕТ:\n" + response
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - Private Methods

private extension QuestionViewController {
    private func setupMainView() {
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        view.addSubview(backView)
        view.addSubview(cancelButton)
        view.addSubview(winSportStack)
        view.addSubview(questionLabel)
        view.addSubview(questionTextField)
        view.addSubview(blurView)
        blurView.addSubview(responseLabel)
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

            questionLabel.topAnchor.constraint(equalTo: winLabel.bottomAnchor, constant: 36),
            questionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            questionTextField.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 16),
            questionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            questionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            questionTextField.heightAnchor.constraint(equalToConstant: 80),

            blurView.topAnchor.constraint(equalTo: questionTextField.bottomAnchor, constant: 16),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),

            responseLabel.topAnchor.constraint(equalTo: blurView.topAnchor, constant: 16),
            responseLabel.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: 16),
            responseLabel.trailingAnchor.constraint(equalTo: blurView.trailingAnchor, constant: -16),
        ])
    }
}

// MARK: - Touches Began

extension QuestionViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super .touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}
