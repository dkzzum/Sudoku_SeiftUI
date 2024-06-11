//
//  SudokuUITests.swift
//  SudokuUITests
//
//  Created by Данил on 27.04.2024.
//

import XCTest

class MyAppUITests: XCTestCase {

    override func setUpWithError() throws {
        // Настройка перед каждым тестом
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        // Очистка после каждого теста
    }

    func testMenuNavigation() throws {
        let app = XCUIApplication()
        
        // Проверка, что мы находимся на главной странице
        XCTAssertTrue(app.buttons["Начать игру"].exists)

        // Переключение на вкладку "Правила"
        app.tabBars.buttons["Правила"].tap()
        XCTAssertTrue(app.staticTexts["Правила игры Судоку"].exists)
        
        // Переключение на вкладку "Статистика"
        app.tabBars.buttons["Статистика"].tap()
        XCTAssertTrue(app.staticTexts["Статистика"].exists)

        // Возвращение на вкладку "Главная"
        app.tabBars.buttons["Главная"].tap()
        XCTAssertTrue(app.buttons["Начать игру"].exists)
    }

    func testStartGameButton() throws {
        let app = XCUIApplication()
        
        // Проверка наличия кнопки "Начать игру" и её нажатие
        let startGameButton = app.buttons["Начать игру"]
        XCTAssertTrue(startGameButton.exists)
        startGameButton.tap()
        
        // Проверка, что экран игры отображается после нажатия кнопки
        XCTAssertTrue(app.staticTexts["Лёгкий"].exists) // Здесь предполагается, что на экране игры есть текст "Время: 00:00"
    }

    func testRulesScreenContent() throws {
        let app = XCUIApplication()
        
        // Переключение на вкладку "Правила"
        app.tabBars.buttons["Правила"].tap()
        
        // Проверка наличия текста правил
        let rulesText = "Правила игры Судоку"
        XCTAssertTrue(app.staticTexts[rulesText].exists)
    }
    
    func testStateScreenContent() throws {
        let app = XCUIApplication()
        
        // Переключение на вкладку "Правила"
        app.tabBars.buttons["Статистика"].tap()
        
        // Проверка наличия текста правил
        let rulesText = "Статистика"
                XCTAssertTrue(app.staticTexts[rulesText].exists)
    }
}
