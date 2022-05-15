//
//  ListViewController.swift
//  Marvel
//
//  Created by mike on 11.05.2022.
//

import Foundation
import UIKit

final class ListViewController: UIViewController {
	
	private var subscriptions = Subscriptions()
	private let squadSection = SquadSection()
	private let characterSection = CharacterSection()
	
	private let viewModel: ListDataAndActions
	
	private let activityIndicator: UIActivityIndicatorView = {
		let view = UIActivityIndicatorView(style: .large)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.hidesWhenStopped = true
		return view
	}()
	
	private let errorTitle: UILabel = {
		let view = UILabel()
		view.font = Fonts.body
		view.textColor = Colors.text
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private lazy var reloadButton: UIButton = {
		let view = UIButton()
		view.setTitleColor(Colors.text, for: .normal)
		view.setTitle("Reload", for: .normal)
		view.titleLabel?.font = Fonts.headline
		view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.cornerRadius = 8
		view.backgroundColor = Colors.redLight
		view.contentEdgeInsets = UIEdgeInsets(top: 9, left: Sizes.offset, bottom: 9, right: Sizes.offset)
		view.addTarget(self, action: #selector(reloadTapped), for: .touchUpInside)
		return view
	}()
	
	private lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewCompositionalLayout { [weak self] index, _ in
			return self?.sections[index].layout
		}
		
		let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.delegate = self
		view.dataSource = self
		view.contentInset = UIEdgeInsets(top: Sizes.offset, left: 0,
										 bottom: Sizes.offset, right: 0)
		return view
	}()
	
	var sections: [ListSection] {
		return [squadSection, characterSection]
	}
	
	init(viewModel: ListDataAndActions) {
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
}

extension ListViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView,
						willDisplay cell: UICollectionViewCell,
						forItemAt indexPath: IndexPath) {
		
		let targetSection = sections.count - 1
		let targetItem = sections[targetSection].numberOfItems - 1
		if indexPath.section == sections.count - 1 && indexPath.item == targetItem {
			viewModel.viewAction.viewEvents.send(.lastCellWillAppear)
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let section = sections[indexPath.section]
		let character = section.character[indexPath.item]
		viewModel.viewAction.viewEvents.send(.didSelect(character))
	}
}

extension ListViewController: UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		if characterSection.character.isEmpty {
			return 0
		}
		return sections.count
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return sections[section].numberOfItems
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		return sections[indexPath.section].collectionView(collectionView, cellForItemAt: indexPath)
	}
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		if kind == "TitleHeader" {
			let view = collectionView.dequeueReusableSupplementaryView(ofKind: "TitleHeader", withReuseIdentifier: "TitleHeader", for: indexPath)
			
			if let view = view as? TitleHeader {
				view.update(title: "My Squad")
			}
			
			return view
		}
		
		return UICollectionReusableView()
	}
}

private extension ListViewController {
	func setup() {
		view.backgroundColor = Colors.background
		collectionView.backgroundColor = Colors.background
		
		view.addSubview(collectionView)
		view.addSubview(activityIndicator)
		view.addSubview(errorTitle)
		view.addSubview(reloadButton)
		
		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: view.topAnchor),
			collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
		
		NSLayoutConstraint.activate([
			activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		])
		
		NSLayoutConstraint.activate([
			errorTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -8),
			errorTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		])
		
		NSLayoutConstraint.activate([
			reloadButton.topAnchor.constraint(equalTo: errorTitle.bottomAnchor, constant: Sizes.offset),
			reloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		])
		
		sections.forEach({ $0.register(collectionView: collectionView) })
		navigationController?.navigationBar.barTintColor = Colors.background
		navigationItem.titleView = UIImageView(image: UIImage(named: "mainLogo"))
		bind()
		activityIndicator.startAnimating()
	}
	
	func bind() {
		viewModel.data.squad
			.receive(on: RunLoop.main)
			.sink { [weak self] characters in
				self?.squadSection.character = characters
				self?.collectionView.reloadData()
			}.store(in: &subscriptions)
		
		viewModel.data.characters
			.receive(on: RunLoop.main)
			.sink { [weak self] characters in
				self?.characterSection.character = characters
				self?.collectionView.reloadData()
				self?.activityIndicator.stopAnimating()
			}.store(in: &subscriptions)
		
		viewModel.data.error
			.receive(on: RunLoop.main)
			.sink { [weak self] error in
				let showError: Bool = error != nil
				self?.collectionView.isHidden = showError
				self?.reloadButton.isHidden = !showError
				self?.errorTitle.isHidden = !showError
				self?.errorTitle.text = error
				if showError {
					self?.activityIndicator.stopAnimating()
				}
			}.store(in: &subscriptions)
	}
	
	@objc func reloadTapped() {
		viewModel.viewAction.viewEvents.send(.reloadTapped)
		activityIndicator.startAnimating()
	}
}
