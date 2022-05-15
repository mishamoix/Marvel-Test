//
//  NetworkManager.swift
//  Marvel
//
//  Created by mike on 14.05.2022.
//

import Foundation
import Combine

protocol NetworkManagerProtocol {
	@discardableResult
	func get<T: Decodable>(host: String,
						   path: String,
						   params: [String: String],
						   model: T.Type) -> AnyPublisher<T, Error>
}

final class NetworkManager: NetworkManagerProtocol {
	private let session: URLSession = {
		let config = URLSessionConfiguration.default
		config.requestCachePolicy = .reloadIgnoringCacheData
		let session = URLSession(configuration: config)
		return session
	}()
	
	@discardableResult
	func get<T: Decodable>(host: String,
						   path: String,
						   params: [String: String],
						   model: T.Type) -> AnyPublisher<T, Error> {
		
		var components = URLComponents()
		components.host = host
		components.path = path
		components.scheme = "https"
		components.queryItems = params.map({ URLQueryItem(name: $0.key, value: $0.value) })
		
		guard let url = components.url else {
			return Fail<T, Error>(error: MarvelError.failedRequestBuild).eraseToAnyPublisher()
		}
		
		let urlRequest = URLRequest(url: url)
		
		return session
			.dataTaskPublisher(for: urlRequest)
			.tryMap { (data, response) in
				
				if let apiError = try? JSONDecoder().decode(ApiError.self, from: data) {
					throw MarvelError.api(apiError)
				}
				
				if let httpResponse = response as? HTTPURLResponse,
				   !(200..<299).contains(httpResponse.statusCode) {
					throw URLError(.badServerResponse)
				}
				
				let decodedModel = try JSONDecoder().decode(model, from: data)
				return decodedModel
			}
			.eraseToAnyPublisher()
	}
}
