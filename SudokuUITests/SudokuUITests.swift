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
        XCTAssertTrue(app.staticTexts["Время: 00:00"].exists) // Здесь предполагается, что на экране игры есть текст "Время: 00:00"
    }

    func testRulesScreenContent() throws {
        let app = XCUIApplication()
        
        // Переключение на вкладку "Правила"
        app.tabBars.buttons["Правила"].tap()
        
        // Проверка наличия текста правил
        let rulesText = "Правила игры Судоку"
        XCTAssertTrue(app.staticTexts[rulesText].exists)
    }

    func testCompletionAlert() throws {
        let app = XCUIApplication()
        
        // Начало игры
        let startGameButton = app.buttons["Начать игру"]
        XCTAssertTrue(startGameButton.exists)
        startGameButton.tap()
        
        // Проверка, что экран игры отображается после нажатия кнопки
        XCTAssertTrue(app.staticTexts["Время: 00:00"].exists) // Здесь предполагается, что на экране игры есть текст "Время: 00:00"
        
        // Получаем текущее состояние доски судоку
        let board: [[Int]] = getSudokuBoard(from: app)

        // Решаем судоку
        let solver = SudokuSolver(board: board)
        if solver.solve() {
            // Заполняем доску с решением
            fillSudokuBoard(solver.board, in: app)
        } else {
            XCTFail("Не удалось решить судоку")
        }
        
        // Проверка наличия уведомления о завершении игры
        let completionAlert = app.alerts["Поздравляем!"]
        XCTAssertTrue(completionAlert.waitForExistence(timeout: 10))
        
        // Закрытие уведомления
        completionAlert.buttons["OK"].tap()
        XCTAssertFalse(completionAlert.exists)
    }

    // Метод для получения текущего состояния доски судоку из UI
    func getSudokuBoard(from app: XCUIApplication) -> [[Int]] {
        var board = Array(repeating: Array(repeating: 0, count: 9), count: 9)
        
        for i in 0..<9 {
            for j in 0..<9 {
                let cell = app.cells["cell_\(i)_\(j)"]
                if cell.exists {
                    let label = cell.staticTexts.element(boundBy: 0).label
                    if let number = Int(label) {
                        board[i][j] = number
                    }
                }
            }
        }
        
        return board
    }


    // Метод для заполнения доски судоку в UI
    func fillSudokuBoard(_ board: [[Int]], in app: XCUIApplication) {
        for i in 0..<9 {
            for j in 0..<9 {
                if board[i][j] != 0 {
                    let cell = app.cells["cell_\(i)_\(j)"]
                    cell.tap()

                    let numberButton = app.buttons["number_\(board[i][j])"]
                    XCTAssertTrue(numberButton.exists)
                    numberButton.tap()
                }
            }
        }
    }

    }

    class SudokuSolver {
        
        let size: Int
        let subgridSize: Int
        var board: [[Int]]

        init(board: [[Int]]) {
            self.board = board
            self.size = board.count
            self.subgridSize = Int(sqrt(Double(size)))
        }
        
        func solve() -> Bool {
            var emptyPosition: (Int, Int)?
            
            // Найти первую пустую ячейку
            for row in 0..<size {
                for col in 0..<size {
                    if board[row][col] == 0 {
                        emptyPosition = (row, col)
                        break
                    }
                }
                if emptyPosition != nil {
                    break
                }
            }
            
            // Если нет пустых ячеек, то судоку решена
            if emptyPosition == nil {
                return true
            }
            
            let row = emptyPosition!.0
            let col = emptyPosition!.1
            
            // Попробовать все числа от 1 до 9
            for num in 1...9 {
                if isSafeToPlaceNumber(row: row, col: col, num: num) {
                    board[row][col] = num
                    
                    if solve() {
                        return true
                    }
                    
                    // Откат изменений
                    board[row][col] = 0
                }
            }
            
            // Если не удалось найти подходящее число
            return false
        }
        
        // Проверка, можно ли поместить число в ячейку
        func isSafeToPlaceNumber(row: Int, col: Int, num: Int) -> Bool {
            // Проверка строки
            for x in 0..<size {
                if board[row][x] == num {
                    return false
                }
            }
            
            // Проверка столбца
            for x in 0..<size {
                if board[x][col] == num {
                    return false
                }
            }
            
            // Проверка подгруппы
            let startRow = row - row % subgridSize
            let startCol = col - col % subgridSize
            
            for i in 0..<subgridSize {
                for j in 0..<subgridSize {
                    if board[i + startRow][j + startCol] == num {
                        return false
                    }
                }
            }
            
            return true
        }
    }
