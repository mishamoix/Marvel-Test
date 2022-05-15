//
//  CharacterService.swift
//  Marvel
//
//  Created by mike on 14.05.2022.
//

import Foundation
import Combine

enum CharacterListResult {
	case error(Error)
	case data([Character])
	case partialData([Character], Error)
}

protocol CharacterServiceProtocol {
	
	var squad: AnyPublisher<[Character], Never> { get }
	
	func fetchNext() -> AnyPublisher<CharacterListResult, Never>?
	
	func getCharacter(by id: Int) -> Squadable<Character>?
	
	func fillSquad()
	
	func removeFromSquad(character id: Int)
	
	func addToSquad(character id: Int)
}

final class CharacterService {
	
	private enum State {
		case ready
		case loading
		case allDataLoaded
		case error
		
		var canLoad: Bool {
			self == .ready || self == .error
		}
	}
	
	private var state: State = .ready
	
	private var cachedCharacters: [Character] = []
	private var cachedSquad = Set<Character>()
	private var subscriptions = Subscriptions()
	
	private let squadSubject = CurrentValueSubject<[Character], Never>([])
	private let squadProvider: SquadProvidable
	private let characterProvider: CharactersProvidable
	
	
	init(squadProvider: SquadProvidable, characterProvider: CharactersProvidable) {
		self.squadProvider = squadProvider
		self.characterProvider = characterProvider
	}
}

extension CharacterService: CharacterServiceProtocol {
	var squad: AnyPublisher<[Character], Never> {
		squadSubject.eraseToAnyPublisher()
	}
	
	func fetchNext() -> AnyPublisher<CharacterListResult, Never>? {
		guard state.canLoad else { return nil }
		
		state = .loading
		
		return characterProvider
			.fetch(count: Constants.count, offset: cachedCharacters.count)
			.map { [weak self] charactres -> CharacterListResult in
				
				if charactres.isEmpty {
					self?.state = .allDataLoaded
				} else {
					self?.state = .ready
				}
				
				self?.cachedCharacters += charactres
				self?.updateSquadMemeberIfNeeded(charactres)
				return CharacterListResult.data(self?.cachedCharacters ?? [])
			}
			.catch { [weak self] error -> Just<CharacterListResult> in
				self?.state = .error
				
				if let characters = self?.cachedCharacters, !characters.isEmpty {
					return Just<CharacterListResult>(.partialData(characters, error))
				} else {
					return Just<CharacterListResult>(.error(error))
				}
			}
			.eraseToAnyPublisher()
		
	}
	
	func getCharacter(by id: Int) -> Squadable<Character>? {
		guard let character = cachedCharacters.first(where: { $0.id == id })
				?? cachedSquad.first(where: { $0.id == id }) else { return nil }
		return Squadable(isSqaudMember: cachedSquad.contains(character), model: character)
	}
	
	func fillSquad() {
		let allSquad = squadProvider.getFullSquad()
		allSquad.forEach({ cachedSquad.insert($0) })
		sendSquad()
	}
	
	func removeFromSquad(character id: Int) {
		if let character = cachedSquad.first(where: { $0.id == id }) {
			cachedSquad.remove(character)
			squadProvider.remove(character)
			sendSquad()
		}
		
	}
	
	func addToSquad(character id: Int) {
		if let character = cachedCharacters.first(where: { $0.id == id }) {
			cachedSquad.insert(character)
			squadProvider.add(character)
			sendSquad()
		}
	}
}

private extension CharacterService {
	
	private enum Constants {
		static let count = 100
	}
	
	func sorted(_ characters: [Character]) -> [Character] {
		characters.sorted(by: { $0.name < $1.name })
	}
	
	func sendSquad() {
		let members = sorted(Array(cachedSquad))
		squadSubject.send(members)
	}
	
	func updateSquadMemeberIfNeeded(_ new: [Character]) {
		let allSquadCharacters = new.filter({ cachedSquad.contains($0) })
		if !allSquadCharacters.isEmpty {
			squadProvider.updateData(with: allSquadCharacters) { [weak self] in
				self?.fillSquad()
			}
		}
	}
}
