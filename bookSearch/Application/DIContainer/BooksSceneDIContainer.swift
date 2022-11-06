//
//  BooksSceneDIContainer.swift
//  bookSearch
//
//  Created by 김지현 on 2022/11/06.
//

import Foundation
import UIKit

final class BooksSceneDIContainer: BooksFlowCoordinatorDependencies {
	struct Dependencies {
		let apiDataTransferService: DataTransferService
	}
	
	private let dependencies: Dependencies
	
	init(dependencies: Dependencies) {
		self.dependencies = dependencies
	}
	
	// MARK: - Use Cases
	func makeSearchBooksUseCase() -> SearchBooksProtocol {
		return SearchBooksUseCase(booksProtocol: makeBooksRepository())
	}
	
	// MARK: - Repositories
	func makeBooksRepository() -> BooksProtocol {
		return BooksRpository(dataTransferService: dependencies.apiDataTransferService)
	}
	
	// MARK: - Books List
	func makeBookListViewController(actions: BooksListViewModelActions) -> BookListViewController {
		return BookListViewController.create(with: makeBooksListViewModel(actions: actions) as! BooksListViewModel)
	}
	
	func makeBooksListViewModel(actions: BooksListViewModelActions) -> BooksListProtocol {
		return BooksListViewModel(searchBooksProtocol: makeSearchBooksUseCase(),
										actions: actions)
	}
	
	// MARK: - Book Details
	func makeBookDetailsViewController(book: Book) -> UIViewController {
		return BookDetailViewController.create(with: makeBooksDetailsViewModel(book: book))
	}
	
	func makeBooksDetailsViewModel(book: Book) -> BookDetailViewModel {
		return DefaultBookDetailViewModel(book: book)
	}
	
	// MARK: - Flow Coordinators
	func makeBookListFlowCoordinator(navigationController: UINavigationController) -> BooksFlowCoordinator {
		return BooksFlowCoordinator(navigationController: navigationController,
									dependencies: self)
	}
}
