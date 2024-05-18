//
//  TopPanel.swift
//  Sudoku
//
//  Created by Данил on 01.05.2024.
//

import SwiftUI

struct TopPanel: View {
    var body: some View {
        HStack {
            BackButton()
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
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .foregroundColor(Color(red: 0.098, green: 0.098, blue: 0.098))
                .padding()
                .background(Color.white)
                .clipShape(Capsule())
                .shadow(color: Color.black.opacity(0.15), radius: 0, x: 0, y: 3)
        }
        .navigationBarHidden(true)
    }
}


