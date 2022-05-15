//
//  MainCoordinator.swift
//  Marvel
//
//  Created by mike on 11.05.2022.
//

import Foundation
import UIKit
import Combine

final class MainCoordinator {
	
	private let window: UIWindow
	private lazy var navigationViewController = UINavigationController(rootViewController: makeListView())
	
	private lazy var db = DatabaseCoordinator(name: "DB")
	private lazy var network = NetworkManager()
	private lazy var apiKeyProvider = ApiKeyProvider(publicKey: NetworkConstants.publicKey,
													 privateKey: NetworkConstants.privateKey)
	private lazy var characterProvider = CharactersProvider(keyProvider: apiKeyProvider, network: network)
	private lazy var characterService = CharacterService(squadProvider: SquadProvider(db: db),
														 characterProvider: characterProvider)
	
	private let characterPublisher = PassthroughSubject<Int, Never>()
	private var subscription = Subscriptions()
	
	init(window: UIWindow) {
		self.window = window
		
		window.overrideUserInterfaceStyle = .dark
	}
	
	func start() {
		bind()
		
		window.rootViewController = navigationViewController
		window.makeKeyAndVisible()
		
	}
}

private extension MainCoordinator {
	func makeListView() -> UIViewController {
		let viewModel = ListViewModel(service: characterService, characterOpenPublisher: characterPublisher)
		let viewController = ListViewController(viewModel: viewModel)
		
		return viewController
	}
	
	func showCharacter(by id: Int) {
		let viewModel = DetailsViewModel(service: characterService, characterId: id)
		let viewController = DetailsViewController(viewModel: viewModel)
		navigationViewController.pushViewController(viewController, animated: true)
	}
	
	func bind() {
		characterPublisher
			.sink { [weak self] id in
				self?.showCharacter(by: id)
			}
			.store(in: &subscription)
	}
}
