//
//  DetailsViewController.swift
//  Marvel
//
//  Created by mike on 15.05.2022.
//

import Foundation
import UIKit
import Kingfisher

final class DetailsViewController: UIViewController {
	
	private var subscriptions = Subscriptions()
	private var character: Squadable<Character>?
	
	private let viewModel: DetailsDataAndActions
	
	private let scrollView: UIScrollView = {
		let view = UIScrollView()
		view.backgroundColor = Colors.background
		view.translatesAutoresizingMaskIntoConstraints = false
		view.contentInsetAdjustmentBehavior = .never
		view.alwaysBounceVertical = true
		return view
	}()
	
	private let stackView: UIStackView = {
		let view = UIStackView()
		view.axis = .vertical
		view.distribution = .equalSpacing
		view.spacing = Sizes.offset
		view.backgroundColor = Colors.background
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private let avatarView: UIImageView = {
		let view = UIImageView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private let mainTitle: UILabel = {
		let view = UILabel()
		view.numberOfLines = 0
		view.textColor = Colors.text
		view.font = Fonts.largeTitle
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private lazy var recruitButton: UIButton = {
		let view = UIButton()
		view.setTitleColor(Colors.text, for: .normal)
		view.titleLabel?.font = Fonts.headline
		view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.cornerRadius = Constants.buttonCorenrRadius
		view.layer.borderColor = Colors.redLight.cgColor
		view.layer.borderWidth = 3
		view.layer.shadowColor = Colors.redLight.cgColor
		view.layer.shadowRadius = 16
		view.layer.shadowOffset = CGSize(width: 0, height: 4)
		view.addTarget(self, action: #selector(recruitTapped), for: .touchUpInside)
		view.setTitleColor(UIColor.lightGray, for: .highlighted)
		return view
	}()
	
	private let body: UILabel = {
		let view = UILabel()
		view.numberOfLines = 0
		view.textColor = Colors.text
		view.font = Fonts.body
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private lazy var backButton: UIButton = {
		let view = UIButton()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.setImage(UIImage(named: "back"), for: .normal)
		view.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
		return view
	}()
	
	private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
	
	init(viewModel: DetailsDataAndActions) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setup()
		
		viewModel.viewAction.lifecycle.send(.didLoad)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.setNavigationBarHidden(true, animated: false)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		navigationController?.setNavigationBarHidden(false, animated: false)
	}
}

private extension DetailsViewController {
	
	enum Constants {
		static let buttonCorenrRadius: CGFloat = 8
		static let stackViewOffset: CGFloat = 24
		static let recruitButtonHeight: CGFloat = 48
	}
	
	func setup() {
		
		view.backgroundColor = Colors.background
		
		view.addSubview(scrollView)
		view.addSubview(backButton)
		scrollView.addSubview(avatarView)
		scrollView.addSubview(stackView)
		stackView.addArrangedSubview(mainTitle)
		stackView.addArrangedSubview(recruitButton)
		stackView.addArrangedSubview(body)
		
		NSLayoutConstraint.activate([
			scrollView.topAnchor.constraint(equalTo: view.topAnchor),
			scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
		
		NSLayoutConstraint.activate([
			avatarView.topAnchor.constraint(equalTo: scrollView.topAnchor),
			avatarView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
			avatarView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
			avatarView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
			avatarView.widthAnchor.constraint(equalTo: avatarView.heightAnchor),
			avatarView.widthAnchor.constraint(equalTo: view.widthAnchor)
		])
		
		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: Constants.stackViewOffset),
			stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Sizes.offset),
			stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -Sizes.offset),
			stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -Sizes.offset)
		])
		
		NSLayoutConstraint.activate([
			recruitButton.heightAnchor.constraint(equalToConstant: Constants.recruitButtonHeight)
		])
		
		setupStatusBar()
		
		NSLayoutConstraint.activate([
			backButton.topAnchor.constraint(equalTo: blurView.bottomAnchor, constant: 12),
			backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9)
		])
		
		bind()
	}
	
	func bind() {
		viewModel.data.character
			.receive(on: RunLoop.main)
			.sink { [weak self] character in
				self?.update(with: character)
			}
			.store(in: &subscriptions)
	}
	
	func update(with model: Squadable<Character>) {
		self.character = model
		mainTitle.text = model.model.name
		if let icon = model.model.icon {
			avatarView.kf.setImage(with: URL(string: icon), options: [.transition(.fade(1))])
		}
		body.text = model.model.about
		updateButton(isSquadMember: model.isSqaudMember)
	}
	
	func setupStatusBar() {
		blurView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(blurView)
		let statusBarHeight = UIApplication.shared
			.windows
			.first(where: { $0.isKeyWindow })?
			.windowScene?
			.statusBarManager?.statusBarFrame.height ?? 0
		
		NSLayoutConstraint.activate([
			blurView.topAnchor.constraint(equalTo: view.topAnchor),
			blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			blurView.heightAnchor.constraint(equalToConstant: statusBarHeight)
		])
	}
	
	func updateButton(isSquadMember: Bool) {
		let text: String
		let background: UIColor
		let shadowOpacity: Float
		
		if isSquadMember {
			text = "🔥  Fire from Squad"
			background = .clear
			shadowOpacity = 0
		} else {
			text = "💪  Recruit to Squad"
			background = Colors.redLight
			shadowOpacity = 0.5
			
		}
		
		recruitButton.backgroundColor = background
		recruitButton.setTitle(text, for: .normal)
		recruitButton.layer.shadowOpacity = shadowOpacity
	}
	
	@objc func backTapped() {
		navigationController?.popViewController(animated: true)
	}
	
	@objc func recruitTapped() {
		guard let character = character else { return }
		
		if character.isSqaudMember {
			let alert = UIAlertController(title: "Fire from squad", message: "Are you sure to fire '\(character.model.name)' from your squad?", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Fire", style: .destructive, handler: { [weak self] _ in
				self?.viewModel.viewAction.viewEvents.send(.recruitTapped)
			}))
			
			alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in }))
			
			present(alert, animated: true)
		} else {
			viewModel.viewAction.viewEvents.send(.recruitTapped)
		}
	}
}
