//
//  SudokuGrid.swift
//  Sudoku
//
//  Created by Данил on 28.04.2024.
//

import SwiftUI

struct ContainerGrid: View {
    let len_area: Int // Размер большой области
    @Binding var selectedNumber: Int? // Привязка к выбранному числу
    @Binding var lastTappedIndex: Int? // Привязка к индексу последней выбранной ячейки
    @Binding var numbersInCells: [Int: Int] // Привязка к словарю чисел в ячейках
    @Binding var cellStatus: [Int: Bool] // Статус ячеек (true - заполнено автоматически, false - заполнено пользователем)
    @Binding var cellColors: [Int: Color]
    @Binding var allNumbersInCells: [Int: Int]
    @Binding var errorCount: Int // Количество ошибок
    @Binding var showEndGameAlert: Bool
    @Binding var highlightedNumber: Int?
    @Binding var gameTimer: Timer?
    @Binding var placedNumbersCount: [Int: Int]

    @State private var gameTime: TimeInterval = 0 // Время игры
    @State private var difficultyLevel: String = "Easy" // Уровень сложности
    
    var body: some View {
        VStack {
            TopInfo(gameTime: $gameTime, errorCount: $errorCount, difficultyLevel: $difficultyLevel)
            SudokuGrid(len_area: len_area, selectedNumber: $selectedNumber, lastTappedIndex: $lastTappedIndex, numbersInCells: $numbersInCells, cellStatus: $cellStatus, cellColors: $cellColors, allNumbersInCells: $allNumbersInCells, highlightedNumber: $highlightedNumber)
                .padding([.leading, .trailing], 5) // Отступы от вертикальных краев
        }
        .padding(.top, 5.0) // Верхний отступ
        .padding([.leading, .bottom, .trailing], 9.0) // Отступы слева, снизу и справа
        .background(Color(red: 0.966, green: 0.973, blue: 0.997)) // Цвет фона контейнера
        .cornerRadius(10) // Скругленные углы контейнера
        .onAppear {
            startTimer()
            generateSudokuField()
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            gameTime += 1
        }
    }
    
    func stopTimer() {
        gameTimer?.invalidate()
        gameTimer = nil
    }
    
    func generateSudokuField() {
        let grid = Grid(len_area: len_area)
        let userField = grid.removeCells(difficulty: difficultyLevel)
        
        // Инициализация placedNumbersCount
        placedNumbersCount = [:]
        
        for (rowIndex, row) in grid.field.enumerated() {
            for (colIndex, value) in row.enumerated() {
                let index = rowIndex * len_area * len_area + colIndex
                allNumbersInCells[index] = value
            }
        }
        
        for (rowIndex, row) in userField.enumerated() {
            for (colIndex, value) in row.enumerated() {
                let index = rowIndex * len_area * len_area + colIndex
                if value != 0 {
                    numbersInCells[index] = value
                    cellStatus[index] = true // Значение заполнено автоматически
                    
                    // Увеличение счётчика для каждого числа
                    if value != 0 {
                        placedNumbersCount[value, default: 0] += 1
                    }
                }
            }
        }
    }
}



struct SudokuGrid: View {
    let len_area: Int // Размер большой области (например, 3 для судоку 9x9)
    @Binding var selectedNumber: Int? // Привязка к выбранному числу
    @Binding var lastTappedIndex: Int? // Привязка к индексу последней выбранной ячейки
    @Binding var numbersInCells: [Int: Int] // Привязка к словарю чисел в ячейках
    @Binding var cellStatus: [Int: Bool] // Статус ячеек (true - заполнено автоматически, false - заполнено пользователем)
    @Binding var cellColors: [Int: Color]
    @Binding var allNumbersInCells: [Int: Int]
    @Binding var highlightedNumber: Int?

    var body: some View {
        VStack(spacing: 0) {
            // Создаем сетку из больших блоков 3x3
            ForEach(0..<len_area, id: \.self) { bigRow in
                HStack(spacing: 0) {
                    ForEach(0..<len_area, id: \.self) { bigCol in
                        // Передаем параметры для каждой ячейки в блоке 3x3
                        CellGrid(bigRow: bigRow, bigCol: bigCol, len_area: len_area, lastTappedIndex: $lastTappedIndex, selectedNumber: $selectedNumber, numbersInCells: $numbersInCells, cellStatus: $cellStatus, cellColors: $cellColors, allNumbersInCells: $allNumbersInCells, highlightedNumber: $highlightedNumber)
                    }
                }
            }
        }
        .border(Color.black, width: 2) // Граница вокруг всей сетки
    }
}


struct CellGrid: View {
    let bigRow: Int // Номер строки в большом блоке 3x3
    let bigCol: Int // Номер столбца в большом блоке 3x3
    let len_area: Int // Размер большой области
    @Binding var lastTappedIndex: Int? // Привязка к индексу последней выбранной ячейки
    @Binding var selectedNumber: Int? // Привязка к выбранному числу
    @Binding var numbersInCells: [Int: Int] // Привязка к словарю чисел в ячейках
    @Binding var cellStatus: [Int: Bool] // Статус ячеек (true - заполнено автоматически, false - заполнено пользователем)
    @Binding var cellColors: [Int: Color]
    @Binding var allNumbersInCells: [Int: Int]
    @Binding var highlightedNumber: Int?

