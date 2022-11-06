//
//  BookDetailViewModel.swift
//  bookSearch
//
//  Created by 김지현 on 2022/11/05.
//

import Foundation

protocol BookDetailViewModelInput {
}

protocol BookDetailViewModelOutput {
	var title: String { get }
	var book: Observable<Book?> { get }
}

protocol BookDetailViewModel: BookDetailViewModelInput, BookDetailViewModelOutput { }

final class DefaultBookDetailViewModel: BookDetailViewModel {
	// MARK: - OUTPUT
	var title: String
	let book: Observable<Book?> = Observable(nil)
	
	init(book: Book) {
		self.title = book.title
		self.book.value = book
	}
}
