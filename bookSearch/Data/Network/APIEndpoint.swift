//
//  APIEndpoints.swift
//  bookSearch
//
//  Created by 김지현 on 2022/11/05.
//

import Foundation

struct APIEndpoint {
	static func getBooks(with booksRequestDTO: BooksRequestDTO) -> Endpoint<BooksResponseDTO> {
		
		return Endpoint(path: "books/v1/volumes?q=\(booksRequestDTO.q):keyes&key=\(booksRequestDTO.key)",
						method: .get,
						queryParametersEncodable: booksRequestDTO)
	}
}
