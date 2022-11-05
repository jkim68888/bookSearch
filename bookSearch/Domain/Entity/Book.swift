//
//  Book.swift
//  bookSearch
//
//  Created by 김지현 on 2022/11/05.
//

import Foundation

struct BooksQuery {
	let query: String
	let start: Int
	let end: Int
}

struct Books {
	let totalCount: Int
	let books: [Book]
}

struct Book {
	let id: String
	let title: String
	let authors: [String]
	let publisher: String
	let publishedDate: String
	let description: String
	let smallThumbnail: URL?
	let thumbnail: URL?
	let pageCount: Int
	let categories: [String]
}
