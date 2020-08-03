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
        let viewModel = SolidButtonViewModel(type: .secondary,
                                             color: .systemPurple,
                                             title: "Update Daily Goal")
        let button = SolidButton(viewModel: viewModel)
        button.addTarget(self,
                         action: #selector(goalButtonPressed),
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
    
    private let successAlert: UIAlertController = {
        let alert = UIAlertController(title: "Success",
                                      message: "Value was updated.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: .default,
                                      handler: nil))
        return alert
    }()
    
    private func failureAlert(error: Error) -> UIAlertController {
        let alert = UIAlertController(title: "Failure",
                                      message: "There was a failiure saving your record. \(error.localizedDescription)",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: .default,
                                      handler: nil))
        return alert
    }

    private let waterLoggingStorage: WaterLoggingStoring
    private let waterGoalsStorage: WaterGoalsStoring
    
    init(waterLoggingStorage: WaterLoggingStoring,
         waterGoalsStorage: WaterGoalsStoring) {
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
        
        mainStackView.insertArrangedSubview(enterWaterAmountTextField,
                                            at: mainStackView.arrangedSubviews.count)
        mainStackView.insertArrangedSubview(addWaterButton,
                                            at: mainStackView.arrangedSubviews.count)
        mainStackView.insertArrangedSubview(enterGoalAmountTextField,
                                            at: mainStackView.arrangedSubviews.count)
        mainStackView.insertArrangedSubview(updateGoalButton,
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
            updateGoalButton.heightAnchor.constraint(equalToConstant: 48)
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
            displaySuccess()
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
        waterGoalsStorage.save(goal: goal)
        displaySuccess()
        
        // Reset the text field after submission
        enterGoalAmountTextField.text = ""
    }
    
    private func displayError(error: Error) {
        present(failureAlert(error: error),
                animated: true)
    }
    
    private func displaySuccess() {
        present(successAlert,
                animated: true)
    }
}
