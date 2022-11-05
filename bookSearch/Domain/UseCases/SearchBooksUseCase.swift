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

final class SearchMoviesUseCase: SearchBooksProtocol {
	private let booksRepository: BooksRpository
	
	init(booksRepository: BooksRpository) {
		self.booksRepository = booksRepository
	}
	
	func execute(query: BooksQuery, completion: @escaping (Result<Books, Error>) -> Void) {
		return booksRepository.fetchBooksList(query: query) { result in
			completion(result)
		}
	}
}
