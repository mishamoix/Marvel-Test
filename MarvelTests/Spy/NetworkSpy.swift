//
//  NetworkSpy.swift
//  MarvelTests
//
//  Created by mike on 14.05.2022.
//

import Foundation
import Combine
@testable import Marvel

final class NetworkSpy: NetworkManagerProtocol {
	
	private(set) var host: String = ""
	private(set) var path: String = ""
	private(set) var params: [String: String] = [:]
	
	func get<T>(host: String,
				path: String,
				params: [String : String],
				model: T.Type) -> AnyPublisher<T, Error> where T : Decodable {
		self.host = host
		self.params = params
		self.path = path
		
		return Fail(outputType: T.self, failure: URLError(.badURL)).eraseToAnyPublisher()
	}
}
