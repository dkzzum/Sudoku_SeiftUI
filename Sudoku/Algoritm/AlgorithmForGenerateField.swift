//
//  AlgorithmForGenerateField.swift
//  Sudoku
//
//  Created by Данил on 27.04.2024.
//

import Foundation

class Grid {
    let len_area: Int // Размер области
    var gen_new_field = [[Int]](), field = [[Int]](), lst = [Int](), rows = [[Int]](), areas = [[Int]]() // Массивы для хранения данных
    
    init(len_area: Int = 3) {
        self.len_area = len_area
        self.field = self.generateBasicField(len_area: len_area) // Инициализация поля
        self.generation()
    }
    
    func generateBasicField(len_area: Int) -> [[Int]] {
        /* Генерация базового поля */
        for i in 0..<len_area*len_area {
            lst = []
            for j in 0..<len_area*len_area {
                lst.append((i * len_area + i / len_area + j) % (len_area * len_area) + 1)
            }
            gen_new_field.append(lst)
        }
        return gen_new_field
    }
    
    func generation(repetitions: Int = 15) {
        /* Генерация поля с заданным количеством итераций */
        let def = ["transposing()", "swapRowsSmall()", "swapColumnSmall()", "swapRowsArea()", "swapColumnArea()"]
        
        for _ in 0..<repetitions {
            let randomIndex = Int.random(in: 0..<def.count)
            let methodName = def[randomIndex]
            
            switch methodName {
            case "transposing()":
                self.transposing() // Транспонирование
            case "swapRowsSmall()":
                self.swapRowsSmall() // Обмен двух строк в пределах одного района
            case "swapColumnSmall()":
                self.swapColumSmall() // Обмен двух столбцов в пределах одного района
            case "swapRowsArea()":
                self.swapRowsArea() // Обмен двух районов по горизонтали
            case "swapColumnArea()":
                self.swapColumArea() // Обмен двух районов по вертикали
            default:
                break
            }
        }
    }
    
    func transposing() {
        /* Транспонирование всей таблицы — столбцы становятся строками и наоборот */
        gen_new_field = []
        for _ in 0..<self.len_area*self.len_area {
            lst = []
            for _ in 0..<self.len_area*self.len_area {
                lst.append(0)
            }
            gen_new_field.append(lst)
        }
        
        for i in 0..<self.len_area*self.len_area {
            for j in 0..<Int(pow(Double(self.len_area), 2)) {
                gen_new_field[j][i] = self.field[i][j]
            }
        }
        
        self.field = gen_new_field
    }
    
    func swapRowsSmall(iterations: Int = 10) {
        /* Обмен двух строк в пределах одного района */
        rows = []
        
        for _ in 0..<iterations {
            lst = Array(0...2)
            lst.shuffle()
            _ = lst.popLast()
            
            lst.insert(Int.random(in: 0...2), at: 0)
            
            rows.append(lst)
        }
        
        for row in rows {
            lst = self.field[row[0] * 3 + row[1]]
            
            self.field[row[0] * 3 + row[1]] = self.field[row[0] * 3 + row[2]]
            self.field[row[0] * 3 + row[2]] = lst
        }
    }
    
    func swapColumSmall(iterations: Int = 10) {
        /* Обмен двух столбцов в пределах одного района */
        self.transposing()
        self.swapRowsSmall(iterations: iterations)
        self.transposing()
    }
    
    func swapRowsArea(iterations: Int = 10){
        /* Обмен двух районов по горизонтали */
        areas = []
        
        for _ in 0..<iterations {
            lst = Array(0...2)
            lst.shuffle()
            _ = lst.popLast()
            
            areas.append(lst)
        }
        
        for area in areas {
            for i in 0..<3 {
                lst = self.field[area[0]*3+i]
                self.field[area[0]*3+i] = self.field[area[1]*3+i]
                self.field[area[1]*3+i] = lst
            }
        }
    }
    
    func swapColumArea(iterations: Int = 10){
        /* Обмен двух районов по вертикали */
        self.transposing()
        self.swapRowsArea(iterations: iterations)
        self.transposing()
    }
    
    func removeCells(difficulty: String) -> [[Int]] {
        var numberOfCellsToRemove: Int

        switch difficulty {
        case "Лёгкий":
            numberOfCellsToRemove = Int.random(in: 36...41)
        case "Средний":
            numberOfCellsToRemove = Int.random(in: 41...46)
        case "Сложный":
            numberOfCellsToRemove = Int.random(in: 46...56)
        default:
            numberOfCellsToRemove = Int.random(in: 41...46) // По умолчанию Средний
        }
        
        var userField = field  // Создаем копию текущего поля
        let totalCells = len_area * len_area * len_area * len_area
        var indices = Array(0..<totalCells).shuffled()
        
        for _ in 0..<numberOfCellsToRemove {
            let indexToRemove = indices.removeFirst()
            let row = indexToRemove / (len_area * len_area)
            let column = indexToRemove % (len_area * len_area)
            userField[row][column] = 0 // Устанавливаем значение ячейки в 0, тем самым "удаляем" ее
        }

        return userField
    }
    
    struct SudokuKey: Hashable {
        var r: Int
        var c: Int
        var n: Int
    }
}
