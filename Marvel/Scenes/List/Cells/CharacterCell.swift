//
//  CharacterCell.swift
//  Marvel
//
//  Created by mike on 14.05.2022.
//

import UIKit
import Kingfisher

final class CharacterCell: UICollectionViewCell {
	
	private let title: UILabel = {
		let view = UILabel()
		view.textColor = Colors.text
		view.font = Fonts.headline
		view.translatesAutoresizingMaskIntoConstraints = false
		view.numberOfLines = 2
		return view
	}()
	
	private let avatarView: UIImageView = {
		let view = UIImageView()
		view.contentMode = .scaleAspectFill
		view.layer.cornerRadius = Constants.iconSize / 2.0
		view.clipsToBounds = true
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private let arrowView: UIImageView = {
		let view = UIImageView(image: UIImage(named: "arrow"))
		view.tintColor = Colors.text.withAlphaComponent(0.2)
		view.translatesAutoresizingMaskIntoConstraints = false
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

private extension CharacterCell {
	
	enum Constants {
		static let iconSize: CGFloat = 48
		static let cornerRadius: CGFloat = 8
	}
	
	func setup() {
		
		contentView.backgroundColor = Colors.greyMedium
		contentView.layer.cornerRadius = Constants.cornerRadius
		contentView.clipsToBounds = true
		
		contentView.addSubview(title)
		contentView.addSubview(avatarView)
		contentView.addSubview(arrowView)
		
		NSLayoutConstraint.activate([
			avatarView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Sizes.offset),
			avatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Sizes.offset),
			avatarView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Sizes.offset),
			avatarView.widthAnchor.constraint(equalToConstant: Constants.iconSize),
			avatarView.heightAnchor.constraint(equalToConstant: Constants.iconSize)
		])
		
		NSLayoutConstraint.activate([
			arrowView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			arrowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Sizes.offset),
			arrowView.widthAnchor.constraint(equalToConstant: 10),
			arrowView.heightAnchor.constraint(equalToConstant: 16),
		])
		
		NSLayoutConstraint.activate([
			title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			title.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: Sizes.offset),
			title.trailingAnchor.constraint(equalTo: arrowView.leadingAnchor, constant: -Sizes.offset)
		])
	}
}
