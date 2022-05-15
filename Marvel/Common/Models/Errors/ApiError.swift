//
//  ApiError.swift
//  Marvel
//
//  Created by mike on 14.05.2022.
//

import Foundation

struct ApiError: Decodable {
	let code: String
	let message: String
}
