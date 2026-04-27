//
//  CryptoViewerUITests.swift
//  CryptoViewerUITests
//
//  Created by Daniel Oliveira on 4/25/26.
//

import XCTest

// MARK: - Exchange List UI Tests

final class ExchangeListUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }

    private func launch(scenario: String) {
        app.launchEnvironment["UITEST_SCENARIO"] = scenario
        app.launch()
    }

    func testTitleIsVisible() {
        launch(scenario: "list-success")
        XCTAssertTrue(app.staticTexts["exchanges-title"].waitForExistence(timeout: 3))
    }

    func testExchangesAreDisplayed() {
        launch(scenario: "list-success")
        XCTAssertTrue(app.buttons["exchange-row-1"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.buttons["exchange-row-2"].exists)
    }

    func testEmptyListShowsNoRows() {
        launch(scenario: "list-empty")
        XCTAssertTrue(app.staticTexts["exchanges-title"].waitForExistence(timeout: 3))
        XCTAssertFalse(app.buttons["exchange-row-1"].exists)
    }

    func testErrorShowsAlert() {
        launch(scenario: "list-error")
        let alert = app.alerts["Oooops"]
        XCTAssertTrue(alert.waitForExistence(timeout: 3))
        XCTAssertTrue(alert.staticTexts["HTTP error 500."].exists)
    }

    func testErrorAlertDismissesOnOK() {
        launch(scenario: "list-error")
        let alert = app.alerts["Oooops"]
        XCTAssertTrue(alert.waitForExistence(timeout: 3))
        alert.buttons["OK"].tap()
        XCTAssertFalse(app.alerts["Oooops"].exists)
    }

    func testTapExchangeNavigatesToDetail() {
        launch(scenario: "detail-success")
        XCTAssertTrue(app.buttons["exchange-row-1"].waitForExistence(timeout: 3))
        app.buttons["exchange-row-1"].tap()
        XCTAssertTrue(app.staticTexts["exchange-detail-title"].waitForExistence(timeout: 3))
    }
}

// MARK: - Exchange Detail UI Tests

final class ExchangeDetailUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }

    private func launchAndOpenDetail(scenario: String) {
        app.launchEnvironment["UITEST_SCENARIO"] = scenario
        app.launch()
        XCTAssertTrue(app.buttons["exchange-row-1"].waitForExistence(timeout: 3))
        app.buttons["exchange-row-1"].tap()
    }

    func testDetailTitleIsVisible() {
        launchAndOpenDetail(scenario: "detail-success")
        XCTAssertTrue(app.staticTexts["exchange-detail-title"].waitForExistence(timeout: 3))
    }

    func testBackButtonIsVisible() {
        launchAndOpenDetail(scenario: "detail-success")
        XCTAssertTrue(app.buttons["exchange-detail-back"].waitForExistence(timeout: 3))
    }

    func testExchangeNameIsDisplayed() {
        launchAndOpenDetail(scenario: "detail-success")
        XCTAssertTrue(app.staticTexts["exchange-detail-name"].waitForExistence(timeout: 3))
        XCTAssertEqual(app.staticTexts["exchange-detail-name"].label, "Binance")
    }

    func testErrorShowsAlert() {
        launchAndOpenDetail(scenario: "detail-error")
        let alert = app.alerts["Oooops"]
        XCTAssertTrue(alert.waitForExistence(timeout: 3))
        XCTAssertTrue(alert.staticTexts["HTTP error 500."].exists)
    }

    func testErrorAlertDismissesOnOK() {
        launchAndOpenDetail(scenario: "detail-error")
        let alert = app.alerts["Oooops"]
        XCTAssertTrue(alert.waitForExistence(timeout: 3))
        alert.buttons["OK"].tap()
        XCTAssertFalse(app.alerts["Oooops"].exists)
    }

    func testBackButtonNavigatesToList() {
        launchAndOpenDetail(scenario: "detail-success")
        XCTAssertTrue(app.buttons["exchange-detail-back"].waitForExistence(timeout: 3))
        app.buttons["exchange-detail-back"].tap()
        XCTAssertTrue(app.staticTexts["exchanges-title"].waitForExistence(timeout: 3))
    }
}
