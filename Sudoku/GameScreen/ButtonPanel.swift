//
//  ButtonPanel.swift
//  Sudoku
//
//  Created by Данил on 28.04.2024.
//

import SwiftUI

// Структура для представления панели выбора чисел
struct NumberPicker: View {
    let cards: [CardAndText] = [
        CardAndText(card: "arrowshape.turn.up.backward.fill", text: "Отмена"),
        CardAndText(card: "eraser.fill", text: "Стереть"),
        CardAndText(card: "pencil", text: "Черновик"),
        CardAndText(card: "lightbulb.fill", text: "Подсказка")
    ]

    @Binding var selectedNumber: Int? // Выбранное число
    @Binding var lastTappedIndex: Int? // Индекс последней нажатой
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
    @Binding var placedNumbersCount: [Int: Int] // Привязка к количеству

    @State private var actionStack: [Action] = []
    @State private var activeSquareIndices: Set<Int> = []

    var body: some View {
        VStack(spacing: 10.0) {
            // Панель с действиями
            ShowPanel(cards: cards, eraseAction: eraseNumber, undoAction: undoLastAction)
                .frame(height: 40)
            // Панель с числами
            ShowNum(onTap: placeNumber, placedNumbersCount: placedNumbersCount)
                .frame(height: 40)
        }
        .padding(.horizontal, 5)
        .padding(10)
        .background(Color.white)
        .cornerRadius(10)
    }

    // Функция остановки таймера
    func stopTimer() {
        gameTimer?.invalidate()
        gameTimer = nil
    }

    // Функция размещения числа в ячейке
        private func placeNumber(_ number: Int) {
            if let currentIndex = lastTappedIndex {
                // Проверка, можно ли изменить текущее значение
                if let currentNumber = numbersInCells[currentIndex], let correctNumber = allNumbersInCells[currentIndex], currentNumber == correctNumber {
                    // Если текущее значение правильное, его нельзя изменить
                    return
                }

            let previousNumber = numbersInCells[currentIndex]
            actionStack.append(Action(type: .place, index: currentIndex, previousValue: previousNumber))

            numbersInCells[currentIndex] = number

            highlightedNumber = number

            placedNumbersCount[number, default: 0] += 1
            if let prevNum = previousNumber {
                placedNumbersCount[prevNum, default: 1] -= 1
            }

            if let correctNumber = allNumbersInCells[currentIndex] {
                if number != correctNumber {
                    errorCount += 1
                    if errorCount >= 3 {
                        showEndGameAlert = true
                    }
                    cellColors[currentIndex] = Color(red: 0.996, green: 0.853, blue: 0.834)
                } else {
                    cellColors[currentIndex] = Color.white
                }
            }

            if numbersInCells.count == allNumbersInCells.count {
                let allCorrect = numbersInCells.allSatisfy { index, number in
                    allNumbersInCells[index] == number
                }
                if allCorrect {
                    showCompletionAlert = true
                    stopTimer()
                }
            }
        }
        selectedNumber = number
    }

    // Функция стирания числа из ячейки
    private func eraseNumber() {
        if let currentIndex = lastTappedIndex, let previousNumber = numbersInCells[currentIndex] {
            if cellStatus[currentIndex] == true { return }

            actionStack.append(Action(type: .erase, index: currentIndex, previousValue: previousNumber))

            numbersInCells[currentIndex] = nil
            cellColors[currentIndex] = Color.white

            placedNumbersCount[previousNumber, default: 1] -= 1

            highlightedNumber = nil
        }
    }

    // Функция отмены последнего действия
    private func undoLastAction() {
        guard let lastAction = actionStack.popLast() else { return }

        lastTappedIndex = lastAction.index

        switch lastAction.type {
        case .place:
            if let previousValue = lastAction.previousValue {
                placedNumbersCount[numbersInCells[lastAction.index]!, default: 1] -= 1
                numbersInCells[lastAction.index] = previousValue
                placedNumbersCount[previousValue, default: 0] += 1
            } else {
                placedNumbersCount[numbersInCells[lastAction.index]!, default: 1] -= 1
                numbersInCells.removeValue(forKey: lastAction.index)
            }
            cellColors[lastAction.index] = Color.white
        case .erase:
            if let previousValue = lastAction.previousValue {
                placedNumbersCount[numbersInCells[lastAction.index]!, default: 1] -= 1
                numbersInCells[lastAction.index] = previousValue
                cellColors[lastAction.index] = Color.white
            }
        }

        if let currentIndex = lastTappedIndex, let number = numbersInCells[currentIndex] {
            highlightedNumber = number
        } else {
            highlightedNumber = nil
        }
    }
}

// Структура для представления действий
struct Action {
    enum ActionType {
        case place
        case erase
    }

    let type: ActionType
    let index: Int
    let previousValue: Int?
}

// Структура для представления панели действий
struct ShowPanel: View {
    var cards: [CardAndText]
    var eraseAction: () -> Void
    var undoAction: () -> Void

    var body: some View {
        HStack(spacing: 23.0) {
            ForEach(cards, id: \.id) { card in
                VStack(alignment: .center, spacing: -2.0) {
                    Button(action: {
                        if card.text == "Стереть" {
                            eraseAction()
                        } else if card.text == "Отмена" {
                            undoAction()
                        }
                    }) {
                        Image(systemName: card.card)
                            .foregroundColor(Color(red: 0.498, green: 0.498, blue: 0.582))
                            .frame(width: 23.0, height: 23.0)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(height: 25.0)
                    .accessibilityLabel("Label")

                    Text(card.text)
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(Color(red: 0.499, green: 0.498, blue: 0.582))
                        .multilineTextAlignment(.center)
                }
                .frame(width: 60.0, height: 40.0)
                .accessibilityLabel("Label")
            }
        }
    }
}

// Структура для представления панели выбора чисел
struct ShowNum: View {
    let numbers: [Int] = Array(1...9)
    let onTap: (Int) -> Void
    let placedNumbersCount: [Int: Int]

    var body: some View {
        HStack(spacing: 16.0) {
            ForEach(numbers, id: \.self) { number in
                if placedNumbersCount[number, default: 0] <= 8 {
                    Button(action: {
                        onTap(number)
                    }) {
                        Text("\(number)")
                            .font(.largeTitle)
                            .foregroundColor(Color(red: 0.263, green: 0.367, blue: 0.658))
                            .frame(height: 37.0)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .accessibilityAddTraits([.isButton])
                    .frame(width: 22.0)
                    .accessibilityLabel("\(number)")
                    .clipped(antialiased: true)
                } else {
                    Text("")
                        .frame(width: 22.0, height: 37.0)
                }
            }
            .frame(width: 22.0)
        }
    }
}

// Структура для представления карты и текста
struct CardAndText: Identifiable {
    let card: String
    let text: String
    let id: UUID = UUID()
}


//#Preview {
//    NumberPicker()
//}
