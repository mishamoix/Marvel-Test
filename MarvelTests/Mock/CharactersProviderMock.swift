//
//  CharactersProviderMock.swift
//  MarvelTests
//
//  Created by mike on 15.05.2022.
//

import Foundation
import Combine
@testable import Marvel

final class CharactersProviderMock: CharactersProvidable {
	
	var characters: [Character] = []
	var error: Error?
	
	func fetch(count: Int, offset: Int) -> AnyPublisher<[Character], Error> {
		if let error = error {
			return Fail(error: error).eraseToAnyPublisher()
		} else {
			return Just<[Character]>(characters).setFailureType(to: Error.self).eraseToAnyPublisher()
		}
	}
}
