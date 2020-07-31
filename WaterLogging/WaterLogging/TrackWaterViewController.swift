//
//  TrackWaterViewController.swift
//  WaterLogging
//
//

import UIKit

class TrackWaterViewController: UIViewController {
    
    private let addWaterButton = UIButton()
    private let updateGoalButton = UIButton()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Set Up
    
    private func setUp() {
        addWaterButton.setTitle("Add 8 oz Water", for: .normal)
        updateGoalButton.setTitle("Update Daily Goal", for: .normal)
        addWaterButton.addTarget(self, action: #selector(addWaterButtonPressed), for: .touchUpInside)
        updateGoalButton.addTarget(self, action: #selector(goalButtonPressed), for: .touchUpInside)
        
        view.backgroundColor = .systemBackground
        addWaterButton.backgroundColor = .black
        updateGoalButton.backgroundColor = .black
        
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        let container = UIView()
        addWaterButton.translatesAutoresizingMaskIntoConstraints = false
        updateGoalButton.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(addWaterButton)
        container.addSubview(updateGoalButton)
        container.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(container)
        
        // Buttons constraints
        let addWaterButtonConstraints = [addWaterButton.topAnchor.constraint(equalTo: container.topAnchor),
                                         addWaterButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                                         addWaterButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),]
        
        NSLayoutConstraint.activate(addWaterButtonConstraints)
        
        let updateGoalButtonConstraints = [updateGoalButton.topAnchor.constraint(equalTo: addWaterButton.bottomAnchor, constant: 10),
                                           updateGoalButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                                           updateGoalButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                                           updateGoalButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)]
        
        NSLayoutConstraint.activate(updateGoalButtonConstraints)
        
        // ContainerView constraints
        
        let containerConstraints = [container.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                    container.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                                    container.topAnchor.constraint(greaterThanOrEqualTo: self.view.topAnchor),
                                    container.leadingAnchor.constraint(greaterThanOrEqualTo: self.view.leadingAnchor),
                                    container.trailingAnchor.constraint(lessThanOrEqualTo: self.view.trailingAnchor),
                                    container.bottomAnchor.constraint(lessThanOrEqualTo: self.view.bottomAnchor)]
        
        NSLayoutConstraint.activate(containerConstraints)
        
    }
    
    // Actions
    
    @objc private func addWaterButtonPressed() {
        print("Add water button pressed")
    }
    
    @objc private func goalButtonPressed() {
        print("Goal button pressed")
    }
    

}

