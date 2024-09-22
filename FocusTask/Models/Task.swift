//
//  Tâche.swift
//  FocusTask
//
//  Created by Klesya Loha on 12/09/2024.
//

import Foundation

struct Task : Identifiable{
    static var number = 0
    let id = number + 1
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
    var position: CGPoint
    
    init(){
        self.title = ""
        self.subtasks = []
        self.time = Time(hours: 0, minutes: 0, secondes: 0)
        self.deadline = Date()
        self.isFinish = false
        self.isImportant = false
        self.isInDetails = false
        self.categorie = Category()
        self.position = CGPoint()
    }
    
    init(title: String, subtasks: [Subtask], time: Time, deadline: Date, isFinish: Bool, isImportant: Bool, isInDetails: Bool, categorie: Category, position: CGPoint) {
        Task.number += 1
        self.title = title
        self.subtasks = subtasks
        self.time = time
        self.deadline = deadline
        self.isFinish = isFinish
        self.isImportant = isImportant
        self.isInDetails = isInDetails
        self.categorie = categorie
        self.position = CGPoint()
    }
}

