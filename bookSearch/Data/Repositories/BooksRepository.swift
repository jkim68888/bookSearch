//
//  BooksRepository.swift
//  bookSearch
//
//  Created by 김지현 on 2022/11/05.
//

import Foundation

final class BooksRpository {
	private let dataTransferService: DataTransferService
	
	init(dataTransferService: DataTransferService) {
		self.dataTransferService = dataTransferService
	}
}

extension BooksRpository: BooksProtocol {
	func fetchBooksList(query: BooksQuery, completion: @escaping (Result<Books, Error>) -> Void) {
		let requestDTO = BooksRequestDTO(q: query.query, start: query.start, maxResults: query.end)
		let endpoint = APIEndpoint.getBooks(with: requestDTO)
		
		self.dataTransferService.request(with: endpoint) { result in
			switch result {
			case .success(let reponseDTO):
				completion(.success(reponseDTO.toDomain()))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
}
