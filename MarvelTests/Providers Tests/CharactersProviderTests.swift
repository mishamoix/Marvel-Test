//
//  CharactersProviderTests.swift
//  MarvelTests
//
//  Created by mike on 14.05.2022.
//

import Foundation
import XCTest
@testable import Marvel

final class CharactersProviderTests: XCTestCase {
	func testPath() {
		// Arrange
		let spy = NetworkSpy()
		let sut = CharactersProvider(keyProvider: ApiKeyProvider(publicKey: "public", privateKey: "private"),
									 network: spy)
		
		// Act
		sut.fetch(count: 0, offset: 0)
		
		// Assert
		XCTAssert(spy.path == "/v1/public/characters")
	}
	
	func testParams() {
		// Arrange
		let spy = NetworkSpy()
		let sut = CharactersProvider(keyProvider: ApiKeyProvider(publicKey: "public", privateKey: "private"),
									 network: spy)
		
		// Act
		sut.fetch(count: 10, offset: 20)
		
		// Assert
		XCTAssert(spy.params["limit"] == "10")
		XCTAssert(spy.params["offset"] == "20")
	}
}
