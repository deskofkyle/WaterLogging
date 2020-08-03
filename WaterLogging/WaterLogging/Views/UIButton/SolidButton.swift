//
//  SolidButton.swift
//  WaterLogging
//
//  Created by Kyle Ryan on 8/2/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit

struct SolidButtonViewModel {
    enum SolidButtonType {
        /// Rounded button with filled background color
        case primary
        /// Rounded button with 2px border
        case secondary
    }

    let type: SolidButtonType
    let color: UIColor
    let title: String
}

final class SolidButton: UIButton {
    private enum Constants {
        static let buttonFont = UIFont.systemFont(ofSize: 17,
                                                  weight: .semibold)
        static let cornerRadius: CGFloat = 12
        static let borderWidth: CGFloat = 2
    }

    private let viewModel: SolidButtonViewModel
    
    init(viewModel: SolidButtonViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setTitle(viewModel.title,
                 for: .normal)
        titleLabel?.font = Constants.buttonFont
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = Constants.cornerRadius
        
        switch viewModel.type {
        case .primary:
            backgroundColor = viewModel.color
        case .secondary:
            backgroundColor = .systemBackground
            setTitleColor(viewModel.color,
                          for: .normal)
            layer.borderColor = viewModel.color.cgColor
            layer.borderWidth = Constants.borderWidth
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
