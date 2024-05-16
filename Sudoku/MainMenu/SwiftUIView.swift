//
//  SwiftUIView.swift
//  Sudoku
//
//  Created by Данил on 04.05.2024.
//

import SwiftUI

let cards: [[String]] = [
    ["house", "Главная"],
    ["rectangle.3.group", "Правила"],
    ["align.vertical.center", "Статистика"]
]
    

enum Tab: String, CaseIterable {
    case house
    case tray
    case clipboard
    
}


struct CastomTabBar: View {
    @Binding var selectedTab: Tab
    private var fillImage: String {
        selectedTab.rawValue + ".fill"
    }
    
    var body: some View {
        VStack() {
            HStack() {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Spacer()
                    Image(systemName: selectedTab == tab ? fillImage : tab.rawValue)
                        .scaleEffect(selectedTab == tab ? 1.25 : 1.0)
                        .foregroundColor(selectedTab == tab ? .blue : .gray)
                        .font(.system(size: 22))
                        .onTapGesture {
                            withAnimation(.easeIn(duration: 0.1)) {
                                selectedTab = tab
                            }
                        }
                    Spacer()
                }
            }
            .frame(width: nil, height: 60)
            .background(.thinMaterial)
            .cornerRadius(10)
            .padding()
        }
    }
}

#Preview {
    CastomTabBar(selectedTab: .constant(.house))
}
