//
//  Subtask.swift
//  FocusTask
//
//  Created by Klesya Loha on 12/09/2024.
//

import Foundation

class Subtask : Identifiable {
    var id: Int
    var title: String
    var isFinish: Bool
    
    init(id: Int, title: String, isFinish: Bool) {
        self.id = id
        self.title = title
        self.isFinish = isFinish
    }
}
