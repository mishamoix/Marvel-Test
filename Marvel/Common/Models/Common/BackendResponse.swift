//
//  BackendResponse.swift
//  Marvel
//
//  Created by mike on 14.05.2022.
//

import Foundation

struct BackendResponse<T: Decodable>: Decodable {
	
	struct Data<T: Decodable>: Decodable {
		let results: [T]
	}
	
	let data: Data<T>
}
