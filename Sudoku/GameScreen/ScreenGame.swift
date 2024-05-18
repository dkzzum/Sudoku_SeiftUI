//
//  ScreenGame.swift
//  Sudoku
//
//  Created by Данил on 01.05.2024.
//

import SwiftUI

struct GameScreen: View {
    let len_area: Int
    @State private var selectedNumber: Int?
    @State private var lastTappedIndex: Int?
    @Binding var numbersInCells: [Int: Int]
    @Binding var cellStatus: [Int: Bool]
    @Binding var cellColors: [Int: Color]
    @Binding var allNumbersInCells: [Int: Int]
    @Binding var errorCount: Int
    @Binding var showEndGameAlert: Bool
    @Binding var showCompletionAlert: Bool
    @Binding var gameTime: TimeInterval
    @Binding var gameTimer: Timer?
    @Binding var highlightedNumber: Int?
    @Binding var placedNumbersCount: [Int: Int]

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(uiImage: #imageLiteral(resourceName: "screen.jpg"))
                    .resizable(capInsets: EdgeInsets(), resizingMode: .tile)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .center, spacing: 30) {
                    TopPanel()
                        .padding(.bottom, 30.0)
                        .padding(.top, 30.0)
                    ContainerGrid(len_area: len_area, selectedNumber: $selectedNumber, lastTappedIndex: $lastTappedIndex, numbersInCells: $numbersInCells, cellStatus: $cellStatus, cellColors: $cellColors, allNumbersInCells: $allNumbersInCells, errorCount: $errorCount, showEndGameAlert: $showEndGameAlert, highlightedNumber: $highlightedNumber, gameTimer: $gameTimer, placedNumbersCount: $placedNumbersCount)
                        .padding(.top, 30.0)
                        .padding(.bottom, 20.0) // Уменьшение отступа снизу
                        .frame(width: geometry.size.width * 0.9, height: geometry.size.width * 0.9)
                    NumberPicker(selectedNumber: $selectedNumber, lastTappedIndex: $lastTappedIndex, numbersInCells: $numbersInCells, cellStatus: $cellStatus, cellColors: $cellColors, allNumbersInCells: $allNumbersInCells, errorCount: $errorCount, showEndGameAlert: $showEndGameAlert, showCompletionAlert: $showCompletionAlert, gameTime: $gameTime, gameTimer: $gameTimer, highlightedNumber: $highlightedNumber, placedNumbersCount: $placedNumbersCount)
                        .padding(.top, 10.0) // Уменьшение верхнего отступа
                        .frame(width: geometry.size.width * 0.9, height: 100) // Установка фиксированной высоты для нижней панели
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
                    startTimer()
                }
                .onDisappear {
                    stopTimer()
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

    private func startTimer() {
        gameTimer?.invalidate()
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            gameTime += 1
        }
    }

    private func stopTimer() {
        gameTimer?.invalidate()
        gameTimer = nil
    }

    private func startNewGame() {
        stopTimer()
        startTimer()
    }

    private func exitToMainMenu() {
        stopTimer()
    }
}




//#Preview {
//    GameScreen(len_area: 3)
//}
