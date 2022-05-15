//
//  SqaudProviderTests.swift
//  MarvelTests
//
//  Created by mike on 14.05.2022.
//

import Foundation
import XCTest
import CoreData
@testable import Marvel

final class SqaudProviderTests: XCTestCase {
	
	var db: DatabaseCoordinator {
		let persistentStoreDescription = NSPersistentStoreDescription()
		persistentStoreDescription.type = NSInMemoryStoreType
		
		let db = DatabaseCoordinator(name: "DB", description: persistentStoreDescription)
		return db
	}
	
	func createCharacter(id: Int) -> Character {
		return Character(id: id, name: String(id), icon: nil, about: nil)
	}
	
	func testGetFullSquad() {
		// Arrange
		let db = self.db
		guard let context = db.writeContext else { return }
		
		let pr = SquadProvider(db: db)
		CharacterDB.createOrUpdate(input: createCharacter(id: 1), context: context)
		CharacterDB.createOrUpdate(input: createCharacter(id: 2), context: context)
		
		// Act
		let members = pr.getFullSquad().sorted(by: { $0.id < $1.id })
		
		// assert
		XCTAssert(members.count == 2)
		XCTAssert(members[0].id == 1)
		XCTAssert(members[1].id == 2)
	}
	
	func testAdd() {
		// Arrange
		let db = self.db
		let pr = SquadProvider(db: db)
		
		// Act
		pr.add(createCharacter(id: 100))
		let members = pr.getFullSquad()
		
		// assert
		XCTAssert(members.count == 1)
		XCTAssert(members[0].id == 100)
	}
	
	func testUpdateData() {
		// Arrange
		let db = self.db
		let pr = SquadProvider(db: db)
		let expectation = XCTestExpectation()
		
		// Act
		pr.add(createCharacter(id: 100))
		let membersBefor = pr.getFullSquad()
		
		pr.updateData(with: [Character(id: 100, name: "abc", icon: nil, about: nil)]) {
			let membersAfter = pr.getFullSquad()
			
			// Assert
			XCTAssert(membersBefor.count == 1)
			XCTAssert(membersBefor[0].id == 100)
			XCTAssert(membersBefor[0].name == "100")
			
			XCTAssert(membersAfter.count == 1)
			XCTAssert(membersAfter[0].id == 100)
			XCTAssert(membersAfter[0].name == "abc")
			expectation.fulfill()
		}
		
		wait(for: [expectation], timeout: 1)
	}
}
