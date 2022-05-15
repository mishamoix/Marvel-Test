//
//  DetailsDataAndActions.swift
//  Marvel
//
//  Created by mike on 15.05.2022.
//

import Foundation
import Combine

protocol DetailsDataAndActions {
	
	var data: DetailsData { get }
	
	var viewAction: DetailsActions { get }
}

struct DetailsData {
	let character: AnyPublisher<Squadable<Character>, Never>
}

struct DetailsActions {
	
	enum ViewEvents {
		case recruitTapped
	}
	
	let lifecycle: PassthroughSubject<LifecycleAction, Never>
	
	let viewEvents: PassthroughSubject<ViewEvents, Never>
}
