//
//  CharacterSection.swift
//  Marvel
//
//  Created by mike on 14.05.2022.
//

import Foundation
import UIKit

final class CharacterSection: ListSection {
	var character: [Character] = []
	
	var layout: NSCollectionLayoutSection? {
		
		let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
																			 heightDimension: .estimated(100)))
		item.contentInsets = NSDirectionalEdgeInsets(top: 0,
													 leading: Sizes.offset,
													 bottom: Sizes.offset,
													 trailing: Sizes.offset)
		
		let grSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
											heightDimension: .estimated(100))
		let group = NSCollectionLayoutGroup.vertical(layoutSize: grSize,
													 subitem: item, count: 1)
		let section = NSCollectionLayoutSection(group: group)
		return section
	}
	
	var numberOfItems: Int {
		character.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCell", for: indexPath)
		if let cell = cell as? CharacterCell {
			cell.update(with: character[indexPath.item])
		}
		return cell
	}
	
	func register(collectionView: UICollectionView) {
		collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: "CharacterCell")
	}
}
