//
//  ListViewModel.swift
//  Marvel
//
//  Created by mike on 11.05.2022.
//

import Foundation
import Combine

final class ListViewModel {
	
	private let lifecycle = PassthroughSubject<LifecycleAction, Never>()
	private let viewEvents = PassthroughSubject<ListActions.ViewEvents, Never>()
	
	private var characters: [Character] = []
	private var subscriptions = Subscriptions()
	
	private let sqaudSubject = PassthroughSubject<[Character], Never>()
	private let charactersSubject = PassthroughSubject<[Character], Never>()
	private let errorSubject = PassthroughSubject<String?, Never>()
	
	private let service: CharacterServiceProtocol
	private let characterOpenPublisher: PassthroughSubject<Int, Never>
	
	init(service: CharacterServiceProtocol, characterOpenPublisher: PassthroughSubject<Int, Never>) {
		self.service = service
		self.characterOpenPublisher = characterOpenPublisher
		bind()
	}
}

extension ListViewModel: ListDataAndActions {
	var data: ListData {
		ListData(squad: sqaudSubject.eraseToAnyPublisher(),
				 characters: charactersSubject.eraseToAnyPublisher(), error: errorSubject.eraseToAnyPublisher())
	}
	
	var viewAction: ListActions {
		ListActions(lifecycle: lifecycle, viewEvents: viewEvents)
	}
}

private extension ListViewModel {
	
	func bind() {
		lifecycle.sink { [weak self] action in
			switch action {
			case .didLoad:
				self?.load()
				self?.service.fillSquad()
			}
		}.store(in: &subscriptions)
		
		service
			.squad
			.subscribe(sqaudSubject)
			.store(in: &subscriptions)
		
		viewEvents.sink { [weak self] event in
			switch event {
			case .lastCellWillAppear:
				self?.load()
			case let .didSelect(character):
				self?.characterOpenPublisher.send(character.id)
			case .reloadTapped:
				self?.load()
			}
		}.store(in: &subscriptions)
	}
	
	func load() {
		errorSubject.send(nil)
		service.fetchNext()?
			.sink { [weak self] state in
				guard let self = self else { return }
				
				switch state {
				case let .data(characters):
					self.charactersSubject.send(characters)
				case let .partialData(characters, _):
					// TODO: show toast error
					self.charactersSubject.send(characters)
				case .error:
					self.errorSubject.send("Error occured. Try again")
				}
			}.store(in: &subscriptions)
	}
}
