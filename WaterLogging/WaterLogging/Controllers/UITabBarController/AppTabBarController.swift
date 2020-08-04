//
//  AppTabBarController.swift
//  WaterLogging
//
//

import UIKit

protocol TabBarControllerFactory {
    func makeAppTabBarController() -> UITabBarController
}

final class AppTabBarController: UITabBarController {
    
    private let trackWaterViewController: TrackWaterViewController
    private let visualizeWaterIntakeViewController: VisualizeWaterIntakeViewController

    init(trackWaterViewController: TrackWaterViewController,
         visualizeWaterIntakeViewController: VisualizeWaterIntakeViewController) {
        self.trackWaterViewController = trackWaterViewController
        self.visualizeWaterIntakeViewController = visualizeWaterIntakeViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let addImage = UIImage(systemName: "plus.circle")
        let vizImage = UIImage(systemName: "chart.bar")
        
        trackWaterViewController.tabBarItem = UITabBarItem(title: "Track",
                                                           image: addImage,
                                                           tag: 0)
        visualizeWaterIntakeViewController.tabBarItem = UITabBarItem(title: "Visualize",
                                                                     image: vizImage,
                                                                     tag: 1)

        let tabBarList = [trackWaterViewController,
                          visualizeWaterIntakeViewController]
            .map { UINavigationController(rootViewController: $0) }
        viewControllers = tabBarList
    }
}
