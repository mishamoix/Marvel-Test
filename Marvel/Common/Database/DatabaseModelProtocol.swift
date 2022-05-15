//
//  DatabaseModelProtocol.swift
//  Marvel
//
//  Created by mike on 14.05.2022.
//

import CoreData

protocol BasePredicatableInput {
	var basePredicate: NSPredicate { get }
}

protocol DatabaseModelProtocol {
	associatedtype Input: BasePredicatableInput
	
	@discardableResult
	static func createOrUpdate(input: Input, context: NSManagedObjectContext) -> Self
	
	func update(with model: Input)
}

extension DatabaseModelProtocol where Self: NSManagedObject {
	
	@discardableResult
	static func createOrUpdate(input: Input, context: NSManagedObjectContext) -> Self {
		let predicate = input.basePredicate
		
		let result = context.entry(entity: Self.self,
								   predicate: predicate) ?? Self(context: context)
		result.update(with: input)
		return result
	}
}
