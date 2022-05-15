//
//  CharacterDB.swift
//  Marvel
//
//  Created by mike on 14.05.2022.
//

import CoreData

@objc(CharacterDB)
final class CharacterDB: NSManagedObject {
	@NSManaged public var id: Int
	@NSManaged public var name: String
	@NSManaged public var icon: String?
	@NSManaged public var about: String?
}

extension CharacterDB: DatabaseModelProtocol {
	typealias Input = Character
	
	func update(with model: Input) {
		id = model.id
		name = model.name
		icon = model.icon
		about = model.about
	}
}

extension Character: BasePredicatableInput {
	var basePredicate: NSPredicate {
		NSPredicate(format: "id = \(self.id)")
	}
}
