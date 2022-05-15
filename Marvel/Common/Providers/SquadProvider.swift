//
//  SquadProvider.swift
//  Marvel
//
//  Created by mike on 14.05.2022.
//

import CoreData
import Foundation

protocol SquadProvidable {
	
	func getFullSquad() -> [Character]
	
	func updateData(with characters: [Character], completion: (() -> Void)?)
	
	func add(_ character: Character)
	
	func remove(_ character: Character)
}

final class SquadProvider: SquadProvidable {
	
	private let db: DatabaseCoordinatorProtocol
	
	private var readContext: NSManagedObjectContext {
		if let read = db.readContext {
			return read
		}
		
		fatalError("DB don't has read context")
	}
	
	private var writeContext: NSManagedObjectContext {
		if let write = db.writeContext {
			return write
		}
		
		fatalError("DB don't has write context")
	}
	
	init(db: DatabaseCoordinatorProtocol) {
		self.db = db
	}
	
	func getFullSquad() -> [Character] {
		let members = readContext.entries(entity: CharacterDB.self).map({ Character(db: $0) })
		return members
	}
	
	func updateData(with characters: [Character], completion: (() -> Void)?) {
		characters.forEach { char in
			let model = writeContext.entry(entity: CharacterDB.self, predicate: char.basePredicate)
			model?.update(with: char)
		}
		save(completion: completion)
	}
	
	func add(_ character: Character) {
		CharacterDB.createOrUpdate(input: character, context: self.writeContext)
		save()
	}
	
	func remove(_ character: Character) {
		self.writeContext.removeEntries(entity: CharacterDB.self, predicate: character.basePredicate)
		save()
	}
	
	private func save(completion: (() -> Void)? = nil) {
		writeContext.perform {
			try? self.writeContext.save()
			completion?()
		}
	}
}

private extension Character {
	init(db: CharacterDB) {
		self.id = db.id
		self.name = db.name
		self.icon = db.icon
		self.about = db.about
	}
}
