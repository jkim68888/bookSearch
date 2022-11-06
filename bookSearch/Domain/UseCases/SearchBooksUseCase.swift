//
//  SearchBooksUseCase.swift
//  bookSearch
//
//  Created by 김지현 on 2022/11/05.
//

import Foundation

protocol SearchBooksProtocol {
	func execute(query: BooksQuery, completion: @escaping (Result<Books, Error>) -> Void)
}

final class SearchBooksUseCase: SearchBooksProtocol {
	private let booksProtocol: BooksProtocol
	
	init(booksProtocol: BooksProtocol) {
		self.booksProtocol = booksProtocol
	}
	
	func execute(query: BooksQuery, completion: @escaping (Result<Books, Error>) -> Void) {
		return booksProtocol.fetchBooksList(query: query) { result in
			completion(result)
		}
	}
}
