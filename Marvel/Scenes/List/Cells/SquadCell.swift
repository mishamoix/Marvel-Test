//
//  SquadCell.swift
//  Marvel
//
//  Created by mike on 14.05.2022.
//

import UIKit
import Kingfisher

final class SquadCell: UICollectionViewCell {
	
	private let title: UILabel = {
		let view = UILabel()
		view.textColor = Colors.text
		view.font = Fonts.caption
		view.numberOfLines = 2
		view.textAlignment = .center
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private let avatarView: UIImageView = {
		let view = UIImageView()
		view.contentMode = .scaleAspectFill
		view.layer.cornerRadius = Constants.iconSize / 2.0
		view.clipsToBounds = true
		view.translatesAutoresizingMaskIntoConstraints = false
		view.setContentCompressionResistancePriority(.required, for: .horizontal)
		view.setContentHuggingPriority(.required, for: .horizontal)
		return view
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setup()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func update(with character: Character) {
		title.text = character.name
		if let icon = character.icon {
			avatarView.kf.setImage(with: URL(string: icon), options: [.transition(.fade(1))])
		}
	}
}

private extension SquadCell {
	
	enum Constants {
		static let iconSize: CGFloat = 72
		static let offset: CGFloat = 8
	}
	
	func setup() {
		
		contentView.backgroundColor = .clear
		
		contentView.addSubview(title)
		contentView.addSubview(avatarView)
		
		NSLayoutConstraint.activate([
			avatarView.topAnchor.constraint(equalTo: contentView.topAnchor),
			avatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			avatarView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			avatarView.widthAnchor.constraint(equalToConstant: Constants.iconSize),
			avatarView.heightAnchor.constraint(equalToConstant: Constants.iconSize)
		])
		
		NSLayoutConstraint.activate([
			title.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: Constants.offset),
			title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		])
	}
}
