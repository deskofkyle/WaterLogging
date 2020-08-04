//
//  TrackWaterViewController.swift
//  WaterLogging
//
//

import UIKit

protocol TrackWaterViewControllerFactory {
    func makeTrackWaterViewController() -> TrackWaterViewController
}

final class TrackWaterViewController: UIViewController {
    
    private let logWaterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.text = "Enter Today's Water"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let logWaterDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.text = "Enter today's water intake in milliliters (mL) to keep track of your hyrdration over time."
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let goalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.text = "Enter Today's Goal"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let goalDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.text = "To maintain progress over time, you can enter a water intake goal in milliliters (mL)."
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let healthLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.text = "Enable Health"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let healthDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.text = "This app can automatically generate a water intake goal based on your weight when authorized to read from Health."
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addWaterButton: SolidButton = {
        let viewModel = SolidButtonViewModel(type: .primary,
                                             color: .systemBlue,
                                             title: "Log Water")
        let button = SolidButton(viewModel: viewModel)
        button.addTarget(self,
                         action: #selector(addWaterButtonPressed),
                         for: .touchUpInside)
        return button
    }()
    
    private let updateGoalButton: SolidButton = {
        let viewModel = SolidButtonViewModel(type: .primary,
                                             color: .systemPurple,
                                             title: "Update Daily Goal")
        let button = SolidButton(viewModel: viewModel)
        button.addTarget(self,
                         action: #selector(goalButtonPressed),
                         for: .touchUpInside)
        return button
    }()
    
    private let authorizeHealthButton: SolidButton = {
        let viewModel = SolidButtonViewModel(type: .secondary,
                                             color: .systemRed,
                                             title: "Authorize Health")
        let button = SolidButton(viewModel: viewModel)
        button.addTarget(self,
                         action: #selector(authorizeHealth),
                         for: .touchUpInside)
        return button
    }()

    let enterWaterAmountTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter a value (mL)"
        textField.returnKeyType = .done
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let enterGoalAmountTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter a value (mL)"
        textField.returnKeyType = .done
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    private let healthAuthSuccessAlert: UIAlertController = {
        let alert = UIAlertController(title: "Authorized",
                                      message: "HealthKit has already been authorized to read a user's weight.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: .default,
                                      handler: nil))
        return alert
    }()
    
    private let entrySuccessAlert: UIAlertController = {
        let alert = UIAlertController(title: "Success",
                                      message: "Your water intake value was saved.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: .default,
                                      handler: nil))
        return alert
    }()
    
    private func failureAlert(error: Error) -> UIAlertController {
        let alert = UIAlertController(title: "Failure",
                                      message: "\(error.localizedDescription)",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: .default,
                                      handler: nil))
        return alert
    }

    private let healthQueryGenerator: HealthQuerying
    private let waterLoggingStorage: WaterLoggingStoring
    private let waterGoalsStorage: WaterGoalsStoring
    
    init(healthQueryGenerator: HealthQuerying,
         waterLoggingStorage: WaterLoggingStoring,
         waterGoalsStorage: WaterGoalsStoring) {
        self.healthQueryGenerator = healthQueryGenerator
        self.waterLoggingStorage = waterLoggingStorage
        self.waterGoalsStorage = waterGoalsStorage
        super.init(nibName: nil, bundle: nil)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Set Up
    
    private func setUp() {
        title = "Track"
        view.backgroundColor = .systemBackground
        view.addSubview(mainStackView)
        
        mainStackView.insertArrangedSubview(logWaterLabel,
                                            at: mainStackView.arrangedSubviews.count)
        mainStackView.insertArrangedSubview(logWaterDescriptionLabel,
                                            at: mainStackView.arrangedSubviews.count)
        mainStackView.insertArrangedSubview(enterWaterAmountTextField,
                                            at: mainStackView.arrangedSubviews.count)
        mainStackView.insertArrangedSubview(addWaterButton,
                                            at: mainStackView.arrangedSubviews.count)
        mainStackView.insertArrangedSubview(goalLabel,
                                            at: mainStackView.arrangedSubviews.count)
        mainStackView.insertArrangedSubview(goalDescriptionLabel,
                                            at: mainStackView.arrangedSubviews.count)
        mainStackView.insertArrangedSubview(enterGoalAmountTextField,
                                            at: mainStackView.arrangedSubviews.count)
        mainStackView.insertArrangedSubview(updateGoalButton,
                                            at: mainStackView.arrangedSubviews.count)
        mainStackView.insertArrangedSubview(healthLabel,
                                            at: mainStackView.arrangedSubviews.count)
        mainStackView.insertArrangedSubview(healthDescriptionLabel,
                                            at: mainStackView.arrangedSubviews.count)
        mainStackView.insertArrangedSubview(authorizeHealthButton,
                                            at: mainStackView.arrangedSubviews.count)
        
        
        let spacerView = UIView()
        mainStackView.insertArrangedSubview(spacerView,
                                            at: mainStackView.arrangedSubviews.count)

        NSLayoutConstraint.activate([
            // Main stack
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            
            // Add water
            enterWaterAmountTextField.heightAnchor.constraint(equalToConstant: 44),
            addWaterButton.heightAnchor.constraint(equalToConstant: 48),
            
            // Update goal
            enterGoalAmountTextField.heightAnchor.constraint(equalToConstant: 44),
            updateGoalButton.heightAnchor.constraint(equalToConstant: 48),
            
            // Health auth
            authorizeHealthButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    // Actions
    
    @objc private func addWaterButtonPressed() {
        view.endEditing(true)
        let amount = Double(enterWaterAmountTextField.text ?? "") ?? 0
        let record = WaterLogRecord(amount: amount,
                              createdAt: Date(),
                              lastUpdated: Date())
        let result = waterLoggingStorage.save(record: record)
        switch result {
        case .success:
            displayEntrySuccess()
        case .failure(let error):
            displayError(error: error)
        }
        
        // Reset the text field after submission
        enterWaterAmountTextField.text = ""
    }
    
    @objc private func goalButtonPressed() {
        view.endEditing(true)
        let amount = Double(enterGoalAmountTextField.text ?? "") ?? 0
        let goal = WaterLogGoal(amount: amount)
        let result = waterGoalsStorage.save(goal: goal)
        switch result {
        case .success:
            displayEntrySuccess()
        case .failure(let error):
            displayError(error: error)
        }
        
        // Reset the text field after submission
        enterGoalAmountTextField.text = ""
    }

    @objc private func authorizeHealth() {
        healthQueryGenerator.authorizeHealth { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success:
                // In this case, the user has seen the Health permissions screen. We can expand this to display a visual representation that the user has seen the Health permission already.
                break
            case .failure(let error):
                self.displayError(error: error)
            }
        }
    }
    
    private func displayError(error: Error) {
        present(failureAlert(error: error),
                animated: true)
    }
    
    private func displayEntrySuccess() {
        present(entrySuccessAlert,
                animated: true)
    }
    
    private func displayHealthSuccessAlert() {
        present(healthAuthSuccessAlert,
                animated: true)
    }
}
