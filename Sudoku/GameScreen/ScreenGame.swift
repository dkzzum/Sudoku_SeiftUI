//
//  ScreenGame.swift
//  Sudoku
//
//  Created by Данил on 01.05.2024.
//

import SwiftUI

// Структура для представления экрана игры
struct GameScreen: View {
    let len_area: Int // Размер игрового поля
    @State private var selectedNumber: Int? // Выбранное число
    @State private var lastTappedIndex: Int? // Индекс последней нажатой ячейки
    @Binding var numbersInCells: [Int: Int] // Привязка к числам в ячейках
    @Binding var cellStatus: [Int: Bool] // Привязка к статусу ячеек
    @Binding var cellColors: [Int: Color] // Привязка к цветам ячеек
    @Binding var allNumbersInCells: [Int: Int] // Привязка к всем числам в ячейках
    @Binding var errorCount: Int // Привязка к счетчику ошибок
    @Binding var showEndGameAlert: Bool // Привязка к флагу окончания игры
    @Binding var showCompletionAlert: Bool // Привязка к флагу завершения игры
    @Binding var gameTime: TimeInterval // Привязка к времени игры
    @Binding var gameTimer: Timer? // Привязка к таймеру игры
    @Binding var highlightedNumber: Int? // Привязка к выделенному числу
    @Binding var placedNumbersCount: [Int: Int] // Привязка к количеству размещенных чисел
    @Binding var activeSquareIndices: Set<Int>

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Фоновое изображение
                Image(uiImage: #imageLiteral(resourceName: "screen.jpg"))
                    .resizable(capInsets: EdgeInsets(), resizingMode: .tile)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .center, spacing: 30) {
                    TopPanel()
                        .padding(.bottom, 30.0)
                        .padding(.top, 30.0)
                    
                    // Сетка контейнеров с игровым полем
                    ContainerGrid(len_area: len_area, selectedNumber: $selectedNumber, lastTappedIndex: $lastTappedIndex, numbersInCells: $numbersInCells, cellStatus: $cellStatus, cellColors: $cellColors, allNumbersInCells: $allNumbersInCells, errorCount: $errorCount, showEndGameAlert: $showEndGameAlert, highlightedNumber: $highlightedNumber, gameTimer: $gameTimer, placedNumbersCount: $placedNumbersCount, activeSquareIndices: $activeSquareIndices)
                        .padding(.top, 30.0)
                        .padding(.bottom, 20.0)
                        .frame(width: geometry.size.width * 0.9, height: geometry.size.width * 0.9)
                    
                    // Панель выбора чисел
                    NumberPicker(selectedNumber: $selectedNumber, lastTappedIndex: $lastTappedIndex, numbersInCells: $numbersInCells, cellStatus: $cellStatus, cellColors: $cellColors, allNumbersInCells: $allNumbersInCells, errorCount: $errorCount, showEndGameAlert: $showEndGameAlert, showCompletionAlert: $showCompletionAlert, gameTime: $gameTime, gameTimer: $gameTimer, highlightedNumber: $highlightedNumber, placedNumbersCount: $placedNumbersCount, len_area: len_area, activeSquareIndices: $activeSquareIndices)
                        .padding(.top, 10.0)
                        .frame(width: geometry.size.width * 0.9, height: 100)
                        .shadow(color: Color.black.opacity(0.15), radius: 0, x: 0, y: 3)
                }
                .padding(.bottom, 80)
                .overlay(
                    showEndGameAlert ? EndGameView(isVisible: $showEndGameAlert) : nil
                )
                .overlay(
                    showCompletionAlert ? AnyView(CompletionAlertView(isVisible: $showCompletionAlert, gameTime: gameTime, difficultyLevel: "Easy")) : nil
                )
                .toolbar(.hidden, for: .tabBar)
                .frame(maxWidth: .infinity)
                .onAppear {
                    startTimer() // Запуск таймера при появлении экрана
                }
                .onDisappear {
                    stopTimer() // Остановка таймера при исчезновении экрана
                    numbersInCells.removeAll()
                    cellStatus.removeAll()
                    cellColors.removeAll()
                    allNumbersInCells.removeAll()
                    highlightedNumber = nil
                    selectedNumber = nil
                    lastTappedIndex = nil
                }
            }
        }
    }

    // Функция запуска таймера
    private func startTimer() {
        gameTimer?.invalidate()
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            gameTime += 1
        }
    }

    // Функция остановки таймера
    private func stopTimer() {
        gameTimer?.invalidate()
        gameTimer = nil
    }

    // Функция начала новой игры
    private func startNewGame() {
        stopTimer()
        startTimer()
    }

    // Функция выхода в главное меню
    private func exitToMainMenu() {
        stopTimer()
    }
}




//#Preview {
//    GameScreen(len_area: 3)
//}
