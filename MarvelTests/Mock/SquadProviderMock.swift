//
//  SquadProviderMock.swift
//  MarvelTests
//
//  Created by mike on 15.05.2022.
//

import Foundation
@testable import Marvel

final class SquadProviderMock: SquadProvidable {
	var characters: [Character] = []
	var addCalled = false
	var removeCalled = false
	var dataUpdateCalled = false
	
	func getFullSquad() -> [Character] {
		characters
	}
	
	func updateData(with characters: [Character], completion: (() -> Void)?) {
		dataUpdateCalled = true
	}
	
	func add(_ character: Character) {
		addCalled = true
	}
	
	func remove(_ character: Character) {
		removeCalled = true
	}
}
