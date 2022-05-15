//
//  ApiKeyProviderTests.swift
//  MarvelTests
//
//  Created by mike on 14.05.2022.
//

import Foundation
import XCTest
@testable import Marvel

final class ApiKeyProviderTests: XCTestCase {
	let sut = ApiKeyProvider(publicKey: "public", privateKey: "private")
	
	func testParams() {
		// Arrange
		let date = Date(timeIntervalSince1970: 1)
		
		// Act
		let params = sut.requestParams(with: date)
		
		// Assert
		XCTAssert(params["ts"] == "1")
		XCTAssert(params["hash"] == "302e425b2069b50ef7b51b4b8c214bde")
		XCTAssert(params["apikey"] == "public")
	}
}
