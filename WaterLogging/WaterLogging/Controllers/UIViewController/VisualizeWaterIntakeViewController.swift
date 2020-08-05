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
        let todaysProgress: Int

        let todaysWaterIntake = waterLoggingStorage.todaysWaterIntake
        switch todaysWaterIntake {
        case .success(let currentValue):
            todaysProgress = currentValue
        case .failure(let error):
            todaysProgress = 0
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
    
    private let goalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.text = "Goal Calculation"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let goalDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.text = "Based on data from Health, your goal will be automatically calculated if weight data is available."
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let waterGoalGenerator: WaterGoalGenerating
    private let waterGoalsStorage: WaterGoalsStoring
    private let waterLoggingStorage: WaterLoggingStoring

    init(waterGoalGenerator: WaterGoalGenerating,
         waterGoalsStorage: WaterGoalsStoring,
         waterLoggingStorage: WaterLoggingStoring) {
        self.waterGoalGenerator = waterGoalGenerator
        self.waterGoalsStorage = waterGoalsStorage
        self.waterLoggingStorage = waterLoggingStorage
        super.init(nibName: nil, bundle: nil)
        addObservers()
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
        
        // Update water goal if weight has changed in Health
        calculateWaterGoal()
        
        // Refresh progress to display new submissions
        refreshProgress()
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(calculateWaterGoal),
                                               name: NSNotification.Name("healthAuthorizationStatusChanged"), object: nil)
    }

    private func setUp() {
        title = "Visualize"
        view.backgroundColor = .systemBackground
        
        view.addSubview(mainStackView)
        setupStack()
    }
    
    private func setupStack() {
        mainStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        mainStackView.insertArrangedSubview(circularProgressView,
                                            at: mainStackView.arrangedSubviews.count)
        
        if waterGoalGenerator.canGenerateGoal {
            mainStackView.insertArrangedSubview(goalLabel,
                                                at: mainStackView.arrangedSubviews.count)
            mainStackView.insertArrangedSubview(goalDescriptionLabel,
                                                at: mainStackView.arrangedSubviews.count)
        }
        
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

    /// Refresh progress view to refresh values after new submissions
    private func refreshProgress() {
        circularProgressView.configure(viewModel: circularProgressViewModel)
    }
    
    @objc private func calculateWaterGoal() {
        waterGoalGenerator.generateWaterGoal { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let newGoal):
                self.save(newGoal: newGoal)
            case .failure:
                // In the failure case, we will not display an error to the user. We will depend on the default water intake goal.
                break
            }
        }
    }
    
    private func save(newGoal: WaterLogGoal) {
        let result = waterGoalsStorage.save(goal: newGoal)
        switch result {
        case .success:
            // Refresh progress to display updated goal
            self.refreshProgress()
        case .failure(let error):
            displayError(error: error)
        }
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

