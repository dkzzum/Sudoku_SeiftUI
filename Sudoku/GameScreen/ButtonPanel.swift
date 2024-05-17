//
//  ButtonPanel.swift
//  Sudoku
//
//  Created by Данил on 28.04.2024.
//

import SwiftUI

struct NumberPicker: View {
    let cards: [CardAndText] = [
        CardAndText(card: "arrowshape.turn.up.backward.fill", text: "Отмена"),
        CardAndText(card: "eraser.fill", text: "Стереть"),
        CardAndText(card: "pencil", text: "Черновик"),
        CardAndText(card: "lightbulb.fill", text: "Подсказка")
    ]

    @Binding var selectedNumber: Int?
    @Binding var lastTappedIndex: Int?
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

    @State private var actionStack: [Action] = []
    @State private var activeSquareIndices: Set<Int> = []

    var body: some View {
        VStack(spacing: 10.0) {
            ShowPanel(cards: cards, eraseAction: eraseNumber, undoAction: undoLastAction)
                .frame(height: 40)
            ShowNum(onTap: placeNumber, placedNumbersCount: placedNumbersCount)
                .frame(height: 40)
        }
        .padding(10)
        .background(Color(red: 0.965, green: 0.973, blue: 0.994))
        .cornerRadius(10)
    }

    func stopTimer() {
        gameTimer?.invalidate()
        gameTimer = nil
    }

    private func placeNumber(_ number: Int) {
        if let currentIndex = lastTappedIndex {
            if cellStatus[currentIndex] == true { return }

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

    private func undoLastAction() {
        guard let lastAction = actionStack.popLast() else { return }

        lastTappedIndex = lastAction.index

        switch lastAction.type {
        case .place:
            if let previousValue = lastAction.previousValue {
                numbersInCells[lastAction.index] = previousValue
                placedNumbersCount[previousValue, default: 0] += 1
                placedNumbersCount[lastAction.index, default: 1] -= 1
            } else {
                numbersInCells.removeValue(forKey: lastAction.index)
                placedNumbersCount[lastAction.index, default: 1] -= 1
            }
            cellColors[lastAction.index] = Color.white
        case .erase:
            if let previousValue = lastAction.previousValue {
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

struct Action {
    enum ActionType {
        case place
        case erase
    }

    let type: ActionType
    let index: Int
    let previousValue: Int?
}

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
                } else {
                    Text("")
                        .frame(width: 22.0, height: 37.0)
                }
            }
            .frame(width: 22.0)
        }
    }
}

struct CardAndText: Identifiable {
    let card: String
    let text: String
    let id: UUID = UUID()
}



//#Preview {
//    NumberPicker()
//}
