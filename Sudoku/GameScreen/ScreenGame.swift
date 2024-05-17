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
    @Binding var errorCount: Int
    @Binding var showEndGameAlert: Bool
    @Binding var showCompletionAlert: Bool
    @Binding var gameTime: TimeInterval
    @Binding var gameTimer: Timer?
    

    var body: some View {
        VStack(spacing: 30) {
            TopPanel() // Верхняя панель с информацией
            ContainerGrid(len_area: len_area, selectedNumber: $selectedNumber, lastTappedIndex: $lastTappedIndex, numbersInCells: $numbersInCells, cellStatus: $cellStatus, cellColors: $cellColors, allNumbersInCells: $allNumbersInCells, errorCount: $errorCount, showEndGameAlert: $showEndGameAlert)
                .frame(width: 360.0) // Устанавливаем ширину контейнера для сетки
            NumberPicker(selectedNumber: $selectedNumber, lastTappedIndex: $lastTappedIndex, numbersInCells: $numbersInCells, cellStatus: $cellStatus, cellColors: $cellColors, allNumbersInCells: $allNumbersInCells, errorCount: $errorCount, showEndGameAlert: $showEndGameAlert, showCompletionAlert: $showCompletionAlert, gameTime: $gameTime, gameTimer: $gameTimer)
                .frame(width: 360.0) // Устанавливаем ширину панели с цифрами
        }
        .overlay(
            showEndGameAlert ? EndGameView(isVisible: $showEndGameAlert) : nil
        )
        .overlay(
                    showCompletionAlert ? AnyView(CompletionAlertView(isVisible: $showCompletionAlert, gameTime: gameTime, difficultyLevel: "Easy")) : nil
                )
        .toolbar(.hidden, for: .tabBar) // Скрываем нижнюю панель инструментов
        .frame(maxWidth: .infinity) // Центрируем содержимое
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    
    private func startTimer() {
        gameTimer?.invalidate() // Остановите текущий таймер, если он существует
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            gameTime += 1
        }
    }

    private func stopTimer() {
        gameTimer?.invalidate()
        gameTimer = nil
    }

    private func startNewGame() {
        // Реализуйте логику для начала новой игры
        stopTimer()
        startTimer()
        // Сбросьте другие состояния игры
    }

    private func exitToMainMenu() {
        // Реализуйте логику для возврата на главный экран
        stopTimer()
        // Вернуться на главный экран
    }
}




//#Preview {
//    GameScreen(len_area: 3)
//}
