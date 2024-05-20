//
//  SudokuGrid.swift
//  Sudoku
//
//  Created by Данил on 28.04.2024.
//

import SwiftUI

// Структура для представления сетки контейнеров
struct ContainerGrid: View {
    let len_area: Int
    @Binding var selectedNumber: Int? // Выбранное число
    @Binding var lastTappedIndex: Int? // Индекс последней нажатой ячейки
    @Binding var numbersInCells: [Int: Int] // Привязка к числам в ячейках
    @Binding var cellStatus: [Int: Bool] // Привязка к статусу ячеек
    @Binding var cellColors: [Int: Color] // Привязка к цветам ячеек
    @Binding var allNumbersInCells: [Int: Int] // Привязка к всем числам в ячейках
    @Binding var errorCount: Int // Привязка к счетчику ошибок
    @Binding var showEndGameAlert: Bool // Привязка к флагу окончания игры
    @Binding var highlightedNumber: Int? // Привязка к выделенному числу
    @Binding var gameTimer: Timer? // Привязка к таймеру игры
    @Binding var placedNumbersCount: [Int: Int] // Привязка к количеству

    @State private var gameTime: TimeInterval = 0 // Привязка к времени игры
    @State private var difficultyLevel: String = "Easy"
    @State private var activeSquareIndices: Set<Int> = []

    var body: some View {
        VStack {
            // Верхняя панель с информацией
            TopInfo(gameTime: $gameTime, errorCount: $errorCount, difficultyLevel: $difficultyLevel)
            // Сетка Судоку
            SudokuGrid(len_area: len_area, selectedNumber: $selectedNumber, lastTappedIndex: $lastTappedIndex, numbersInCells: $numbersInCells, cellStatus: $cellStatus, cellColors: $cellColors, allNumbersInCells: $allNumbersInCells, highlightedNumber: $highlightedNumber, activeSquareIndices: $activeSquareIndices)
                .padding(.horizontal, 5)
                .padding(.bottom, 5)
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.15), radius: 1, x: 0, y: 3)
        .onAppear {
            startTimer() // Запуск таймера при появлении
            generateSudokuField() // Генерация поля Судоку
        }
        .onDisappear {
            stopTimer() // Остановка таймера при исчезновении
        }
    }

    // Функция запуска таймера
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            gameTime += 1
        }
    }

    // Функция остановки таймера
    func stopTimer() {
        gameTimer?.invalidate()
        gameTimer = nil
    }

    // Функция генерации поля Судоку
    func generateSudokuField() {
        let grid = Grid(len_area: len_area) // Создание объекта сетки
        let userField = grid.removeCells(difficulty: difficultyLevel) // Удаление ячеек в зависимости от уровня сложности

        placedNumbersCount = [:]

        for (rowIndex, row) in grid.field.enumerated() {
            for (colIndex, value) in row.enumerated() {
                let index = rowIndex * len_area * len_area + colIndex
                allNumbersInCells[index] = value // Заполнение всех чисел в ячейках
            }
        }

        for (rowIndex, row) in userField.enumerated() {
            for (colIndex, value) in row.enumerated() {
                let index = rowIndex * len_area * len_area + colIndex
                if value != 0 {
                    numbersInCells[index] = value // Заполнение чисел в ячейках, которые не были удалены
                    cellStatus[index] = true

                    if value != 0 {
                        placedNumbersCount[value, default: 0] += 1
                    }
                }
            }
        }
    }
}

// Структура для представления сетки Судоку
struct SudokuGrid: View {
    let len_area: Int
    @Binding var selectedNumber: Int?
    @Binding var lastTappedIndex: Int?
    @Binding var numbersInCells: [Int: Int]
    @Binding var cellStatus: [Int: Bool]
    @Binding var cellColors: [Int: Color]
    @Binding var allNumbersInCells: [Int: Int]
    @Binding var highlightedNumber: Int?
    @Binding var activeSquareIndices: Set<Int>

