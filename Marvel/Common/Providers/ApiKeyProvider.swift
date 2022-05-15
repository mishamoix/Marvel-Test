//
//  ApiKeyProvider.swift
//  Marvel
//
//  Created by mike on 11.05.2022.
//

import Foundation
import CryptoKit

protocol ApiKeyProvidable {
	func requestParams() -> [String: String]
}

final class ApiKeyProvider: ApiKeyProvidable {
	
	private let publicKey: String
	private let privateKey: String
	
	init(publicKey: String, privateKey: String) {
		self.publicKey = publicKey
		self.privateKey = privateKey
	}
	
	func requestParams() -> [String : String] {
		requestParams(with: Date())
	}
	
	
	func requestParams(with date: Date = Date()) -> [String: String] {
		let ts = String(Int(date.timeIntervalSince1970))
		let hash = makeHash(with: ts)
		
		return [
			"apikey": publicKey,
			"hash": hash,
			"ts": ts
		]
	}
	
	private func makeHash(with timestamp: String) -> String {
		let combinedString = timestamp + privateKey + publicKey
		
		let result = Insecure.MD5
			.hash(data: combinedString.data(using: .utf8) ?? Data())
			.map {String(format: "%02hhx", $0)}
			.joined()
		
		return result
	}
}
