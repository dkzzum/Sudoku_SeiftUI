//
//  ContentView.swift
//  Sudoku
//
//  Created by Данил on 27.04.2024.
//

import SwiftUI

struct ContentView: View {
     var body: some View {
          ZStack {
               Image(uiImage: #imageLiteral(resourceName: "screen.jpg"))
                   .resizable(capInsets: EdgeInsets(), resizingMode: .tile)
                   .edgesIgnoringSafeArea(.all)
               
               MenuScreen()
          }
     }
     
}

#Preview {
    ContentView()
}