    var body: some View {
        VStack(spacing: 0) {
            // Создание сетки ячеек
            ForEach(0..<len_area, id: \.self) { bigRow in
                HStack(spacing: 0) {
                    ForEach(0..<len_area, id: \.self) { bigCol in
                        CellGrid(bigRow: bigRow, bigCol: bigCol, len_area: len_area, lastTappedIndex: $lastTappedIndex, selectedNumber: $selectedNumber, numbersInCells: $numbersInCells, cellStatus: $cellStatus, cellColors: $cellColors, allNumbersInCells: $allNumbersInCells, highlightedNumber: $highlightedNumber, activeSquareIndices: $activeSquareIndices)
                    }
                }
            }
        }
        .border(Color.black, width: 2)
    }
}

// Структура для представления сетки ячеек
struct CellGrid: View {
    let bigRow: Int
    let bigCol: Int
    let len_area: Int
    @Binding var lastTappedIndex: Int?
    @Binding var selectedNumber: Int?
    @Binding var numbersInCells: [Int: Int]
    @Binding var cellStatus: [Int: Bool]
    @Binding var cellColors: [Int: Color]
    @Binding var allNumbersInCells: [Int: Int]
    @Binding var highlightedNumber: Int?
    @Binding var activeSquareIndices: Set<Int>

    var body: some View {
        VStack(spacing: 0) {
            // Создание ячеек внутри большой ячейки
            ForEach(0..<len_area, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<len_area, id: \.self) { column in
                        Cell(len_area: len_area, lastTappedIndex: $lastTappedIndex, selectedNumber: $selectedNumber, numbersInCells: $numbersInCells, cellStatus: $cellStatus, cellColors: $cellColors, allNumbersInCells: $allNumbersInCells, highlightedNumber: $highlightedNumber, activeSquareIndices: $activeSquareIndices, index: (((bigRow * len_area + row) * len_area * len_area) + (bigCol * len_area + column)))
                    }
                }
            }
        }
        .border(Color.black, width: 1)
    }
}

// Структура для представления отдельной ячейки
struct Cell: View {
    let len_area: Int
    @Binding var lastTappedIndex: Int?
    @Binding var selectedNumber: Int?
    @Binding var numbersInCells: [Int: Int]
    @Binding var cellStatus: [Int: Bool]
    @Binding var cellColors: [Int: Color]
    @Binding var allNumbersInCells: [Int: Int]
    @Binding var highlightedNumber: Int?
    @Binding var activeSquareIndices: Set<Int>
    let index: Int

    var body: some View {
        Button(action: {
                lastTappedIndex = index
                highlightedNumber = numbersInCells[index]
                updateActiveSquareIndices(for: index)
        }) {
            RoundedRectangle(cornerRadius: 0)
                .stroke(Color(red: 0.494, green: 0.498, blue: 0.578), lineWidth: 1)
                .background(determineBackgroundColor(for: index, with: numbersInCells[index]).animation(nil))

                .frame(width: 38, height: 38)
                .overlay(
                    Text(numbersInCells[index] != nil ? "\(numbersInCells[index]!)" : "")
                        .font(.title)
                        .foregroundColor(cellStatus[index] == true ? Color.black : Color(red: 0.263, green: 0.367, blue: 0.658))
                )
        }
        .buttonStyle(PlainButtonStyle()) // Использование стиля без анимации
        .accessibility(identifier: "cell_\(index / len_area)_\(index % len_area)")
    }

    // Добавление метода обновления активных квадратных индексов в ContainerGrid
    func updateActiveSquareIndices(for index: Int) {
        let row = index / (len_area * len_area)
        let col = index % (len_area * len_area)
        let startRow = (row / len_area) * len_area
        let startCol = (col / len_area) * len_area
        activeSquareIndices.removeAll()

        for r in startRow..<startRow + len_area {
            for c in startCol..<startCol + len_area {
                let squareIndex = r * len_area * len_area + c
                activeSquareIndices.insert(squareIndex)
            }
        }

        for r in 0..<len_area * len_area {
            let verticalIndex = r * len_area * len_area + col
            activeSquareIndices.insert(verticalIndex)
        }

        for c in 0..<len_area * len_area {
            let horizontalIndex = row * len_area * len_area + c
            activeSquareIndices.insert(horizontalIndex)
        }
    }
    
