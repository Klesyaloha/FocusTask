//
//  AddTaskView.swift
//  FocusTask
//
//  Created by Klesya Loha on 14/09/2024.
//

import SwiftUI

struct AddTaskView: View {
    @EnvironmentObject var myAppData: MyAppData  // Utilisez @EnvironmentObject pour accéder aux données
    @State var task : Task
    @State var colorTheme : Color = .black
    @State private var selectedCategory = Category(name: "", colorTheme: .gray, symbolName: "")
    @State var categoryIsSelected = false
    @State var substaskTitle = ""
    @FocusState private var isTextFieldFocused: Bool // Gestion du focus sur le TextField
    @Binding var addViewPresented : Bool
    
    var body: some View {
        NavigationStack {
            Form {
                
                VStack(alignment: .leading) {
                    Text("Titre".uppercased())
                        .font(.system(size: 11))
                        .fontWeight(.bold)
                    TextField(text: $task.title, label: {
                        Text("Cliquez pour modifier")
                    })
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Sous-tâches".uppercased())
                        .font(.system(size: 11))
                        .fontWeight(.bold)
                    
                    VStack(alignment: .leading, spacing: 3) {
                        List(task.subtasks) { subtask in
                            HStack {
                                Image(systemName: "circle")
                                    .font(.system(size: 12))
                                .foregroundStyle(.black)
                                
                                Text(subtask.title)
                                    .font(.system(size: 12))
                                    .fontWeight(.medium)
                            }
                        }
                        
                        HStack {
                            Image(systemName: "circle")
                                .font(.system(size: 12))
                                .foregroundStyle(.black)
                            TextField(text: $substaskTitle, label: {
                                Text("Ajouter une tâche")
                            })
                            
                            .focused($isTextFieldFocused) // Lie l'état du focus au TextField
                            .onSubmit {
                                if !substaskTitle.isEmpty { // Vérifie si l'entrée n'est pas vide
                                    task.subtasks.append(Subtask(id: (task.subtasks.last?.id ?? 0) + 1, title: substaskTitle, isFinish: false)) // Ajoute l'élément à la liste
                                    substaskTitle = "" // Réinitialise le TextField
                                    isTextFieldFocused = true // Met le focus sur le TextField à l'apparition de la vue
                                }
                            }
                        }
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Catégorie".uppercased())
                        .font(.system(size: 11))
                        .fontWeight(.bold)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(myAppData.categories) { category in
                                Button(action: {
                                    task.categorie = category
                                }) {
                                    HStack(spacing: 2) {
                                        Image(systemName: category.symbolName)
                                            .font(.system(size: 17))
                                        Text(category.name)
                                            .fontWeight(.regular)
                                    }
                                }
                                .frame(width: 60.0, height: 6.0)
                                .font(.system(size: 13))
                                .padding()
                                .foregroundStyle(category.colorTheme)
                                .background(category.colorTheme.opacity(0.5))
                                .cornerRadius(17)
                                .opacity(task.categorie.id == category.id ? 1 : 0.3)
                            }
                        }
                    }
                    
                }
                
//                ColorPicker(selection: Binding(
//                    get: {
//                        if let index = myAppData.categories.firstIndex(where: { $0.id == task.categorie.id }) {
//                            return myAppData.categories[index].colorTheme // Assurez-vous que chaque catégorie a une couleur
//                        } else {
//                            return Color.blue // Valeur par défaut si la catégorie n'est pas trouvée
//                        }
//                    },
//                    set: { newColor in
//                        if let index = myAppData.categories.firstIndex(where: { $0.id == task.categorie.id }) {
//                            myAppData.categories[index].colorTheme = newColor
//                        }
//                    }
////                    projectedValue: $task.categorie.colorTheme
//                )
//                            , label: {
//                    Text("Couleur du thème".uppercased())
//                        .font(.system(size: 11))
//                        .fontWeight(.bold)
//                    
//                })
                
                DatePicker(selection: $task.deadline, label: {
                    Text("Date d'échéance".uppercased())
                        .font(.system(size: 10))
                        .fontWeight(.bold)
                })
                .environment(\.locale, Locale(identifier: "fr_FR")) // Définir la langue ici
                
                Text(formatDate(date: task.deadline))
            }
            .toolbar(content: {
                Button(action: {
                    print(formatDate(date: task.deadline))
                    addViewPresented = false
                    myAppData.tasks.append(task)
                }, label: {
                    Text("Save")
                })
            })
            .navigationTitle("Ajouter une tâche")
        }
    }
    
    func formatDate(date: Date) -> String {
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
    AddTaskView(task: Task(id: UUID(), title: "", subtasks: [], time: Time(hours: 0, minutes: 0, secondes: 0), deadline: Date(), isFinish: false, isImportant: false, isInDetails: false, categorie: Category(name: "", colorTheme: .gray, symbolName: "")), addViewPresented: .constant(true))
        .environmentObject(MyAppData())  // Ajoutez un environnement pour les prévisualisations
}
