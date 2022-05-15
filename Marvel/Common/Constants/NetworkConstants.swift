//
//  NetworkConstants.swift
//  Marvel
//
//  Created by mike on 11.05.2022.
//

import Foundation

enum NetworkConstants {
	static let publicKey = "041dadbf47b0eb866ebd8ca0090186f7"
	static let privateKey = "90454de2f526d0de50beb1e43c94d8ef5b823bbd"
	
	static let host = "gateway.marvel.com"
	
	static let v1 = "/v1/public"
	static let characters = "characters"
	
	static func path(_ components: String...) -> String {
		return components.joined(separator: "/")
	}
}
