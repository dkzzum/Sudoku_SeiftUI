//
//  ScreenGame.swift
//  Sudoku
//
//  Created by Данил on 01.05.2024.
//

import SwiftUI

struct GameScreen: View {
    let len_area: Int
    @State private var selectedNumber: Int? // Выбранное пользователем число
    @State private var lastTappedIndex: Int? // Индекс последней выбранной ячейки
    @Binding var numbersInCells: [Int: Int] // Словарь для хранения чисел в ячейках
    @Binding var cellStatus: [Int: Bool] // Статус ячеек (true - заполнено автоматически, false - заполнено пользователем)
    @Binding var cellColors: [Int: Color] // Цвет ячейки
    @Binding var allNumbersInCells: [Int: Int]

    var body: some View {
        VStack(spacing: 30) {
            TopPanel() // Верхняя панель с информацией
            ContainerGrid(len_area: len_area, selectedNumber: $selectedNumber, lastTappedIndex: $lastTappedIndex, numbersInCells: $numbersInCells, cellStatus: $cellStatus, cellColors: $cellColors, allNumbersInCells: $allNumbersInCells)
                .frame(width: 360.0) // Устанавливаем ширину контейнера для сетки
            NumberPicker(selectedNumber: $selectedNumber, lastTappedIndex: $lastTappedIndex, numbersInCells: $numbersInCells, cellStatus: $cellStatus, cellColors: $cellColors, allNumbersInCells: $allNumbersInCells)
                .frame(width: 360.0) // Устанавливаем ширину панели с цифрами
        }
        .toolbar(.hidden, for: .tabBar) // Скрываем нижнюю панель инструментов
        .frame(maxWidth: .infinity) // Центрируем содержимое
    }
}




//#Preview {
//    GameScreen(len_area: 3)
//}
