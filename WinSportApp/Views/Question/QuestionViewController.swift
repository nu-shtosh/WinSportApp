//
//  QuestionViewController.swift
//  WinSportApp
//
//  Created by Илья Дубенский on 14.07.2023.
//

import UIKit

class QuestionViewController: UIViewController {

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
        button.addTarget(self,
                         action: #selector(cancelButtonTapped),
                         for: .touchUpInside)
        button.clipsToBounds = true
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var questionLabel: UILabel = {
        Components.setupCustomLabel(withText: "ВОПРОС ТРЕНЕРУ",
                                    color: UIColor.white,
                                    size: 36)
    }()

    private lazy var questionTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Введите вопрос"
        textField.borderStyle = .roundedRect
        return textField
    }()

    private lazy var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Отправить", for: .normal)
        button.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var responseLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .center
        return label
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
        view.addSubview(questionLabel)
        view.addSubview(questionTextField)
        view.addSubview(submitButton)
        view.addSubview(responseLabel)

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

            questionTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            questionTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            questionTextField.widthAnchor.constraint(equalToConstant: 200),

            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.topAnchor.constraint(equalTo: questionTextField.bottomAnchor, constant: 16),

            responseLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            responseLabel.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 16)
        ])
    }

    // MARK: - Actions
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    private func generateQuestionID() -> String {
        return UUID().uuidString
    }

    // MARK: - Actions
    @objc private func submitButtonTapped() {
        guard let question = questionTextField.text else { return }
        let questionID = generateQuestionID()
        sendQuestionToServer(question: question, questionID: questionID)
        responseLabel.text = "Ответ обрабатывается"
        fetchResponseFromServer(questionID: questionID)
    }

    private func sendQuestionToServer(question: String, questionID: String) {
        let urlString = "http://84.38.181.162/ios/ask.php"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters = ["ask": question, "id": questionID]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = jsonData
        } catch {
            print("Error serializing parameters: \(error)")
            return
        }

//        URLSession.shared.dataTask(with: request) { data, _, error in
//            // Обработка ответа или ошибки
//        }.resume()
    }


    private func fetchResponseFromServer(questionID: String) {
                let urlString = "http://84.38.181.162/ios/response.php?id=\(questionID)"
//        let urlString = "http://84.38.181.162/ios/response.php?id=1"

        NetworkManager.shared.fetchData(Response.self, from: urlString) { [self] result in
            switch result {
            case .success(let response):
                responseLabel.text = response.response
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

struct Response: Codable {
    let response: String
}
