//
//  DetailsViewModel.swift
//  Marvel
//
//  Created by mike on 15.05.2022.
//

import Foundation
import Combine

final class DetailsViewModel {
	
	private var subscriptions = Set<AnyCancellable>()
	private let lifecycle = PassthroughSubject<LifecycleAction, Never>()
	private let viewEvents = PassthroughSubject<DetailsActions.ViewEvents, Never>()
	private let characterSubject = PassthroughSubject<Squadable<Character>, Never>()
	
	private let servcie: CharacterServiceProtocol
	private let characterId: Int
	private var character: Squadable<Character>?
	
	init(service: CharacterServiceProtocol, characterId: Int) {
		self.servcie = service
		self.characterId = characterId
		
		bind()
	}
}

extension DetailsViewModel: DetailsDataAndActions {
	var data: DetailsData {
		DetailsData(character: characterSubject.eraseToAnyPublisher())
	}
	
	var viewAction: DetailsActions {
		DetailsActions(lifecycle: lifecycle, viewEvents: viewEvents)
	}
}

private extension DetailsViewModel {
	func bind() {
		lifecycle
			.sink { [weak self] action in
				switch action {
				case .didLoad:
					self?.reload()
				}
			}
			.store(in: &subscriptions)
		
		viewEvents
			.sink { [weak self] event in
				switch event {
				case .recruitTapped:
					self?.changeSquadMembership()
				}
			}
			.store(in: &subscriptions)
	}
	
	func reload() {
		if let character = servcie.getCharacter(by: characterId) {
			self.character = character
			characterSubject.send(character)
		} else {
			// TODO: show error
		}
	}
	
	func changeSquadMembership() {
		guard let character = character else { return }
		
		if character.isSqaudMember {
			servcie.removeFromSquad(character: characterId)
		} else {
			servcie.addToSquad(character: characterId)
		}
		
		reload()
	}
}
