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
    @Binding var cellStatus: [Int: Bool] // Привязка к статусу ячеек
    @State private var actionStack: [Action] = [] // Стек для хранения истории действий

    var body: some View {
        VStack(spacing: 35.0) {
            ShowPanel(cards: cards, eraseAction: eraseNumber, undoAction: undoLastAction)
            ShowNum(onTap: { number in
                if let currentIndex = lastTappedIndex {
                    // Проверяем, можно ли изменить число в ячейке
                    if cellStatus[currentIndex] == true { return } // Если ячейка заполнена автоматически, ничего не делаем

                    // Сохраняем текущее состояние для отмены
                    let previousNumber = numbersInCells[currentIndex]
                    actionStack.append(Action(type: .place, index: currentIndex, previousValue: previousNumber))
                    
                    // Обновляем число только в активной ячейке
                    numbersInCells[currentIndex] = number // Устанавливаем выбранное число в активной ячейке
                }
                selectedNumber = number // Обновляем выбранное число
            })
        }
        .frame(width: 360.0, height: 125.0)
        .background(Color(red: 0.965, green: 0.973, blue: 0.994))
        .cornerRadius(10)
    }

    // Функция для удаления числа из активной ячейки
    private func eraseNumber() {
        let cs = cellStatus
        if let currentIndex = lastTappedIndex, let previousNumber = numbersInCells[currentIndex] {
            // Проверяем, можно ли стереть число в ячейке
            if cellStatus[currentIndex] == true {
                return
            } // Если ячейка заполнена автоматически, ничего не делаем

            // Сохраняем текущее состояние для отмены
            actionStack.append(Action(type: .erase, index: currentIndex, previousValue: previousNumber))
            
            numbersInCells[currentIndex] = nil // Удаляем число из активной ячейки
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
            } else {
                numbersInCells.removeValue(forKey: lastAction.index)
            }
        case .erase:
            if let previousValue = lastAction.previousValue {
                numbersInCells[lastAction.index] = previousValue
            }
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

    var body: some View {
        HStack(spacing: 16.0) {
            ForEach(numbers, id: \.self) { number in
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
