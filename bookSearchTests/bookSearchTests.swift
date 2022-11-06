//
//  bookSearchTests.swift
//  bookSearchTests
//
//  Created by 김지현 on 2022/11/04.
//

import XCTest
@testable import bookSearch

// MARK: - UseCase 테스트
final class bookSearchTests: XCTestCase {

	static let books: Books = {
		let book1 = Book(id: "test1",
						 title: "테스트 타이틀1",
						 authors: ["테스트작가1-1", "테스트작가1-2"],
						 publisher: "테스트출판사1",
						 publishedDate: "2022-11-06",
						 description: "테스트 설명",
						 smallThumbnail: URL(string: "https://books.google.com/books/content?id=H-eGDwAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api"),
						 thumbnail: URL(string: "https://books.google.com/books/content?id=BzstAQAAIAAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api"),
						 pageCount: 500, categories: ["테스트 카테고리1-1", "테스트 카테고리 1-2"])
		let book2 = Book(id: "test2",
						 title: "테스트 타이틀2",
						 authors: ["테스트작가2-1", "테스트작가2-2"],
						 publisher: "테스트출판사2",
						 publishedDate: "2022-11-07",
						 description: "테스트 설명2",
						 smallThumbnail: URL(string: "https://books.google.com/books/content?id=H-eGDwAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api"),
						 thumbnail: URL(string: "https://books.google.com/books/content?id=BzstAQAAIAAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api"),
						 pageCount: 600, categories: ["테스트 카테고리2-1", "테스트 카테고리 2-2"])
		let book3 = Book(id: "test3",
						 title: "테스트 타이틀3",
						 authors: ["테스트작가3-1"],
						 publisher: "테스트출판사3",
						 publishedDate: "2022-11-08",
						 description: "테스트 설명3",
						 smallThumbnail: URL(string: "https://books.google.com/books/content?id=H-eGDwAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api"),
						 thumbnail: URL(string: "https://books.google.com/books/content?id=BzstAQAAIAAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api"),
						 pageCount: 600, categories: ["테스트 카테고리3-1"])
		return Books.init(totalCount: 3, books: [book1, book2, book3])
	}()

	enum BooksRepositorySuccessTestError: Error {
		case failedFetching
	}
	
	struct BooksRepositoryMock: BooksProtocol {
		var result: Result<Books, Error>
		func fetchBooksList(query: BooksQuery, completion: @escaping (Result<Books, Error>) -> Void) {
			completion(result)
		}
	}
	
	// MARK: - Success Test
	func testSearchBooksUseCase_whenSuccessfullyFetchesBooksForQuery() {
		let useCase = SearchBooksUseCase(booksProtocol: BooksRepositoryMock(result: .success(bookSearchTests.books)))
	
		let requestValue = BooksQuery.init(query: "테스트 타이틀", start: 0, end: 40)
		var results: Books?
		useCase.execute(query: requestValue) { result in
			results = (try? result.get())
		}
		
		XCTAssertTrue(results != nil)
		XCTAssertTrue(results!.books.count <= 40)
		XCTAssertTrue(results!.books.filter({ $0.title.contains("테스트 타이틀")}).count > 0)
	}
	
	// MARK: - Failure Test
	func testSearchBooksUseCase_whenFailedFetchingBooksForQuery() {
		// given
		let useCase = SearchBooksUseCase(booksProtocol: BooksRepositoryMock(result: .failure(BooksRepositorySuccessTestError.failedFetching)))
		
		// when
		let requestValue = BooksQuery.init(query: "테스트 타이틀", start: 0, end: 500) // end를 40이상주면 API에서 Error를 줌
		var results: Books?
		useCase.execute(query: requestValue) { result in
			results = (try? result.get())
		}
		
		XCTAssertTrue(results == nil)
	}

}
