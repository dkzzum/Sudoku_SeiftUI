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
    @State private var cellStatus: [Int: Bool] = [:] // Статус ячеек (true - заполнено автоматически, false - заполнено пользователем)
    @State private var gameTime: TimeInterval = 0 // Время игры
    @State private var errorCount: Int = 0 // Количество ошибок
    @State private var difficultyLevel: String = "Easy" // Уровень сложности
    
    var body: some View {
        VStack {
            TopInfo(gameTime: $gameTime, errorCount: $errorCount, difficultyLevel: $difficultyLevel)
            SudokuGrid(len_area: len_area, selectedNumber: $selectedNumber, lastTappedIndex: $lastTappedIndex, numbersInCells: $numbersInCells, cellStatus: $cellStatus)
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
    }
    
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            gameTime += 1
        }
    }
    
    func generateSudokuField() {
        let grid = Grid(len_area: len_area)
        let userField = grid.removeCells(difficulty: difficultyLevel)
        
        for (rowIndex, row) in userField.enumerated() {
            for (colIndex, value) in row.enumerated() {
                let index = rowIndex * len_area * len_area + colIndex
                if value != 0 {
                    numbersInCells[index] = value
                    cellStatus[index] = true // Значение заполнено автоматически
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

    var body: some View {
        VStack(spacing: 0) {
            // Создаем сетку из больших блоков 3x3
            ForEach(0..<len_area, id: \.self) { bigRow in
                HStack(spacing: 0) {
                    ForEach(0..<len_area, id: \.self) { bigCol in
                        // Передаем параметры для каждой ячейки в блоке 3x3
                        CellGrid(bigRow: bigRow, bigCol: bigCol, len_area: len_area, lastTappedIndex: $lastTappedIndex, selectedNumber: $selectedNumber, numbersInCells: $numbersInCells, cellStatus: $cellStatus)
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

    var body: some View {
        VStack(spacing: 0) {
            // Создаем сетку из ячеек внутри блока 3x3
            ForEach(0..<len_area, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<len_area, id: \.self) { column in
                        // Индекс ячейки вычисляется на основе её позиции в большой сетке
                        Cell(lastTappedIndex: $lastTappedIndex, selectedNumber: $selectedNumber, numbersInCells: $numbersInCells, cellStatus: $cellStatus, index: ((bigRow * len_area + row) * len_area * len_area) + (bigCol * len_area + column))
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
    let index: Int // Индекс текущей ячейки

    var body: some View {
        Button(action: {
            // Обновляем активную ячейку при нажатии
            if lastTappedIndex == index {
                lastTappedIndex = nil // Если ячейка уже активна, деактивируем её
            } else {
                lastTappedIndex = index // Устанавливаем текущую ячейку как активную
            }
        }) {
            RoundedRectangle(cornerRadius: 0) // Прямоугольник с нулевым радиусом скругления
                .stroke(Color(red: 0.494, green: 0.498, blue: 0.578), lineWidth: 1) // Цвет и ширина границы ячейки
                .frame(width: 35, height: 35) // Размер ячейки
                .background(lastTappedIndex == index ? Color(red: 0.753, green: 0.823, blue: 0.997) : Color.white) // Цвет фона для активной и неактивной ячейки
                .overlay(
                    Text(numbersInCells[index] != nil ? "\(numbersInCells[index]!)" : "")
                        .font(.title) // Устанавливаем большой шрифт для числа
                        .foregroundColor(cellStatus[index] == true ? Color.black : Color(red: 0.263, green: 0.367, blue: 0.658)) // Цвет текста
                )
        }
    }
}




struct TopInfo: View {
    @Binding var gameTime: TimeInterval // Время игры
    @Binding var errorCount: Int // Количество ошибок
    @Binding var difficultyLevel: String // Уровень сложности

    var body: some View {
        HStack {
            Text("Время: \(formatTime(gameTime))")
                .font(.caption)
                .foregroundColor(Color(red: 0.494, green: 0.498, blue: 0.578))
            Spacer()
            Text("Ошибки: \(errorCount)")
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


struct eScreen: View {
    let len_area: Int
    @State private var selectedNumber: Int?
    @State private var lastTappedIndex: Int?
    @State private var numbersInCells: [Int: Int] = [:]  // Инициализация пустого словаря

    var body: some View {
        VStack() {
            ContainerGrid(len_area: len_area, selectedNumber: $selectedNumber, lastTappedIndex: $lastTappedIndex, numbersInCells: $numbersInCells)
            
        }
        .toolbar(.hidden, for: .tabBar)
        .frame(maxWidth: .infinity)
    }
}


#Preview {
    eScreen(len_area: 3)
}
