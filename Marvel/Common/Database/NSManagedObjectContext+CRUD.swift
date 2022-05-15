//
//  NSManagedObjectContext+CRUD.swift
//  Marvel
//
//  Created by mike on 14.05.2022.
//

import CoreData

extension NSManagedObjectContext {
	
	func entry<T: NSManagedObject>(entity: T.Type = T.self, predicate: NSPredicate? = nil) -> T? {
		entries(entity: entity, predicate: predicate).first
	}
	
	func entries<T: NSManagedObject>(entity: T.Type = T.self,
									 predicate: NSPredicate? = nil,
									 sort: NSSortDescriptor? = nil) -> [T] {
		let request = NSFetchRequest<T>()
		request.entity = self.entity(entity.self)
		request.predicate = predicate
		if let sort = sort {
			request.sortDescriptors = [sort]
		}
		
		do {
			return try fetch(request)
		} catch {
			fatalError("Fetch objects fail for \(entity): \(error)")
		}
	}
	
	func removeEntries(entity: AnyClass, predicate: NSPredicate? = nil) {
		let request = NSFetchRequest<NSFetchRequestResult>()
		request.entity = self.entity(entity.self)
		request.predicate = predicate
		
		let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
		
		do {
			_ = try execute(deleteRequest)
		} catch {
			fatalError("Delete objects fail for \(entity): \(error)")
		}
	}
	
	func remove<T: NSManagedObject>(entity: T) {
		delete(entity)
	}
	
	func entity(_ objectClass: AnyClass) -> NSEntityDescription {
		guard
			let result = NSEntityDescription.entity(forEntityName: String(describing: objectClass), in: self)
		else {
			fatalError("Can't create entity for \(String(describing: objectClass))")
		}
		
		return result
	}
}
