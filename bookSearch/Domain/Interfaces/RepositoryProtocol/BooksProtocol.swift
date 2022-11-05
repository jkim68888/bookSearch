//
//  BooksProtocol.swift
//  bookSearch
//
//  Created by 김지현 on 2022/11/05.
//

import Foundation

protocol BooksProtocol {
	func fetchBooksList(query: BooksQuery, completion: @escaping (Result<Books, Error>) -> Void)
}
