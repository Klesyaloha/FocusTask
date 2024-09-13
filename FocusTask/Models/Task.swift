//
//  Tâche.swift
//  FocusTask
//
//  Created by Klesya Loha on 12/09/2024.
//

import Foundation

struct Task : Identifiable {
    let id : UUID
    let title: String
    let subtasks: [Subtask]
    let time: Time
    var progress: Int
    let deadline: Date
    var isFinish: Bool
    let categories: [Category]
}
