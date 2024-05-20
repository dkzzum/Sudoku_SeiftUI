//
//  MenuScreen.swift
//  Sudoku
//
//  Created by Данил on 01.05.2024.
//

import SwiftUI

struct MenuScreen: View {
    let cards: [[String]] = [
        ["house.fill", "Главная"],
        ["rectangle.3.group.fill", "Правила"],
        ["align.vertical.center.fill", "Статистика"]
    ]
    @State private var selectionTab: Tab = .house

    var body: some View {
        TabView(selection: $selectionTab) {
            BigCenterButton()
                .tabItem {
                    Image(systemName: cards[0][0])
                    Text(cards[0][1])
                }
            RulesScreen()
                .tabItem {
                    Image(systemName: cards[1][0])
                    Text(cards[1][1])
                }
            Text("Статистика")
                .tabItem {
                    Image(systemName: cards[2][0])
                    Text(cards[2][1])
                }
        }
            .navigationBarHidden(true)
//            .shadow(color: Color.black.opacity(0.15), radius: 1, x: 0, y: -3)

            
    }
}

struct TextAndText: Identifiable {
    let title: Bool
    let text: String
    let num: Int
    let id: UUID = UUID()
}


// Структура, представляющая большую центральную кнопку, которая переходит к экрану игры
struct BigCenterButton: View {
    var len_area: Int = 3 // Размер игрового поля (например, 3x3 для Судоку)
    @State private var isShowingDetailsView = false // Состояние для отображения вида с деталями
    @State private var numbersInCells: [Int: Int] = [:] // Словарь для хранения чисел в ячейках
    @State private var cellStatus: [Int: Bool] = [:] // Статус ячеек (true - заполнено автоматически, false - заполнено пользователем)
    @State private var cellColors: [Int: Color] = [:] // Цвета ячеек
    @State private var allNumbersInCells: [Int: Int] = [:] // Все числа в ячейках (для проверки правильности)
    @State private var errorCount: Int = 0 // Счетчик ошибок
    @State private var showEndGameAlert = false // Флаг для отображения уведомления об окончании игры
    @State private var showCompletionAlert = false // Флаг для отображения уведомления о завершении игры
    @State private var gameTime: TimeInterval = 0 // Время игры
    @State private var gameTimer: Timer? // Таймер игры
    @State private var highlightedNumber: Int? = nil // Выделенное число
    @State private var placedNumbersCount: [Int: Int] = [:] // Количество размещенных чисел

    var body: some View {
        NavigationView {
            NavigationLink {
                // Переход на экран игры с передачей всех необходимых данных
                GameScreen(len_area: len_area, numbersInCells: $numbersInCells, cellStatus: $cellStatus, cellColors: $cellColors, allNumbersInCells: $allNumbersInCells, errorCount: $errorCount, showEndGameAlert: $showEndGameAlert, showCompletionAlert: $showCompletionAlert, gameTime: $gameTime, gameTimer: $gameTimer, highlightedNumber: $highlightedNumber, placedNumbersCount: $placedNumbersCount)
            } label: {
                Text("Начать игру")
                    .font(.title)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .frame(width: 300.0, height: 50.0)
                    .background(Color(red: 0.192, green: 0.477, blue: 0.907))
                    .cornerRadius(50)
            }
        }
    }
}



