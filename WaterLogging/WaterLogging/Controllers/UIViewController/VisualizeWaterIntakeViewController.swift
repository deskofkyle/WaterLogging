//
//  VisualizeWaterIntakeViewController.swift
//  WaterLogging
//
//

import UIKit

protocol VisualizeWaterIntakeViewControllerFactory {
    func makeVisualizeWaterIntakeViewController() -> VisualizeWaterIntakeViewController
}

final class VisualizeWaterIntakeViewController: UIViewController {
    
    private var circularProgressViewModel: CircularProgressViewModel {
        let todaysProgress: Double

        let todaysWaterIntake = waterLoggingStorage.todaysWaterIntake
        switch todaysWaterIntake {
        case .success(let currentValue):
            todaysProgress = currentValue
        case .failure(let error):
            todaysProgress = 0.0
            displayError(error: error)
        }

        let maxValue = waterGoalsStorage.currentGoal.amount
        let viewModel = CircularProgressViewModel(color: .systemIndigo,
                                                  currentValue: todaysProgress,
                                                  maxValue: maxValue)
        return viewModel
    }
    
    private lazy var circularProgressView: CircularProgressView = {
        let view = CircularProgressView(viewModel: circularProgressViewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    private let waterLoggingStorage: WaterLoggingStoring
    private let waterGoalsStorage: WaterGoalsStoring

    init(waterLoggingStorage: WaterLoggingStoring,
         waterGoalsStorage: WaterGoalsStoring) {
        self.waterLoggingStorage = waterLoggingStorage
        self.waterGoalsStorage = waterGoalsStorage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /// Refresh progress view to refresh values after new submissions
        circularProgressView.configure(viewModel: circularProgressViewModel)
    }
    
    // Set Up

    private func setUp() {
        title = "Visualize"
        view.backgroundColor = .systemBackground
        
        view.addSubview(mainStackView)
        
        mainStackView.insertArrangedSubview(circularProgressView,
                                            at: mainStackView.arrangedSubviews.count)
        
        mainStackView.insertArrangedSubview(UIView(),
                                            at: mainStackView.arrangedSubviews.count)
        
        NSLayoutConstraint.activate([
            // Main stack
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
        
            // CircularProgressView
            circularProgressView.widthAnchor.constraint(equalTo: circularProgressView.heightAnchor,
                                                        multiplier: 1)
        ])
    }
    
    private func displayError(error: Error) {
        present(failureAlert(error: error),
                animated: true)
    }
    
    private func failureAlert(error: Error) -> UIAlertController {
        let alert = UIAlertController(title: "Failure",
                                      message: "There was a failiure retrieving today's water intake. \(error.localizedDescription)",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: .default,
                                      handler: nil))
        return alert
    }
}

