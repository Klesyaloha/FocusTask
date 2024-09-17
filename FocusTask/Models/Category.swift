//
//  Category.swift
//  FocusTask
//
//  Created by Klesya Loha on 12/09/2024.
//

import SwiftUI

class Category: Identifiable, ObservableObject, Equatable {
    var id = UUID()
    var name: String
    @Published var colorTheme: Color
    var symbolName: String

    
    init(){
        self.name = "Invalid"
        self.colorTheme = .black
        self.symbolName = ""
    }
    init(name: String, colorTheme: Color, symbolName: String) {
        self.name = name
        self.colorTheme = colorTheme
        self.symbolName = symbolName
    }
    
    // Implémentation de l'égalité pour comparer les catégories
    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.id == rhs.id
    }
}
