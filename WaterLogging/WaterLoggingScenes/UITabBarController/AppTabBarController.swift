//
//  AppTabBarController.swift
//  WaterLogging
//
//

import UIKit

final class AppTabBarController: UITabBarController {
    
    private let trackWaterViewController: TrackWaterViewController
    
    init(trackWaterViewController: TrackWaterViewController) {
        self.trackWaterViewController = trackWaterViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let addImage = UIImage(systemName: "plus.circle")
        let vizImage = UIImage(systemName: "chart.bar")
        
        trackWaterViewController.tabBarItem = UITabBarItem(title: "Track", image: addImage, tag: 0)

        let visualizeWaterIntakeViewController = VisualizeWaterIntakeViewController()
        visualizeWaterIntakeViewController.tabBarItem = UITabBarItem(title: "Visualize", image: vizImage, tag: 1)

        let tabBarList = [trackWaterViewController, visualizeWaterIntakeViewController]

        viewControllers = tabBarList
    }

}
