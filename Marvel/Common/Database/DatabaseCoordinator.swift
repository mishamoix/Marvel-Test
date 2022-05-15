//
//  DatabaseCoordinator.swift
//  Marvel
//
//  Created by mike on 14.05.2022.
//

import CoreData

protocol DatabaseCoordinatorProtocol: AnyObject {
	var readContext: NSManagedObjectContext? { get }
	var writeContext: NSManagedObjectContext? { get }
}

final class DatabaseCoordinator: DatabaseCoordinatorProtocol {
	
	private(set) var readContext: NSManagedObjectContext?
	private(set) var writeContext: NSManagedObjectContext?
	
	private let persistentContainer: NSPersistentContainer
	
	init(name: String, description: NSPersistentStoreDescription? = nil) {
		
		persistentContainer = NSPersistentContainer(name: name)
		
		if let description = description {
			persistentContainer.persistentStoreDescriptions = [description]
		}
		
		persistentContainer.loadPersistentStores { [weak self] _, error in
			if error != nil {
				fatalError("DB initialize \(String(describing: error))")
			}
			
			self?.finishInitialize()
		}
	}
}

private extension DatabaseCoordinator {
	func finishInitialize() {
		let writeContext = persistentContainer.newBackgroundContext()
		let readContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
		readContext.parent = writeContext
		readContext.automaticallyMergesChangesFromParent = true
		
		self.readContext = readContext
		self.writeContext = writeContext
	}
}
