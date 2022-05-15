//
//  CharactersProvider.swift
//  Marvel
//
//  Created by mike on 14.05.2022.
//

import Foundation
import Combine

protocol CharactersProvidable {
	func fetch(count: Int, offset: Int) -> AnyPublisher<[Character], Error>
}

final class CharactersProvider: CharactersProvidable {
	
	private let keyProvider: ApiKeyProvidable
	private let network: NetworkManagerProtocol
	
	init(keyProvider: ApiKeyProvidable, network: NetworkManagerProtocol) {
		self.keyProvider = keyProvider
		self.network = network
	}
	
	func fetch(count: Int, offset: Int) -> AnyPublisher<[Character], Error> {
		var params: [String: String] = keyProvider.requestParams()
		params["limit"] = String(count)
		params["offset"] = String(offset)
		
		let path = NetworkConstants.path(NetworkConstants.v1, NetworkConstants.characters)
		
		return network.get(host: NetworkConstants.host,
						   path: path,
						   params: params,
						   model: BackendResponse<Character>.self)
		.map { response in
			return response.data.results
		}
		.eraseToAnyPublisher()
	}
}
