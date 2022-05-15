//
//  CharacterServiceTests.swift
//  MarvelTests
//
//  Created by mike on 15.05.2022.
//

import Foundation
import XCTest
@testable import Marvel

final class CharacterServiceTests: XCTestCase {
	
	func testFetch() {
		// arrange
		let charProvider = CharactersProviderMock()
		charProvider.characters = [Character(id: 1, name: "", icon: nil, about: nil)]
		let service = CharacterService(squadProvider: SquadProviderMock(),
									   characterProvider: charProvider)
		let expectation = XCTestExpectation()
		var sub = Subscriptions()
		
		// act
		service.fetchNext()?.sink(receiveValue: { result in
			// assert
			switch result {
			case let .data(characters):
				XCTAssert(characters.count == 1)
				XCTAssert(characters[0].id == 1)
			default:
				XCTFail()
			}
			expectation.fulfill()
		}).store(in: &sub)
		
		wait(for: [expectation], timeout: 1)
	}
	
	func testFetchError() {
		// arrange
		let charProvider = CharactersProviderMock()
		charProvider.error = URLError(.badURL)
		let service = CharacterService(squadProvider: SquadProviderMock(),
									   characterProvider: charProvider)
		let expectation = XCTestExpectation()
		var sub = Subscriptions()
		
		// act
		service.fetchNext()?.sink(receiveValue: { result in
			// assert
			switch result {
			case let .error(error):
				XCTAssert(error is URLError)
				XCTAssert((error as? URLError)?.code == .badURL)
			default:
				XCTFail()
			}
			expectation.fulfill()
		}).store(in: &sub)
		
		wait(for: [expectation], timeout: 1)
	}
	
	func testPartialFetch() {
		// arrange
		let charProvider = CharactersProviderMock()
		let service = CharacterService(squadProvider: SquadProviderMock(),
									   characterProvider: charProvider)
		let expectation = XCTestExpectation()
		var sub = Subscriptions()
		
		// act
		charProvider.characters = [Character(id: 1, name: "", icon: nil, about: nil)]
		service.fetchNext()?.sink(receiveValue: { _ in }).store(in: &sub)
		
		charProvider.error = URLError(.badURL)
		service.fetchNext()?.sink(receiveValue: { result in
			// assert
			switch result {
			case let .partialData(characters, error):
				XCTAssert(characters.count == 1)
				XCTAssert(characters[0].id == 1)
				XCTAssert(error is URLError)
				XCTAssert((error as? URLError)?.code == .badURL)
			default:
				XCTFail()
			}
			expectation.fulfill()
		}).store(in: &sub)
		
		wait(for: [expectation], timeout: 1)
	}
	
	func testFillSquad() {
		// arrange
		let squadProvider = SquadProviderMock()
		squadProvider.characters = [Character(id: 1, name: "", icon: nil, about: nil)]
		let service = CharacterService(squadProvider: squadProvider,
									   characterProvider: CharactersProviderMock())
		let expectation = XCTestExpectation()
		var sub = Subscriptions()
		
		// act
		service.fillSquad()
		
		service.squad
			.sink { characters in
				// assert
				XCTAssert(characters.count == 1)
				XCTAssert(characters[0].id == 1)
				
				expectation.fulfill()
			}.store(in: &sub)
		
		wait(for: [expectation], timeout: 1)
	}
	
	func testAddToSquad() {
		// arrange
		let squadProvider = SquadProviderMock()
		let charProvider = CharactersProviderMock()
		charProvider.characters = [Character(id: 1, name: "", icon: nil, about: nil)]
		
		let service = CharacterService(squadProvider: squadProvider,
									   characterProvider: charProvider)
		var sub = Subscriptions()
		
		// act
		service.fetchNext()?.sink(receiveValue: { _ in }).store(in: &sub)
		service.addToSquad(character: 1)
		
		// assert
		XCTAssert(squadProvider.addCalled)
	}
	
	func testRemoveFromSquad() {
		// arrange
		let squadProvider = SquadProviderMock()
		squadProvider.characters = [Character(id: 1, name: "", icon: nil, about: nil)]
		
		let service = CharacterService(squadProvider: squadProvider,
									   characterProvider: CharactersProviderMock())
		
		// act
		service.fillSquad()
		service.removeFromSquad(character: 1)
		
		// assert
		XCTAssert(squadProvider.removeCalled)
	}
	
	func testUpdateData() {
		// arrange
		let squadProvider = SquadProviderMock()
		let charProvider = CharactersProviderMock()
		squadProvider.characters = [Character(id: 1, name: "", icon: nil, about: nil)]
		charProvider.characters = [Character(id: 1, name: "", icon: nil, about: nil),
								   Character(id: 2, name: "", icon: nil, about: nil)]
		
		let service = CharacterService(squadProvider: squadProvider,
									   characterProvider: charProvider)
		var sub = Subscriptions()
		
		// act
		service.fillSquad()
		service.fetchNext()?.sink(receiveValue: { _ in }).store(in: &sub)
		
		// assert
		XCTAssert(squadProvider.dataUpdateCalled)
	}
}
