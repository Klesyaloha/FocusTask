//
//  CategoryViewModel.swift
//  FocusTask
//
//  Created by Klesya Loha on 13/09/2024.
//

import Foundation

class MyAppData: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var categories: [Category] = []
    
    init() {
        // Initialisation des catégories
        self.categories = [
            Category(name: "All", colorTheme: .gray, symbolName: "circle.fill"),
            Category(name: "Work", colorTheme: .red, symbolName: "building.2.crop.circle.fill"),
            Category(name: "Travel", colorTheme: .blue, symbolName: "airplane.circle.fill"),
            Category(name: "Home", colorTheme: .orange, symbolName: "house.circle.fill"),
            Category(name: "Health", colorTheme: .green, symbolName: "heart.circle.fill")
        ]
        
        // Initialiser les tâches après avoir initialisé les catégories
        self.initializeTasks()
    }
    
    private func initializeTasks() {
        self.tasks = [
            Task(
                title: "Faire les courses pour la poterie",
                subtasks: [
                    Subtask(id: 1, title: "Acheter de l'argile", isFinish: false),
                    Subtask(id: 2, title: "Préparer le four", isFinish: false),
                    Subtask(id: 3, title: "Rassembler les outils", isFinish: false),
                    Subtask(id: 4, title: "Acheter de l'argile", isFinish: false),
                    Subtask(id: 5, title: "Préparer le four", isFinish: false),
                    Subtask(id: 6, title: "Rassembler les outils", isFinish: false)
                ],
                time: Time(hours: 2, minutes: 30, secondes: 0),
                deadline: Date(),
                isFinish: false,
                isImportant: true,
                isInDetails: false,
                categorie: categories[1], // Work
                position: CGPoint()
            ),
            Task(
                title: "Planifier les vacances d'été",
                subtasks: [
                    Subtask(id: 1, title: "Réserver les billets d'avion", isFinish: false),
                    Subtask(id: 2, title: "Trouver un hôtel", isFinish: false),
                    Subtask(id: 3, title: "Préparer l'itinéraire", isFinish: false)
                ],
                time: Time(hours: 1, minutes: 15, secondes: 0),
                deadline: Date().addingTimeInterval(60 * 60 * 24 * 30), // 30 jours plus tard
                isFinish: false, 
                isImportant: false,
                isInDetails: false,
                categorie: categories[2], // Travel
                position: CGPoint()
            ),
            Task(
                title: "Nettoyer la maison",
                subtasks: [
                    Subtask(id: 1, title: "Passer l'aspirateur", isFinish: false),
                    Subtask(id: 2, title: "Laver les vitres", isFinish: false),
                    Subtask(id: 3, title: "Dépoussiérer les meubles", isFinish: false)
                ],
                time: Time(hours: 1, minutes: 0, secondes: 0),
                deadline: Date().addingTimeInterval(60 * 60 * 24 * 7), // 7 jours plus tard
                isFinish: false, 
                isImportant: false,
                isInDetails: false,
                categorie: categories[3], // Home
                position: CGPoint()
            ),
            Task(
                title: "Préparer la présentation du projet",
                subtasks: [
                    Subtask(id: 1, title: "Créer les slides", isFinish: false),
                    Subtask(id: 2, title: "Réviser les notes", isFinish: false),
                    Subtask(id: 3, title: "Faire une répétition", isFinish: false)
                ],
                time: Time(hours: 3, minutes: 0, secondes: 0),
                deadline: Date().addingTimeInterval(60 * 60 * 24 * 3), // 3 jours plus tard
                isFinish: false, 
                isImportant: false,
                isInDetails: false,
                categorie: categories[1], // Work
                position: CGPoint()
            ),
            Task(
                title: "Réaliser un bilan de santé",
                subtasks: [
                    Subtask(id: 1, title: "Faire une prise de sang", isFinish: false),
                    Subtask(id: 2, title: "Passer chez le médecin", isFinish: false),
                    Subtask(id: 3, title: "Prendre rendez-vous chez le dentiste", isFinish: false)
                ],
                time: Time(hours: 1, minutes: 45, secondes: 0),
                deadline: Date().addingTimeInterval(60 * 60 * 24 * 14), // 14 jours plus tard
                isFinish: false,
                isImportant: true,
                isInDetails: false,
                categorie: categories[4], // Health
                position: CGPoint()
            )
        ]
    }
    
    // Fonction pour supprimer une tâche en fonction de son ID
    func deleteTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks.remove(at: index)
        }
    }
}
