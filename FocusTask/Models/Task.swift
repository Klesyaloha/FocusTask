//
//  Tâche.swift
//  FocusTask
//
//  Created by Klesya Loha on 12/09/2024.
//

import Foundation

struct Task : Identifiable {
    let id : UUID
    var title: String
    var subtasks: [Subtask]
    var time: Time
    var progress: Double {  // Calcul dynamique de la progression
        if subtasks.isEmpty { return 0.0 }  // Evite la division par 0
        let completedCount = subtasks.filter { $0.isFinish }.count
        return Double(completedCount) / Double(subtasks.count)
    }
    var deadline: Date
    var isFinish: Bool
    var isImportant: Bool
    var isInDetails: Bool
    var categorie: Category
    
    init(id: UUID, title: String, subtasks: [Subtask], time: Time, deadline: Date, isFinish: Bool, isImportant: Bool, isInDetails: Bool, categorie: Category) {
        self.id = id
        self.title = title
        self.subtasks = subtasks
        self.time = time
        self.deadline = deadline
        self.isFinish = isFinish
        self.isImportant = isImportant
        self.isInDetails = isInDetails
        self.categorie = categorie
    }
}

