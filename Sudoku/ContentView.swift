//
//  ContentView.swift
//  Sudoku
//
//  Created by Данил on 27.04.2024.
//

import SwiftUI

struct ContentView: View {
     var grid = Grid(len_area: 3)
     
     var body: some View {
          MenuScreen()
//          GameScreen(len_area: grid.len_area)
     }
     
}

#Preview {
    ContentView()
}
