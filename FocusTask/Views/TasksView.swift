//
//  TasksView.swift
//  FocusTask
//
//  Created by Klesya Loha on 12/09/2024.
//

import SwiftUI

struct TasksView: View {
    @State private var search: String = ""
    @State var selectedCategory = Category(name: "All", colorTheme: .gray, symbolName: "circle.fill")
    @State private var showCompleteOnly: Bool = false
    @State private var title = "Tout"
    @State private var titleColor : Color = .black
    @State private var addViewPresented = false
    @State private var addCategory = false
    @State private var categoryTitle = ""
    @State private var categoryColor : Color = .black
    @State private var categorySymbol = "heart"
    
    let symbols = ["star.circle.fill", "heart.circle.fill", "flame.circle.fill", "bolt.circle.fill", "leaf.circle.fill", "moon.circle.fill", "pencil.circle.fill", "flag.circle.fill", "gift.circle.fill", "book.circle.fill"]

    @EnvironmentObject var myAppData: MyAppData  // Utilisez @EnvironmentObject pour accéder aux données
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.white, titleColor], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                    .opacity(0.5)
                VStack(spacing: 10) {
                    Text(title)
                        .foregroundStyle(titleColor)
                        .font(.system(size: 48))
                        .bold()
                        .padding(.horizontal)  // Ajoutez un peu de padding horizontal pour un meilleur espacement
                    
                    TextField("Search...", text: $search)
                        .padding(.horizontal, 20.0)  // Simplifiez l'utilisation de TextField
                        .textFieldStyle(.roundedBorder)
                    
                    ScrollView (.horizontal, showsIndicators: false) {
                        HStack {
                            
                            if addCategory {
                                HStack {
                                    
                                    ColorPicker("", selection: $categoryColor)
                                    
                                    Picker("Symbole", selection: $categorySymbol) {
                                        ForEach(symbols, id: \.self) { symbol in
                                            HStack {
                                                Image(systemName: symbol)
                                                    .foregroundColor(categoryColor)
//                                                Text(symbol)
                                            }
                                        }
                                    }
                                    .tint(categoryColor)
                                    .foregroundColor(categoryColor)
                                    .pickerStyle(MenuPickerStyle())
                                    
                                    TextField(text: $categoryTitle, label: {
                                        Text("Nom de la catégorie")
                                    })
                                    
                                    Button(action: {
                                        if !categoryTitle.isEmpty {
                                            myAppData.categories.append(Category(name: categoryTitle, colorTheme: categoryColor, symbolName: categorySymbol ))
                                        }
                                        addCategory.toggle()
                                    }, label: {
                                        Image(systemName: "plus")
                                    })
                                }
                                .frame(height: 6.0)
                                .font(.system(size: 13))
                                .padding()
                                .foregroundStyle(categoryColor)
                                .background(categoryColor.opacity(0.5))
                                .cornerRadius(17)
                            } else {
                                Button(action: {
                                    addCategory.toggle()
                                }, label: {
                                    Image(systemName: "plus")
                                })
                                .frame(height: 6.0)
                                .font(.system(size: 13))
                                .padding()
                                .foregroundStyle(categoryColor)
                                .background(categoryColor.opacity(0.5))
                                .cornerRadius(17)
                            }
                            
                            ForEach(myAppData.categories) { category in
                                Button(action: {
                                    selectedCategory = category
                                    title = selectedCategory.name
                                    titleColor = selectedCategory.colorTheme
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
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    ScrollView {
                        Spacer()
                        VStack(spacing: 9.0) {
                            ForEach(filteredCategoryFinish().sorted(by: { $0.deadline < $1.deadline })) { task in
                                ZStack {
                                    Color.white
                                        .frame(width: 366, height: 96.0)
                                        .cornerRadius(23)
                                        .shadow(radius: 10)
                                    HStack(spacing: 8) {
                                        Spacer()
                                        
                                        Button(action: {
                                            if let index = myAppData.tasks.firstIndex(where: { $0.id == task.id }) {
                                                                                       myAppData.tasks[index].isFinish.toggle()
                                            }
                                        }, label: {
                                            Image(systemName: task.isFinish ? "checkmark.square.fill" : "square")
                                                .foregroundColor(.black)
                                                .padding(.leading, 16)
                                                .font(.system(size: 27))
                                        })
                                        VStack(alignment: .leading, spacing: 3) {
                                            Text(task.title)
                                                .font(.system(size: 15))
                                                .fontWeight(.semibold)
                                            
                                            VStack(alignment: .leading, spacing: 3) {
                                                ForEach(Array(task.subtasks.enumerated().suffix(task.subtasks.count > 3 ? 2 : 3)), id: \.element.id) { index, subtask in
                                                    HStack(spacing: 4){
                                                        Button(action: {
                                                            // Recherche de l'index de la tâche dans myAppData
                                                            if let taskIndex = myAppData.tasks.firstIndex(where: { $0.id == task.id }) {
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
                                                
                                                if task.subtasks.count > 3 {
                                                    Text("+ \(task.subtasks.count - 3) autres sous tâches")
                                                        .font(.system(size: 9))
                                                        .fontWeight(.semibold)
                                                        .padding(.leading, 12.0)
                                                } else {
                                                    /*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
                                                }
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            HStack {
                                                Circle()
                                                    .frame(width: 14.0, height: 14.0)
                                                    .foregroundStyle(task.categorie.colorTheme)
                                                
                                                ZStack {
                                                    // Cercle d'arrière-plan
                                                    Circle()
                                                    
                                                        .stroke(lineWidth: 3.5)
                                                        .opacity(0.3)
                                                        .foregroundColor(Color.gray)
                                                    
                                                    // Cercle de progression
                                                    Circle()
                                                        .trim(from: 0.0, to: CGFloat(task.progress))  // Le "to:" dépend de la progression
                                                        .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                                                        .foregroundColor(Color.green)  // Change la couleur si besoin
                                                        .rotationEffect(Angle(degrees: -90))  // Pour commencer à 12h au lieu de 3h
                                                    
                                                    // Texte au centre affichant le pourcentage
                                                    Text(String(format: "%.0f%%", task.progress * 100))
                                                        .font(.system(size: 5))
                                                        .bold()
                                                }
                                                .frame(width: 18)
                                                
                                                Text(formattedDate(from: task.deadline))
                                                    .font(.system(size: 10))
                                                    .fontWeight(.semibold)
                                                    
                                            }
                                            .foregroundColor(.gray)
                                        }
                                        
                                        Image(systemName: "exclamationmark.circle.fill")
                                            .font(.system(size: 27))
                                            .foregroundColor(task.categorie.colorTheme)
                                            .padding(.trailing, 16)
                                        
                                        Spacer()
                                    }
                                }
                            }
                        }
                    }
                    .mask(
                        LinearGradient(gradient: Gradient(stops: [
                            .init(color: .clear, location: 0),
                            .init(color: .black, location: 0.05),  // Opacité complète à partir de 10% du haut
                            .init(color: .black, location: 0.9),  // Fade out à partir de 90% du bas
                            .init(color: .clear, location: 1)
                        ]), startPoint: .top, endPoint: .bottom)
                    )
                }
                .sheet(isPresented: $addViewPresented, content: {
                    AddTaskView(task: Task(id: UUID(), title: "", subtasks: [], time: Time(hours: 0, minutes: 0, secondes: 0), deadline: Date(), isFinish: false, isImportant: false, isInDetails: false, categorie: selectedCategory), addViewPresented: $addViewPresented)
                })
                .toolbar(content: {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            showCompleteOnly.toggle()
                            if showCompleteOnly {
                                title = "Archives"
                                titleColor = .brown
                            } else {
                                title = "Tout"
                                titleColor = .black
                                selectedCategory = Category(name: "All", colorTheme: .gray, symbolName: "circle.fill")
                            }
                        }) {
                            Image(systemName: showCompleteOnly ? "archivebox.fill" : "archivebox")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            addViewPresented.toggle()
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(.gray)
                        }
                    }
                })
                .padding(.top)
            }
        }
    }
    
    private func filteredCategoryFinish() -> [Task] {
        if myAppData.tasks.filter({ $0.isInDetails }).count == 1 {
            return myAppData.tasks.filter { $0.isInDetails }
        }
        
        if showCompleteOnly == true {
            return myAppData.tasks.filter { $0.isFinish }
        }
        if selectedCategory.name == "All" {
            return myAppData.tasks.filter { $0.isFinish == false }
        } else {
            return myAppData.tasks.filter { $0.categorie == selectedCategory && $0.isFinish == false }
        }
    }
    
    private func filteredSearch() -> [Task] {
        if !search.isEmpty {
            return myAppData.tasks.filter { $0.title.localizedCaseInsensitiveContains(search) }
        } else {
            return []
        }
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
    TasksView()
        .environmentObject(MyAppData())  // Ajoutez un environnement pour les prévisualisations
}
