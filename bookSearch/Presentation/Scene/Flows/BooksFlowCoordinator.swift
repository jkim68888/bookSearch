//
//  BooksFlowCoordinator.swift
//  bookSearch
//
//  Created by 김지현 on 2022/11/06.
//

import UIKit

protocol BooksFlowCoordinatorDependencies  {
	func makeBookListViewController(actions: BooksListViewModelActions) -> BookListViewController
	func makeBookDetailsViewController(book: Book) -> UIViewController
}

final class BooksFlowCoordinator {
	private weak var navigationController: UINavigationController?
	private let dependencies: BooksFlowCoordinatorDependencies
	
	private weak var bookListVC: BookListViewController?
	
	init(navigationController: UINavigationController,
		 dependencies: BooksFlowCoordinatorDependencies) {
		self.navigationController = navigationController
		self.dependencies = dependencies
	}
	
	func start() {
		let actions = BooksListViewModelActions(showBookDetails: showBookDetails)
		let vc = dependencies.makeBookListViewController(actions: actions)
		
		navigationController?.pushViewController(vc, animated: false)
		bookListVC = vc
	}
	
	private func showBookDetails(book: Book) {
		let vc = dependencies.makeBookDetailsViewController(book: book)
		navigationController?.pushViewController(vc, animated: true)
	}
}
