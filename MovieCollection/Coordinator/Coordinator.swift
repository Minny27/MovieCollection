//
//  Coordinator.swift
//  MovieCollection
//
//  Created by SeungMin on 2022/04/13.
//

import UIKit

class Coordinator {
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let navigationController = UINavigationController(rootViewController: HomeViewController())
        navigationController.overrideUserInterfaceStyle = .light
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
