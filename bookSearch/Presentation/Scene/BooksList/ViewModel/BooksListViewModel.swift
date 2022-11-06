//
//  BookListViewModel.swift
//  bookSearch
//
//  Created by 김지현 on 2022/11/05.
//

import Foundation

struct BooksListViewModelActions {
	let showBookDetails: (Book) -> Void
}

protocol BooksListViewModelInput {
	func viewDidLoad()
	func didLoadNextPage()
	func didSearch(searchText: String)
	func didSelectItem(at index: Int)
}

protocol BooksListViewModelOutput {
	var items: Observable<[BookListItemViewModel]> { get }
	var query: Observable<String> { get }
	var error: Observable<String> { get }
	var isEmpty: Bool { get }
	var errorTitle: String { get }
}

protocol BooksListProtocol: BooksListViewModelInput, BooksListViewModelOutput {}

final class BooksListViewModel: BooksListProtocol {
	private let searchBooksProtocol: SearchBooksProtocol
	private let actions: BooksListViewModelActions?
	
	var isLoading = false
	var loadBooksCount = 10
	var currentPage: Int = 0
	var totalPageCount: Int = 1
	var hasMorePages: Bool { currentPage * loadBooksCount < totalPageCount }
	var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }
	
	private var books: [Book] = []
	
	// MARK: - OUTPUT
	let items: Observable<[BookListItemViewModel]> = Observable([])
	let query: Observable<String> = Observable("")
	let error: Observable<String> = Observable("")
	var isEmpty: Bool { return items.value.isEmpty }
	let errorTitle = NSLocalizedString("Error", comment: "")
	
	// MARK: - Init
	init(searchBooksProtocol: SearchBooksProtocol,
		 actions: BooksListViewModelActions? = nil) {
		self.searchBooksProtocol = searchBooksProtocol
		self.actions = actions
	}
	
	// MARK: - Private
	private func appendPage(_ books: Books) {
		currentPage += 1
		totalPageCount = books.totalCount
		
		self.books += books.books
		items.value = books.books.map{ BookListItemViewModel.init(book: $0)}
	}
	
	private func resetPages() {
		currentPage = 0
		totalPageCount = 1
		books.removeAll()
		items.value.removeAll()
	}
	
	private func load(query: BooksQuery) {
		isLoading = true
		self.query.value = query.query
		
		searchBooksProtocol.execute(query: query, completion: { result in
			switch result {
			case .success(let page):
				self.isLoading = false
				self.appendPage(page)
			case .failure(let error):
				self.isLoading = false
				self.handle(error: error)
			}
		})
	}
	
	private func handle(error: Error) {
		self.error.value = error.localizedDescription
	}
}

// MARK: - INPUT. View event methods
extension BooksListViewModel {
	func viewDidLoad() { }
	
	func didLoadNextPage() {
		guard hasMorePages, !isLoading, query.value != "" else { return }
		
		// api에서 40페이지까지만 지원함
		if currentPage == 4 {
			self.error.value = "마지막 검색 결과입니다."
		} else {
			load(query: .init(query: query.value,
							  start: currentPage,
							  end: (currentPage + 1) * loadBooksCount ))
		}
	}
	
	func didSearch(searchText: String) {
		resetPages()
		load(query: BooksQuery.init(query: searchText,
									start: currentPage * loadBooksCount,
									end: (currentPage + 1) * loadBooksCount))
	}
	
	func didSelectItem(at index: Int) {
		actions?.showBookDetails(books[index])
	}
}
