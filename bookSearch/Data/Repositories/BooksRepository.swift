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
	func fetchBooksList(query: String, completion: @escaping (Result<Books, Error>) -> Void) {
		let requestDTO = BooksRequestDTO(q: query, key: "AIzaSyBmFqIp25HsSjufYl5fKKf_9vFT2vkREP8")
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
