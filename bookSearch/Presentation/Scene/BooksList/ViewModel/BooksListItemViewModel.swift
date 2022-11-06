//
//  BooksListItemViewModel.swift
//  bookSearch
//
//  Created by 김지현 on 2022/11/06.
//

import Foundation

struct BookListItemViewModel: Equatable {
	let id: String
	let title: String
	let authors: [String]
	let publisher: String
	let publishedDate: String
	let description: String
	var smallThumbnail: URL?
}

extension BookListItemViewModel {
	init(book: Book) {
		self.id = book.id
		self.title = book.title
		self.authors = book.authors
		self.publisher = book.publisher
		self.publishedDate = book.publishedDate
		self.description = book.description
		self.smallThumbnail = book.smallThumbnail
	}
}
