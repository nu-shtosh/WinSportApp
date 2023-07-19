//
//  TrainingViewController.swift
//  WinSportApp
//
//  Created by Илья Дубенский on 14.07.2023.
//


import UIKit

final class TrainingViewController: UIViewController {

    // MARK: - View Model

    private var trainingViewModel = TrainingViewModel()

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
        button.addTarget(self,
                         action: #selector(cancelButtonTapped),
                         for: .touchUpInside)
        button.clipsToBounds = true
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var trainingLabel: UILabel = {
        Components.setupCustomLabel(withText: Constants.getCurrentWeekdayRussian(),
                                    color: UIColor.white,
                                    size: 36)
    }()

    private lazy var blurView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        view.layer.cornerRadius = 8
        return view
    }()

    private lazy var trainingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()

    private lazy var trainingTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = .white
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = .max
        return label
    }()

    private lazy var fullTextButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.tintColor = .white
        button.addTarget(self,
                         action: #selector(fullTextButtonTapped),
                         for: .touchUpInside)
        button.clipsToBounds = true
        button.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        button.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainView()
        trainingViewModel.delegate = self
        trainingViewModel.fetchTrainingData()
    }

    // MARK: - Actions
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func fullTextButtonTapped() {
        let fullScreenTextVC = trainingViewModel.createFullScreenTextViewModel()
        present(fullScreenTextVC, animated: true)

    }
}

extension TrainingViewController: TrainingViewModelDelegate {
    func didFetchTrainingData(_ training: Training) {
        trainingViewModel.training = training
        trainingTextLabel.text = training.text
        fetchImage(fromURL: training.img)
    }

    func didFailFetchingTrainingData(with error: Error) {
        print(error.localizedDescription)
    }
}

// MARK: - Private Methods

private extension TrainingViewController {
    
    private func setupMainView() {
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        view.addSubview(backView)
        view.addSubview(cancelButton)
        view.addSubview(winSportStack)
        view.addSubview(trainingLabel)
        view.addSubview(blurView)
        blurView.addSubview(trainingImageView)
        trainingImageView.addSubview(activityIndicator)
        blurView.addSubview(trainingTextLabel)
        blurView.addSubview(fullTextButton)
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

            trainingLabel.topAnchor.constraint(equalTo: winLabel.bottomAnchor, constant: 36),
            trainingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            blurView.topAnchor.constraint(equalTo: trainingLabel.bottomAnchor, constant: 16),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            blurView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),

            trainingImageView.topAnchor.constraint(equalTo: blurView.topAnchor, constant: 16),
            trainingImageView.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: 16),
            trainingImageView.trailingAnchor.constraint(equalTo: blurView.trailingAnchor, constant: -16),
            trainingImageView.heightAnchor.constraint(equalToConstant: 200),

            activityIndicator.centerXAnchor.constraint(equalTo: trainingImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: trainingImageView.centerYAnchor),

            trainingTextLabel.topAnchor.constraint(equalTo: trainingImageView.bottomAnchor, constant: 16),
            trainingTextLabel.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: 16),
            trainingTextLabel.trailingAnchor.constraint(equalTo: blurView.trailingAnchor, constant: -16),
            trainingTextLabel.bottomAnchor.constraint(equalTo: blurView.bottomAnchor, constant: -26),

            fullTextButton.centerXAnchor.constraint(equalTo: blurView.centerXAnchor),
            fullTextButton.bottomAnchor.constraint(equalTo: blurView.bottomAnchor, constant: -8)
        ])
    }

    private func fetchImage(fromURL: String) {
        trainingViewModel.fetchImage(fromURL: fromURL) { [self] result in
            switch result {
            case .success(let imageData):
                trainingImageView.image = UIImage(data: imageData)
                activityIndicator.stopAnimating()
            case .failure(let error):
                print(error)
            }
        }
    }
}
