//
//  TitleHeader.swift
//  Marvel
//
//  Created by mike on 14.05.2022.
//

import Foundation
import UIKit

final class TitleHeader: UICollectionReusableView {
	
	private let title: UILabel = {
		let view = UILabel()
		view.textColor = Colors.text
		view.font = Fonts.title3
		view.translatesAutoresizingMaskIntoConstraints = false
		view.numberOfLines = 1
		return view
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func update(title: String) {
		self.title.text = title
	}
}

private extension TitleHeader {
	func setup() {
		backgroundColor = .clear
		addSubview(title)
		
		NSLayoutConstraint.activate([
			title.topAnchor.constraint(equalTo: topAnchor),
			title.leadingAnchor.constraint(equalTo: leadingAnchor),
			title.trailingAnchor.constraint(equalTo: trailingAnchor),
			title.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}
}
