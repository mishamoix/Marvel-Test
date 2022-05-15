//
//  SceneDelegate.swift
//  Marvel
//
//  Created by mike on 11.05.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	
	var window: UIWindow?
	private var coordinator: MainCoordinator?
	
	func scene(_ scene: UIScene,
			   willConnectTo session: UISceneSession,
			   options connectionOptions: UIScene.ConnectionOptions) {
		guard let scene = (scene as? UIWindowScene) else { return }
		
		let window = UIWindow(windowScene: scene)
		coordinator = MainCoordinator(window: window)
		coordinator?.start()
	}
}

