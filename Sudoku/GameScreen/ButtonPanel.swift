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
    @Binding var errorCount: Int // Привязка к счётчику ошибок
    @Binding var showEndGameAlert: Bool
    @Binding var showCompletionAlert: Bool
    @Binding var gameTime: TimeInterval
    @Binding var gameTimer: Timer?
    @Binding var highlightedNumber: Int?
    @State private var actionStack: [Action] = []
    @Binding var placedNumbersCount: [Int: Int]

    var body: some View {
        VStack(spacing: 35.0) {
            ShowPanel(cards: cards, eraseAction: eraseNumber, undoAction: undoLastAction)
            ShowNum(onTap: placeNumber, placedNumbersCount: placedNumbersCount) // Изменено
        }
        .frame(width: 360.0, height: 125.0)
        .background(Color(red: 0.965, green: 0.973, blue: 0.994))
        .cornerRadius(10)
    }
    
    func stopTimer() {
        gameTimer?.invalidate()
        gameTimer = nil
    }

    private func placeNumber(_ number: Int) {
        if let currentIndex = lastTappedIndex {
            // Проверяем, можно ли изменить число в ячейке
            if cellStatus[currentIndex] == true { return } // Если ячейка заполнена автоматически, ничего не делаем

            // Сохраняем текущее состояние для отмены
            let previousNumber = numbersInCells[currentIndex]
            actionStack.append(Action(type: .place, index: currentIndex, previousValue: previousNumber))

            // Обновляем число только в активной ячейке
            numbersInCells[currentIndex] = number // Устанавливаем выбранное число в активной ячейке

            // Обновляем выделенное число
            highlightedNumber = number

            // Увеличиваем счетчик числа
            placedNumbersCount[number, default: 0] += 1
            if let prevNum = previousNumber {
                placedNumbersCount[prevNum, default: 1] -= 1
            }

            // Проверяем на ошибки
            if let correctNumber = allNumbersInCells[currentIndex] {
                if number != correctNumber {
                    errorCount += 1 // Увеличиваем счётчик ошибок, если число неправильное
                    if errorCount >= 3 {
                        showEndGameAlert = true
                    }
                    cellColors[currentIndex] = Color(red: 0.996, green: 0.853, blue: 0.834)
                } else {
                    cellColors[currentIndex] = Color.white
                }
            }

            // Проверка завершения игры
            if numbersInCells.count == allNumbersInCells.count {
                let allCorrect = numbersInCells.allSatisfy { index, number in
                    allNumbersInCells[index] == number
                }
                if allCorrect {
                    showCompletionAlert = true
                    stopTimer() // Остановка таймера
                }
            }
        }
        selectedNumber = number
    }
    
    private func eraseNumber() {
        if let currentIndex = lastTappedIndex, let previousNumber = numbersInCells[currentIndex] {
            // Проверяем, можно ли стереть число в ячейке
            if cellStatus[currentIndex] == true { return } // Если ячейка заполнена автоматически, ничего не делаем

            // Сохраняем текущее состояние для отмены
            actionStack.append(Action(type: .erase, index: currentIndex, previousValue: previousNumber))

            numbersInCells[currentIndex] = nil // Удаляем число из активной ячейки
            cellColors[currentIndex] = Color.white // Сбрасываем цвет ячейки

            // Уменьшаем счетчик числа
            placedNumbersCount[previousNumber, default: 1] -= 1

            // Сбрасываем выделенное число
            highlightedNumber = nil
        }
    }

    // Функция для отмены последнего действия
    private func undoLastAction() {
       guard let lastAction = actionStack.popLast() else { return }

       lastTappedIndex = lastAction.index // Устанавливаем активную ячейку на ту, где произошло последнее действие

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
           cellColors[lastAction.index] = Color.white // Сбрасываем цвет ячейки при отмене действия
       case .erase:
           if let previousValue = lastAction.previousValue {
               numbersInCells[lastAction.index] = previousValue
               cellColors[lastAction.index] = Color.white // Сбрасываем цвет ячейки при отмене действия
           }
       }

       // Обновляем выделенное число
       if let currentIndex = lastTappedIndex, let number = numbersInCells[currentIndex] {
           highlightedNumber = number
       } else {
           highlightedNumber = nil
       }
   }
}


// Структура для хранения информации о действиях пользователя
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
    let numbers: [Int] = Array(1...9) // Массив чисел от 1 до 9
    let onTap: (Int) -> Void // Обработчик для выбора числа
    let placedNumbersCount: [Int: Int]

    var body: some View {
        HStack(spacing: 16.0) {
            ForEach(numbers, id: \.self) { number in
                if placedNumbersCount[number, default: 0] <= 8 { // Изменено
                    Button(action: {
                        onTap(number) // Вызываем обработчик при выборе числа
                    }) {
                        Text("\(number)") // Отображаем число
                            .font(.largeTitle) // Устанавливаем большой шрифт для числа
                            .foregroundColor(Color(red: 0.263, green: 0.367, blue: 0.658)) // Цвет числа
                            .frame(height: 37.0) // Высота кнопки
                    }
                    .buttonStyle(PlainButtonStyle()) // Убираем стиль кнопки по умолчанию
                    .accessibilityAddTraits([.isButton]) // Добавляем доступность для кнопки
                    .frame(width: 22.0) // Ширина кнопки
                    .accessibilityLabel("\(number)") // Метка для доступности
                } else {
                    // Пустое пространство для скрытого числа
                    Text("")
                        .frame(width: 22.0, height: 37.0) // Занимаем то же пространство, чтобы не было сдвига
                }
            }
            .frame(width: 22.0) // Ширина кнопки
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
