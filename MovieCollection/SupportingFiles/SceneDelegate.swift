//
//  SceneDelegate.swift
//  MovieCollection
//
//  Created by SeungMin on 2022/04/13.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: scene)
        let coordinator = Coordinator(window: window!)
        coordinator.start()
    }
}