    var body: some View {
        VStack(spacing: 0) {
            // Создаем сетку из ячеек внутри блока 3x3
            ForEach(0..<len_area, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<len_area, id: \.self) { column in
                        // Индекс ячейки вычисляется на основе её позиции в большой сетке
                        Cell(lastTappedIndex: $lastTappedIndex, selectedNumber: $selectedNumber, numbersInCells: $numbersInCells, cellStatus: $cellStatus,cellColors: $cellColors, allNumbersInCells: $allNumbersInCells, highlightedNumber: $highlightedNumber, index: (((bigRow * len_area + row) * len_area * len_area) + (bigCol * len_area + column)))
                    }
                }
            }
        }
        .border(Color.black, width: 1) // Граница вокруг блока 3x3
    }
}


struct Cell: View {
    @Binding var lastTappedIndex: Int? // Привязка к индексу последней выбранной ячейки
    @Binding var selectedNumber: Int? // Привязка к выбранному числу
    @Binding var numbersInCells: [Int: Int] // Привязка к словарю чисел в ячейках
    @Binding var cellStatus: [Int: Bool] // Статус ячеек (true - заполнено автоматически, false - заполнено пользователем)
    @Binding var cellColors: [Int: Color] // Цвет ячейки
    @Binding var allNumbersInCells: [Int: Int]
    @Binding var highlightedNumber: Int?
    let index: Int // Индекс текущей ячейки

    var body: some View {
        Button(action: {
            // Обновляем активную ячейку при нажатии
            if lastTappedIndex == index {
                lastTappedIndex = nil // Если ячейка уже активна, деактивируем её
                highlightedNumber = nil
            } else {
                lastTappedIndex = index // Устанавливаем текущую ячейку как активную
                // Обновляем выделенное число
                if let number = numbersInCells[index] {
                    highlightedNumber = number
                } else {
                    highlightedNumber = nil
                }
            }
            
        }) {
            RoundedRectangle(cornerRadius: 0) // Прямоугольник с нулевым радиусом скругления
                .stroke(Color(red: 0.494, green: 0.498, blue: 0.578), lineWidth: 1) // Цвет и ширина границы ячейки
                .frame(width: 35, height: 35) // Размер ячейки
                .background(determineBackgroundColor(for: index, with: numbersInCells[index])) // Цвет фона для активной и неактивной ячейки
                .overlay(
                    Text(numbersInCells[index] != nil ? "\(numbersInCells[index]!)" : "")
                        .font(.title) // Устанавливаем большой шрифт для числа
                        .foregroundColor(cellStatus[index] == true ? Color.black : Color(red: 0.263, green: 0.367, blue: 0.658)) // Цвет текста
                )
        }
    }
    
    func determineBackgroundColor(for index: Int, with number: Int?) -> Color {
            // Проверяем, активна ли ячейка
            if lastTappedIndex == index {
                // Если ячейка активна, проверяем, пуста ли она
                if number == nil {
                    // Ячейка пуста и активна, используем синий цвет
                    return Color(red: 0.753, green: 0.823, blue: 0.997)
                } else if let correctNumber = allNumbersInCells[index] {
                    // Ячейка не пуста, проверяем правильность числа
                    return number == correctNumber ? Color(red: 0.753, green: 0.823, blue: 0.997) : Color(red: 0.996, green: 0.853, blue: 0.834)
                } else {
                    // Нет данных о правильном числе, просто синий, если число не ноль
                    return Color(red: 0.753, green: 0.823, blue: 0.997)
                }
            }
            // Если ячейка содержит выделенное число
            else if let highlightedNumber = highlightedNumber, number == highlightedNumber {
                return Color(red: 0.776, green: 0.794, blue: 0.89)
            }
            // Стандартный цвет
            else {
                return cellColors[index] ?? Color.white
            }
    }
}



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
            Text("Ошибки: \(errorCount) из 3")
                .font(.caption)
                .foregroundColor(Color(red: 0.494, green: 0.498, blue: 0.578))
            Spacer()
            Text("Сложность: \(difficultyLevel)")
                .font(.caption)
                .foregroundColor(Color(red: 0.494, green: 0.498, blue: 0.578))
        }
        .padding(.vertical, 5.0)
        .frame(width: 300.0)
    }

    func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}


//struct eScreen: View {
//    let len_area: Int
//    @State var gameTime: TimeInterval = 0  // Инициализация пустого словаря
//    @Binding var nnn: Bool
//
//    var body: some View {
//        VStack() {
//            CompletionAlertView(isVisible: $nnn, gameTime: gameTime, difficultyLevel: "East")
//        }
////        .toolbar(.hidden, for: .tabBar)
////        .frame(maxWidth: .infinity)
//    }
//}
//
//struct scree: View {
//    var len_area: Int = 3
//    @State var nnn: Bool = true
//    var body: some View {
//        eScreen(len_area: len_area, nnn: $nnn)
//    }
//}
//
//
//#Preview {
//    scree(len_area: 3)
//}
