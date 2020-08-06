//
//  CircularProgressView.swift
//  WaterLogging
//
//  Created by Kyle Ryan on 8/2/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit

final class CircularProgressView: UIView {
    private enum Constants {
        static let borderWidth: CGFloat = 12
    }
    
    private let infoStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 12
        return stackView
    }()
    
    private let primaryStatInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 21,
                                       weight: .semibold)
        label.text = "Today's Water"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var primaryStat: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.roundedFont(with: 45,
                                        weight: .semibold)
        label.text = "\(viewModel.currentValue)"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var primaryStatUnit: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = UIFont.roundedFont(with: 15,
                                        weight: .regular)
        label.text = "mL"
        label.textAlignment = .center
        return label
    }()
    
    private let secondaryStatInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 21,
                                       weight: .semibold)
        label.text = "Today's Goal"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var secondaryStat: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.roundedFont(with: 45,
                                        weight: .semibold)
        label.text = "\(viewModel.maxValue)"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var secondaryStatUnit: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = UIFont.roundedFont(with: 15,
                                        weight: .regular)
        label.text = "mL"
        label.textAlignment = .center
        return label
    }()
    
    private var viewModel: CircularProgressViewModel

    init(viewModel: CircularProgressViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setUp()
    }
    
    override func draw(_ rect: CGRect) {
        resetDraw()

        let start: CGFloat = -0.5 * CGFloat.pi
        let end: CGFloat = -0.5 * CGFloat.pi + (2.0 * CGFloat.pi * CGFloat(viewModel.progress))
        var radius = frame.width / 2.0
        let center = CGPoint(x: radius, y: radius)

        // Subtract progress border width from total radius
        radius -= Constants.borderWidth / 2.0

        let progressBackgroundLayer = CAShapeLayer()
        let nonProgressPath = UIBezierPath(arcCenter: center,
                                           radius: radius,
                                           startAngle: 0,
                                           endAngle: CGFloat.pi * 2,
                                           clockwise: true)
        progressBackgroundLayer.path = nonProgressPath.cgPath
        progressBackgroundLayer.lineWidth = Constants.borderWidth
        progressBackgroundLayer.strokeColor = UIColor.systemGray4.cgColor
        progressBackgroundLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(progressBackgroundLayer)

        let progressLayer = CAShapeLayer()
        let progressPath = UIBezierPath(arcCenter: center,
                                        radius: radius,
                                        startAngle: start,
                                        endAngle: end,
                                        clockwise: true)
        progressLayer.path = progressPath.cgPath
        progressLayer.lineWidth = Constants.borderWidth
        progressLayer.strokeColor = viewModel.color.cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(progressLayer)
    }
    
    private func resetDraw() {
        layer.sublayers?
            .filter { $0 is CAShapeLayer }
            .forEach { $0.removeFromSuperlayer() }
    }
    
    private func setUp() {
        addSubview(infoStack)
        
        infoStack.insertArrangedSubview(primaryStatInfoLabel,
                                        at: infoStack.arrangedSubviews.count)
        infoStack.insertArrangedSubview(primaryStat,
                                        at: infoStack.arrangedSubviews.count)
        infoStack.insertArrangedSubview(primaryStatUnit,
                                        at: infoStack.arrangedSubviews.count)
        
        let spacerView = UIView()
        infoStack.insertArrangedSubview(spacerView,
                                        at: infoStack.arrangedSubviews.count)
        
        infoStack.insertArrangedSubview(secondaryStatInfoLabel,
                                        at: infoStack.arrangedSubviews.count)
        infoStack.insertArrangedSubview(secondaryStat,
                                        at: infoStack.arrangedSubviews.count)
        infoStack.insertArrangedSubview(secondaryStatUnit,
                                        at: infoStack.arrangedSubviews.count)
        infoStack.insertArrangedSubview(spacerView,
                                        at: infoStack.arrangedSubviews.count)
        
        NSLayoutConstraint.activate([
            // Info stack
            infoStack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 12),
            infoStack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -12),
            infoStack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -34),
            infoStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 44),
            
            // Stat Units
            primaryStatUnit.heightAnchor.constraint(equalToConstant: 21),
            secondaryStatUnit.heightAnchor.constraint(equalToConstant: 21)

        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(viewModel: CircularProgressViewModel) {
        self.viewModel = viewModel
        primaryStat.text = "\(viewModel.currentValue)"
        secondaryStat.text = "\(viewModel.maxValue)"
        setNeedsDisplay()
    }
}