struct RulesScreen: View {
    var rules: [String] = ["Правила игры Судоку", "Используйте цифры от 1 до 9", "Судоку играется на игровом поле, состоящем из 9 на 9 клеток, всего 81 клетка. Внутри игрового поля находятся 9 \"квадратов\" (состоящих из 3 x 3 клеток). Каждая горизонтальная строка, вертикальный столбец и квадрат (9 клеток каждый) должны заполняться цифрами 1-9, не повторяя никаких чисел в строке, столбце или квадрате. Это звучит сложно? Как видно из изображения ниже, каждое игровое поле Судоку имеет несколько клеток, которые уже заполнены. Чем больше клеточек изначально заполнено, тем легче игра. Чем меньше клеток изначально заполнено, тем труднее игра.", "Не повторяйте никакие числа", "Как вы можете видеть, в верхнем левом квадрате (обведен синим) уже заполнены 7 из 9 клеток. Единственные числа, которые отсутствуют в этом квадрате, это числа 5 и 6. Видя, какие числа отсутствуют в каждом квадрате, строке или столбце, мы можем использовать процесс исключения и дедуктивное мышление, чтобы решить, какие числа должны находиться в каждой клетке.\n\nНапример, в верхнем левом квадрате мы знаем, что для завершения квадрата нужно добавить числа 5 и 6, но глядя на соседние строки и квадраты мы пока не можем четко определить, какое число добавить в какую клетку. Это означает, что теперь мы должны пока пропустить верхний левый квадрат и вместо этого попытаться заполнить пробелы в некоторых других местах игрового поля.", "Не нужно гадать", "Судоку – это логическая игра, поэтому не нужно гадать. Если вы не знаете, какое число поставить в определенную клетку, продолжайте сканировать другие области игрового поля, пока не увидите возможность вставить нужное число. Но не пытайтесь \"форсировать\" что-либо - Судоку вознаграждает за терпение, понимание и решение различных комбинаций, а не за слепое везение или угадывание.", "Используйте метод исключения", "Что мы делаем, когда используем \"метод исключения\" в игре Судоку? Вот пример. В этой сетке Судоку (показано ниже) в левом вертикальном столбце (обведен синим) отсутствуют только нескольких чисел: 1, 5 и 6.\n\nОдин из способов выяснить, какие числа можно вставить в каждую клетку - это использовать \"метод исключения\", проверяя, какие другие числа уже имеются в каждом квадрате, поскольку не допускается дублирование чисел 1-9 в каждом квадрате, строке или столбце.", "В этом случае мы можем быстро заметить, что в верхнем левом и центральном левом квадратах уже есть число 1 (числа 1 обведены красным). Это означает, что в крайнем левом столбце есть только одно место, в которое можно вставить число 1 (обведено зеленым). Вот как метод исключения работает в Судоку - вы узнаете, какие клетки свободны, какие числа отсутствуют, а затем исключаете числа, которые уже присутствуют в квадрате, столбцах и рядах. Соответственно заполняете пустые клетки отсутствующими числами.\n\n Правила Судоку относительно несложные - но игра необычайно разнообразна, с миллионами возможных комбинаций чисел и широким диапазоном уровней сложности. Но все это основано на простых принципах использования чисел 1-9, заполнении пробелов на основе дедуктивного мышления и никогда не повторяющихся чисел в каждом квадрате, строке или столбце."]
    
    var titleText: [TextAndText]
    
    init() {
        var tempTitleText = [TextAndText]()
        
        for rule in 0..<rules.count {
            let isTitle = rules[rule].count < 35
            tempTitleText.append(TextAndText(title: isTitle, text: rules[rule], num: rule))
        }
        self.titleText = tempTitleText
    }
    
    var body: some View {
        ZStack {
            Image(uiImage: #imageLiteral(resourceName: "screen.jpg"))
                .resizable(capInsets: EdgeInsets(), resizingMode: .tile)
                .edgesIgnoringSafeArea(.all)
            
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .center, spacing: 20) {
                        ForEach(titleText) { rule in
                            
                            if [4, 9].contains(rule.num) {
                                Image(uiImage: rule.num == 4 ?  #imageLiteral(resourceName: "second.jpg") : #imageLiteral(resourceName: "second.jpg"))
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 350, height: 350)
                            }
                            Text(rule.text)
                                .font(rule.num == 0 ? .largeTitle : (rule.title ? .title3 : .body))
                                .fontWeight(rule.num == 0 ? .bold : (rule.title ? .bold : .regular))
                                .multilineTextAlignment(rule.num == 0 ? .center : (rule.title ? .center : .leading))
                        }
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 50.0)
                    .padding(.horizontal, 13.0)
                }
                .frame(maxWidth: .infinity)
            }
//            .clipped(antialiased: true)
        }
    }
}
