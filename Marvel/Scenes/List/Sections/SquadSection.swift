//
//  SquadSection.swift
//  Marvel
//
//  Created by mike on 14.05.2022.
//

import Foundation
import UIKit

final class SquadSection: ListSection {
	
	var character: [Character] = []
	
	var layout: NSCollectionLayoutSection? {
		
		if character.isEmpty {
			return nil
		}
		
		let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(72),
																			 heightDimension: .absolute(116)))
		
		let grSize = NSCollectionLayoutSize(widthDimension: .estimated(72),
											heightDimension: .estimated(100))
		
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: grSize, subitem: item, count: 1)
		
		let section = NSCollectionLayoutSection(group: group)
		section.interGroupSpacing = Sizes.offset
		section.orthogonalScrollingBehavior = .continuous
		section.contentInsets = NSDirectionalEdgeInsets(top: Sizes.offset, leading: Sizes.offset,
														bottom: Sizes.offset, trailing: Sizes.offset)
		
		if !character.isEmpty {
			let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
			let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
																	 elementKind: "TitleHeader", alignment: .top)
			section.boundarySupplementaryItems = [header]
		}
		
		return section
	}
	
	var numberOfItems: Int {
		character.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SquadCell", for: indexPath)
		if let cell = cell as? SquadCell {
			cell.update(with: character[indexPath.item])
		}
		return cell
	}
	
	func register(collectionView: UICollectionView) {
		collectionView.register(SquadCell.self, forCellWithReuseIdentifier: "SquadCell")
		collectionView.register(TitleHeader.self,
								forSupplementaryViewOfKind: "TitleHeader",
								withReuseIdentifier: "TitleHeader")
	}
}
