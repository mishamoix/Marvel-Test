//
//  Character.swift
//  Marvel
//
//  Created by mike on 14.05.2022.
//

import Foundation

struct Character: Decodable, Hashable {
	
	struct Icon: Decodable {
		private let path: String
		private let `extension`: String
		
		var full: String {
			return path + "." + `extension`
		}
	}
	
	private enum CodingKeys: String, CodingKey {
		case id
		case name
		case about = "description"
		case icon = "thumbnail"
	}
	
	let id: Int
	let name: String
	let icon: String?
	let about: String?
	
	init(id: Int, name: String, icon: String?, about: String?) {
		self.id = id
		self.name = name
		self.icon = icon
		self.about = about
	}
		
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		self.id = try container.decode(Int.self, forKey: .id)
		self.name = try container.decode(String.self, forKey: .name)
		if let icon = try? container.decode(Icon.self, forKey: .icon) {
			self.icon = icon.full
		} else {
			icon = nil
		}
		self.about = try? container.decode(String.self, forKey: .about)
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
	
	static func == (lhs: Self, rhs: Self) -> Bool {
		return lhs.id == rhs.id
	}
}
