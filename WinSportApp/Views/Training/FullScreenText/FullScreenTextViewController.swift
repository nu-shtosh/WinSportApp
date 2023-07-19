//
//  FullScreenTextViewController.swift
//  WinSportApp
//
//  Created by Илья Дубенский on Constants.sixteen.07.2023.
//

import UIKit

final class FullScreenTextViewController: UIViewController {

    // MARK: - View Model

    var fullScreenTextViewModel: FullScreenTextViewModel?

    // MARK: - UIElements

    private lazy var backView: UIImageView = {
        Components.setupCustomBackground()
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

    private lazy var trainingTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.font = .systemFont(ofSize: 24)
        return textView
    }()


    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainView()
        setupTextView()
    }

    // MARK: - Actions
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Private Methods

private extension FullScreenTextViewController {
    private func setupMainView() {
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        view.addSubview(backView)
        view.addSubview(cancelButton)
        view.addSubview(trainingTextView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: view.topAnchor),
            backView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                  constant: Constants.sixteen),
            cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                              constant: Constants.sixteen),

            trainingTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            trainingTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor
                                                      , constant: Constants.sixteen),
            trainingTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                       constant: -Constants.sixteen),
            trainingTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                     constant: -Constants.sixteen),
        ])
    }

    private func setupTextView() {
        if let trainingText = fullScreenTextViewModel?.training?.text {
            trainingTextView.text = trainingText
        }
    }
}
