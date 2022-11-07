//
//  bookSearchUITests.swift
//  bookSearchUITests
//
//  Created by 김지현 on 2022/11/04.
//

import XCTest

final class bookSearchUITests: XCTestCase {

	override func setUp() {
		continueAfterFailure = false
		XCUIApplication().launch()
	}
	
	// ⭐️시뮬레이터의 키보드 활성화 후에 테스트 진행해주세요! (cmd + shift + k)⭐️
	// NOTE: for UI tests to work the keyboard of simulator must be on.
	// Keyboard shortcut COMMAND + SHIFT + K while simulator has focus
	func testOpenBookDetails_whenSearchBatmanAndTapOnFirstResultRow_thenBookDetailsViewOpensWithTitleBatman() {
		let app = XCUIApplication()
		
		// Search for "Batman Begins"
		let searchText = "Batman Begins"
		app.textFields["bookSearchAccessIdentifier"].tap()
		
		if !(app.keyboards.keys["a"].waitForExistence(timeout: 2) || app.keyboards.keys["ㄱ"].waitForExistence(timeout: 2)) {
			XCTFail("The keyboard could not be found. Use keyboard shortcut COMMAND + SHIFT + K while simulator has focus on text input")
		}
		
		if app.keyboards.keys["a"].waitForExistence(timeout: 2) {
			_ = app.textFields["bookSearchAccessIdentifier"].waitForExistence(timeout: 5)
			app.textFields["bookSearchAccessIdentifier"].typeText(searchText)
			app.buttons["search"].tap()
		}
		
		if app.keyboards.keys["ㄱ"].waitForExistence(timeout: 2) {
			_ = app.textFields["bookSearchAccessIdentifier"].waitForExistence(timeout: 5)
			app.textFields["bookSearchAccessIdentifier"].typeText(searchText)
			app.buttons["검색"].tap()
		}
		
		// Tap on first result row
		app.tables["bookTableViewAccessIdentifier"].cells.staticTexts["제목: The Art of Batman Begins"].tap()
		
		// Make sure book details view
		XCTAssertTrue(app.otherElements["bookDetailViewAccessIdentifier"].waitForExistence(timeout: 5))
	}
}
