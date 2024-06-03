//
//  EndScreen.swift
//  Sudoku
//
//  Created by Данил on 17.05.2024.
//

import SwiftUI

// Структура для представления вида окончания игры
struct EndGameView: View {
    @Binding var isVisible: Bool

    var len_area: Int = 3
    var difficultyLevel: String
    @State private var isShowingDetailsView = false
    @State private var numbersInCells: [Int: Int] = [:]
    @State private var cellStatus: [Int: Bool] = [:]
    @State private var cellColors: [Int: Color] = [:]
    @State private var allNumbersInCells: [Int: Int] = [:]
    @State private var errorCount: Int = 0
    @State private var showEndGameAlert = false
    @State private var showCompletionAlert = false
    @State private var gameTime: TimeInterval = 0
    @State private var gameTimer: Timer?
    @State private var highlightedNumber: Int? = nil
    @State private var placedNumbersCount: [Int: Int] = [:]
    @State private var activeSquareIndices: Set<Int> = []

    var body: some View {
        VStack {
            Text("Игра окончена")
                .font(.title)
                .padding()

            NavigationLink {
                GameScreen(len_area: len_area, numbersInCells: $numbersInCells,
                           cellStatus: $cellStatus, cellColors: $cellColors,
                           allNumbersInCells: $allNumbersInCells, errorCount: $errorCount,
                           showEndGameAlert: $showEndGameAlert, showCompletionAlert: $showCompletionAlert,
                           gameTime: $gameTime, gameTimer: $gameTimer,
                           highlightedNumber: $highlightedNumber, placedNumbersCount: $placedNumbersCount, activeSquareIndices: $activeSquareIndices, difficultyLevel: .constant(difficultyLevel))
            } label: {
                Text("Начать новую игру")
                    .font(.callout)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .frame(width: 250, height: 30)
                    .background(Color(red: 0.192, green: 0.477, blue: 0.907))
                    .cornerRadius(50)
            }
            .navigationBarHidden(true)

            NavigationLink {
                MenuScreen()
            } label: {
                Text("Вернуться на главный экран")
                    .font(.callout)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .frame(width: 250, height: 30)
                    .background(Color(red: 0.192, green: 0.477, blue: 0.907))
                    .cornerRadius(50)
            }
        }
        .frame(width: 350, height: 250)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 20)
    }
}


// Структура для представления уведомления о завершении игры
struct CompletionAlertView: View {
    @Binding var isVisible: Bool
    var gameTime: TimeInterval
    var difficultyLevel: String

    var len_area: Int = 3
    @State private var isShowingDetailsView = false
    @State private var numbersInCells: [Int: Int] = [:]
    @State private var cellStatus: [Int: Bool] = [:]
    @State private var cellColors: [Int: Color] = [:]
    @State private var allNumbersInCells: [Int: Int] = [:]
    @State private var errorCount: Int = 0
    @State private var showEndGameAlert = false
    @State private var showCompletionAlert = false
    @State private var newGameTime: TimeInterval = 0
    @State private var gameTimer: Timer?
    @State private var highlightedNumber: Int? = nil
    @State private var placedNumbersCount: [Int: Int] = [:]

    var body: some View {
        VStack {
            Text("Поздравляем!")
                .font(.title)
                .padding()
            Text("Вы успешно завершили игру.")
                .padding()
            Text("Время: \(formatTime(gameTime))")
            Text("Сложность: \(difficultyLevel)")
                .padding()

            NavigationLink {
//                GameScreen(len_area: len_area, numbersInCells: $numbersInCells,
//                           cellStatus: $cellStatus, cellColors: $cellColors,
//                           allNumbersInCells: $allNumbersInCells, errorCount: $errorCount,
//                           showEndGameAlert: $showEndGameAlert, showCompletionAlert: $showCompletionAlert,
//                           gameTime: $newGameTime, gameTimer: $gameTimer,
//                           highlightedNumber: $highlightedNumber, placedNumbersCount: $placedNumbersCount)
            } label: {
                Text("Начать новую игру")
                    .font(.callout)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .frame(width: 250, height: 30)
                    .background(Color(red: 0.192, green: 0.477, blue: 0.907))
                    .cornerRadius(50)
            }
            .navigationBarHidden(true)

            NavigationLink {
                MenuScreen()
            } label: {
                Text("Вернуться на главный экран")
                    .font(.callout)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .frame(width: 250, height: 30)
                    .background(Color(red: 0.192, green: 0.477, blue: 0.907))
                    .cornerRadius(50)
            }
        }
        .frame(width: 350, height: 350)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 20)
    }

    // Функция форматирования времени
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
