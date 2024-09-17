//
//  DetailsTaskView.swift
//  FocusTask
//
//  Created by Klesya Loha on 17/09/2024.
//

import SwiftUI

struct DetailsTaskView: View {
    @EnvironmentObject var myAppData: MyAppData  // Utilisez @EnvironmentObject pour accéder aux données
    
    var body: some View {
        Text("Salut")
            .padding()
        VStack(spacing: 8) {
            
            Text(myAppData.tasks[0].title)
                .font(.system(size: 20))
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 8) {
                Spacer()
                
                Button(action: {
                    if let index = myAppData.tasks.firstIndex(where: { $0.id == myAppData.tasks[0].id }) {
                        myAppData.tasks[index].isFinish.toggle()
                    }
                }, label: {
                    Image(systemName: myAppData.tasks[0].isFinish ? "checkmark.square.fill" : "square")
                        .foregroundColor(.black)
                        .padding(.leading, 16)
                        .font(.system(size: 27))
                })
                VStack(alignment: .leading, spacing: 5) {
                    
                    VStack(alignment: .leading, spacing: 5) {
                        ForEach(Array(myAppData.tasks[0].subtasks.enumerated()), id: \.element.id) { index, subtask in
                            HStack(spacing: 4){
                                Button(action: {
                                    // Recherche de l'index de la tâche dans myAppData
                                    if let taskIndex = myAppData.tasks.firstIndex(where: { $0.id == myAppData.tasks[0].id }) {
                                        // Accéder à la sous-tâche via l'index et la modifier
                                        var updatedTask = myAppData.tasks[taskIndex]
                                        updatedTask.subtasks[index].isFinish.toggle()
                                        myAppData.tasks[taskIndex] = updatedTask
                                    }
                                }, label: {
                                    Image(systemName: subtask.isFinish ? "checkmark.circle.fill" : "circle")
                                        .font(.system(size: 12))
                                        .foregroundStyle(.black)
                                })
                                
                                
                                
                                Text(subtask.title)
                                    .font(.system(size: 9))
                                    .fontWeight(.medium)
                            }
                        }
                        .padding(.leading, 8.0)
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        Circle()
                            .frame(width: 14.0, height: 14.0)
                            .foregroundStyle(myAppData.tasks[0].categorie.colorTheme)
                        
                        ZStack {
                            // Cercle d'arrière-plan
                            Circle()
                            
                                .stroke(lineWidth: 3.5)
                                .opacity(0.3)
                                .foregroundColor(Color.gray)
                            
                            // Cercle de progression
                            Circle()
                                .trim(from: 0.0, to: CGFloat(myAppData.tasks[0].progress))  // Le "to:" dépend de la progression
                                .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                                .foregroundColor(Color.green)  // Change la couleur si besoin
                                .rotationEffect(Angle(degrees: -90))  // Pour commencer à 12h au lieu de 3h
                            
                            // Texte au centre affichant le pourcentage
                            Text(String(format: "%.0f%%", myAppData.tasks[0].progress * 100))
                                .font(.system(size: 5))
                                .bold()
                        }
                        .frame(width: 18)
                        
                        Text(formattedDate(from: myAppData.tasks[0].deadline))
                            .font(.system(size: 10))
                            .fontWeight(.semibold)
                        
                    }
                    .foregroundColor(.gray)
                }
                
                Image(systemName: "exclamationmark.circle.fill")
                    .font(.system(size: 27))
                    .foregroundColor(myAppData.tasks[0].categorie.colorTheme)
                    .padding(.trailing, 16)
                
                Spacer()
            }
            
        }
        .padding(.vertical)
        .background(.white)
        .frame(width: 366)
        .cornerRadius(23)
        .shadow(radius: 10)
        .environmentObject(MyAppData())// Ajoutez un environnement pour les prévisualisations
    }
    
    // Fonction pour formater la date en fonction de sa distance par rapport à aujourd'hui
    func formattedDate(from date: Date) -> String {
        let calendar = Calendar.current
        let today = Date() // La date actuelle
        
        // Composants de date
        let dayDifference = calendar.dateComponents([.day], from: today, to: date).day ?? 0
        let weekDifference = calendar.dateComponents([.weekOfYear], from: today, to: date).weekOfYear ?? 0
        
        // Formatter pour l'heure
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short // Format court pour l'heure (ex: 14:30)
        
        // Récupère l'heure pour l'affichage final
        let timeString = timeFormatter.string(from: date)
        
        // Cas 1 : La date est dans moins d'une semaine
        if dayDifference <= 7 {
            if dayDifference == 0 {
                return "| Aujourd'hui à \(timeString) |"
            } else if dayDifference == 1 {
                return "| Demain à \(timeString) |"
            } else {
                return "| Dans \(dayDifference) jours à \(timeString) |"
            }
        }
        
        // Cas 2 : La date est dans moins d'un mois (4 semaines)
        else if weekDifference < 4 {
            return "| Dans \(weekDifference) semaine\(weekDifference > 1 ? "s" : "") à \(timeString) |"
        }
        
        // Cas 3 : Date au-delà d'un mois -> format par défaut (jour, mois, heure)
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateFormat = "| EEEE d MMMM 'à' HH:mm |"  // Utilise HH:mm pour le bon format de l'heure
        return formatter.string(from: date)
    }
}

#Preview {
    DetailsTaskView()
//    DetailsTaskView(task:
//                        Task(
//                            id: UUID(),
//                            title: "Faire les courses pour la poterie",
//                            subtasks: [
//                                Subtask(id: 1, title: "Acheter de l'argile", isFinish: false),
//                                Subtask(id: 2, title: "Préparer le four", isFinish: false),
//                                Subtask(id: 3, title: "Rassembler les outils", isFinish: false),
//                                Subtask(id: 4, title: "Acheter de l'argile", isFinish: false),
//                                Subtask(id: 5, title: "Préparer le four", isFinish: false),
//                                Subtask(id: 6, title: "Rassembler les outils", isFinish: false)
//                            ],
//                            time: Time(hours: 2, minutes: 30, secondes: 0),
//                            deadline: Date(),
//                            isFinish: false,
//                            isImportant: true,
//                            categorie: Category(name: "Work", colorTheme: .red, symbolName: "building.2.crop.circle.fill") // Work
//                        ))
    .environmentObject(MyAppData())
}