    // Определение цвета фона для ячейки
    func determineBackgroundColor(for index: Int, with number: Int?) -> Color {
        if lastTappedIndex == index {
            if number == nil {
                return Color(red: 0.753, green: 0.823, blue: 0.997)
            } else if let correctNumber = allNumbersInCells[index] {
                return number == correctNumber ? Color(red: 0.753, green: 0.823, blue: 0.997) : Color(red: 0.996, green: 0.853, blue: 0.834)
            } else {
                return Color(red: 0.753, green: 0.823, blue: 0.997)
            }
        } else if activeSquareIndices.contains(index) {
            if let currentColor = cellColors[index], currentColor == Color(red: 0.996, green: 0.853, blue: 0.834) {
                return currentColor
            }
            return Color(red: 0.902, green: 0.916, blue: 0.96)
        } else if let highlightedNumber = highlightedNumber, number == highlightedNumber {
            return Color(red: 0.777, green: 0.794, blue: 0.883)
        } else {
            return cellColors[index] ?? Color.white
        }
    }
}

// Структура для представления верхней панели с информацией
struct TopInfo: View {
    @Binding var gameTime: TimeInterval
    @Binding var errorCount: Int
    @Binding var difficultyLevel: String

    var body: some View {
        HStack {
            Text("Время: \(formatTime(gameTime))")
                .font(.caption)
                .foregroundColor(Color(red: 0.494, green: 0.498, blue: 0.578))
            Spacer()
            Text("Ошибки: \(errorCount)/3")
                .font(.caption)
                .foregroundColor(Color(red: 0.494, green: 0.498, blue: 0.578))
            Spacer()
            Text("Сложность: \(difficultyLevel)")
                .font(.caption)
                .foregroundColor(Color(red: 0.494, green: 0.498, blue: 0.578))
        }
        .padding(.top, 5.0)
        .frame(width: 300.0)
    }

    // Форматирование времени в строку
    func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}


//struct eScreen: View {
//    let len_area: Int
//    @State private var isShowingDetailsView = false
//    @State private var numbersInCells: [Int: Int] = [:] // Словарь для хранения чисел в ячейках
//    @State private var cellStatus: [Int: Bool] = [:] // Статус ячеек (true - заполнено автоматически, false - заполнено пользователем)
//    @State private var cellColors: [Int: Color] = [:]
//    @State private var allNumbersInCells: [Int: Int] = [:]
//    @State private var errorCount: Int = 0
//    @State private var showEndGameAlert = false
//    @State private var showCompletionAlert = false
//    @State private var gameTime: TimeInterval = 0
//    @State private var gameTimer: Timer?
//    @State private var highlightedNumber: Int? = nil
//    @State private var placedNumbersCount: [Int: Int] = [:]
//    
//    var body: some View {
//        VStack() {
//            NavigationView {
//                NavigationLink {
//                    GameScreen(len_area: len_area, numbersInCells: $numbersInCells, cellStatus: $cellStatus, cellColors: $cellColors, allNumbersInCells: $allNumbersInCells, errorCount: $errorCount, showEndGameAlert: $showEndGameAlert, showCompletionAlert: $showCompletionAlert, gameTime: $gameTime, gameTimer: $gameTimer, highlightedNumber: $highlightedNumber, placedNumbersCount: $placedNumbersCount)
//                } label: {
//                    Text("Начать игру")
//                        .font(.title)
//                        .foregroundColor(Color.white)
//                        .multilineTextAlignment(.center)
//                        .frame(width: 300.0, height: 50.0)
//                        .background(Color(red: 0.192, green: 0.477, blue: 0.907))
//                        .cornerRadius(50)
//                }
//            }
//        }
//    }
//}
//    
//
//
////struct scree: View {
////    var len_area: Int = 3
////    @State var nnn: Bool = true
////    var body: some View {
////        eScreen(len_area: len_area, nnn: $nnn)
////    }
////}
//
//
//#Preview {
//    //    scree(len_area: 4)
//    eScreen(len_area: 3)
//}
