//
//  Section.swift
//  Marvel
//
//  Created by mike on 14.05.2022.
//

import UIKit

protocol Section {
	var numberOfItems: Int { get }
	
	var layout: NSCollectionLayoutSection? { get }
	
	func collectionView(_ collectionView: UICollectionView,
						cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
	
	func register(collectionView: UICollectionView)
	
}
