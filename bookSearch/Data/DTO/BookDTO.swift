//
//  BookDTO.swift
//  bookSearch
//
//  Created by 김지현 on 2022/11/05.
//

import Foundation

// DTO - Data Transfer Object
// 뷰모델에서 사용할 데이터 형태의 오브젝트

// MARK: - Request
struct BooksRequestDTO: Encodable {
	let q: String
	let start: Int // books 시작 index
	let maxResults: Int // books end index
}

// MARK: - Response
struct BooksResponseDTO: Decodable {
	let totalItems: Int
	let items: [BookDTO]
	
	private enum CodingKeys: String, CodingKey {
		case totalItems
		case items
	}
}

struct BookDTO: Decodable {
	let id: String
	let volumeInfo: VolumeDTO
	
	private enum CodingKeys: String, CodingKey {
		case id
		case volumeInfo
	}
}

struct VolumeDTO: Decodable {
	let title: String
	let authors: [String]?
	let publisher: String?
	let publishedDate: String?
	let description: String?
	let imageLinks: ImageLinkDTO?
	let pageCount: Int?
	let categories: [String]?
	
	private enum CodingKeys: String, CodingKey {
		case title
		case authors
		case publisher
		case publishedDate
		case description
		case imageLinks
		case pageCount
		case categories
	}
}

struct ImageLinkDTO: Decodable {
	let smallThumbnail: String
	let thumbnail: String
	
	private enum CodingKeys: String, CodingKey {
		case smallThumbnail
		case thumbnail
	}
}

// MARK: - Mappings to Domain
// 도메인의 Entity 데이터와 매핑을 해준다.

extension BooksResponseDTO {
	func toDomain() -> Books {
		return .init(totalCount: totalItems, books: items.map{ $0.toDomain() })
	}
}

extension BookDTO {
	func toDomain() -> Book {
		return .init(id: id,
					 title: volumeInfo.title,
					 authors: volumeInfo.authors ?? ["저자 없음"],
					 publisher: volumeInfo.publisher ?? "출판사 없음",
					 publishedDate: volumeInfo.publishedDate ?? "출판일 없음",
					 description: volumeInfo.description ?? "설명 없음",
					 smallThumbnail: URL(string: volumeInfo.imageLinks?.smallThumbnail.replacingOccurrences(of: "http", with: "https") ?? ""),
					 thumbnail: URL(string: volumeInfo.imageLinks?.thumbnail.replacingOccurrences(of: "http", with: "https") ?? ""),
					 pageCount: volumeInfo.pageCount ?? 0,
					 categories: volumeInfo.categories ?? ["카테고리 없음"])
	}
}

