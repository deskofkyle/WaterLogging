//
//  SceneDelegate.swift
//  WaterLogging
//
//  Created by Jessie Pease on 5/18/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = MainDependencyContainer.shared.makeAppTabBarController()
        window.makeKeyAndVisible()
        self.window = window
    }
}

