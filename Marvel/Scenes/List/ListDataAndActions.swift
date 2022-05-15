//
//  ListDataAndActions.swift
//  Marvel
//
//  Created by mike on 11.05.2022.
//

import Foundation
import Combine

protocol ListDataAndActions {
	
	var data: ListData { get }
	
	var viewAction: ListActions { get }
}

struct ListData {
	let squad: AnyPublisher<[Character], Never>
	let characters: AnyPublisher<[Character], Never>
	let error: AnyPublisher<String?, Never>
}

struct ListActions {
	
	enum ViewEvents {
		case lastCellWillAppear
		case didSelect(Character)
		case reloadTapped
	}
	
	let lifecycle: PassthroughSubject<LifecycleAction, Never>
	
	let viewEvents: PassthroughSubject<ViewEvents, Never>
}
