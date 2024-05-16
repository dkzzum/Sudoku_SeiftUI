//
//  TopPanel.swift
//  Sudoku
//
//  Created by Данил on 01.05.2024.
//

import SwiftUI

struct TopPanel: View {
    
    var body: some View {
        HStack() {
            BackButton()
                .background(Color(red: 0.966, green: 0.973, blue: 0.997))
                .cornerRadius(5)
            Spacer()
        }
        .padding(.leading, 10.0)
        .frame(width: 360.0)
    }
}

struct BackButton: View {
    let backButton: String = "arrowshape.backward.fill"
    
    var body: some View {
        NavigationLink {
            MenuScreen()
        } label: {
            Image(systemName: backButton)
                .resizable()
                .frame(width: 25.0, height: 25.0)
                .foregroundColor(Color(red: 0.498, green: 0.498, blue: 0.582))
            .frame(width: 35.0, height: 35.0)
        }
        .navigationBarHidden(true)
    }
}
