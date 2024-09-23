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
    @State private var title = "All"
    @State private var titleColor: Color = .gray
    @State private var addViewPresented = false
    @State private var addCategory = false
    @State private var categoryTitle = ""
    @State private var categoryColor: Color = .black
    @State private var categorySymbol = "heart"
    @State private var detailsIsPresented = false
    @State private var selectedTask: Task? = nil

    let symbols = ["star.circle.fill", "heart.circle.fill", "flame.circle.fill", "bolt.circle.fill", "leaf.circle.fill", "moon.circle.fill", "pencil.circle.fill", "flag.circle.fill", "gift.circle.fill", "book.circle.fill"]

    @EnvironmentObject var myAppData: MyAppData

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
                        .padding(.horizontal)

                    TextField("Search...", text: $search)
                        .padding(.horizontal, 20.0)
                        .textFieldStyle(.roundedBorder)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            if addCategory {
                                HStack {
                                    ColorPicker("", selection: $categoryColor)

                                    Picker("Symbole", selection: $categorySymbol) {
                                        ForEach(symbols, id: \.self) { symbol in
                                            HStack {
                                                Image(systemName: symbol)
                                                    .foregroundColor(categoryColor)
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
                                            myAppData.categories.append(Category(name: categoryTitle, colorTheme: categoryColor, symbolName: categorySymbol))
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
                            ForEach(filteredTasks()) { task in
                                Button(action: {
                                    detailsIsPresented = true
                                    selectedTask = task
                                }, label: {
                                    HStack(spacing: 8) {
                                        Spacer()
                                        
                                        Button(action: {
                                            if let index = myAppData.tasks.firstIndex(where: { $0.id == task.id }) {
                                                withAnimation(.bouncy(duration: 1)) {
                                                    myAppData.tasks[index].isFinish.toggle()
                                                }
                                            }
                                        }, label: {
                                            Image(systemName: task.isFinish ? "checkmark.square.fill" : "square")
                                                .foregroundColor(.black)
                                                .font(.system(size: 27))
                                        })
                                        .background(GeometryReader { geo in
                                            let frame = geo.frame(in: .global)
                                            let center = CGPoint(x: frame.midX, y: frame.minY - frame.height * 2)
                                            DispatchQueue.main.async {
                                                if let index = myAppData.tasks.firstIndex(where: { $0.id == task.id }) {
                                                    myAppData.tasks[index].position = center
                                                }
                                            }
                                            return Color.clear
                                        })
                                        
                                        VStack(alignment: .leading, spacing: 5) {
                                            Text(task.title)
                                                .font(.system(size: 15))
                                                .fontWeight(.semibold)
                                            
                                            VStack(alignment: .leading, spacing: 3) {
                                                ForEach(Array(task.subtasks.enumerated().prefix(task.subtasks.count > 3 ? 2 : 3)), id: \.element.id) { index, subtask in
                                                    HStack(spacing: 4) {
                                                        Button(action: {
                                                            if let taskIndex = myAppData.tasks.firstIndex(where: { $0.id == task.id }) {
                                                                myAppData.tasks[taskIndex].subtasks[index].isFinish.toggle()
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
                                                }
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            HStack {
                                                Circle()
                                                    .frame(width: 14.0, height: 14.0)
                                                    .foregroundStyle(task.categorie.colorTheme)
                                                
                                                ZStack {
                                                    Circle()
                                                        .stroke(lineWidth: 3.5)
                                                        .opacity(0.3)
                                                        .foregroundColor(Color.gray)
                                                    
                                                    Circle()
                                                        .trim(from: 0.0, to: CGFloat(task.progress))
                                                        .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                                                        .foregroundColor(Color.green)
                                                        .rotationEffect(Angle(degrees: -90))
                                                    
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
                                        
                                        Button(action: {
                                            if let index = myAppData.tasks.firstIndex(where: { $0.id == task.id }) {
                                                withAnimation {
                                                    myAppData.tasks[index].isImportant.toggle()
                                                }
                                            }
                                        }, label: {
                                            Image(systemName: "exclamationmark.circle.fill")
                                                .font(.system(size: 27))
                                                .foregroundColor(task.isImportant ?  task.categorie.colorTheme : .gray)
                                        })
                                        
                                        Spacer()
                                    }
                                    .foregroundStyle(.black)
                                    .frame(width: UIScreen.main.bounds.size.width - 20, height: 96)
                                    .padding(.all,  10)
                                    .background(
                                            Color.white
                                                .cornerRadius(23)
                                                .padding(.horizontal)
                                                .shadow(color: .gray, radius: 3, x: 3, y: 5) // Ajout de l'ombre ici
                                    )
                                })
                                .swipeActions(edge: .leading) {
                                            Button(role: .destructive) {
                                                // Action pour supprimer la tâche
                                                if let index = myAppData.tasks.firstIndex(where: { $0.id == task.id }) {
                                                    myAppData.tasks.remove(at: index)
                                                }
                                            } label: {
                                                Label("Supprimer", systemImage: "trash")
                                            }
                                            
                                            Button {
                                                // Action pour marquer comme important ou pas
                                                if let index = myAppData.tasks.firstIndex(where: { $0.id == task.id }) {
                                                    myAppData.tasks[index].isImportant.toggle()
                                                }
                                            } label: {
                                                Label("Important", systemImage: task.isImportant ? "star.fill" : "star")
                                            }
                                            .tint(.yellow)
                                        }
                            }
                        }
                    }
                    .mask(
                        LinearGradient(gradient: Gradient(stops: [
                            .init(color: .clear, location: 0),
                            .init(color: .black, location: 0.05),
                            .init(color: .black, location: 0.9),
                            .init(color: .clear, location: 1)
                        ]), startPoint: .top, endPoint: .bottom)
                    )
                    .blur(radius: detailsIsPresented ? 10 : 0)
                    .animation(.easeInOut(duration: 0.5), value: detailsIsPresented) // Animation du flou
                }
                .sheet(isPresented: $addViewPresented, content: {
                    AddTaskView(task: Task(title: "", subtasks: [], time: Time(hours: 0, minutes: 0, secondes: 0), deadline: Date(), isFinish: false, isImportant: false, isInDetails: false, categorie: selectedCategory, position: CGPoint()), addViewPresented: $addViewPresented)
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

//                if detailsIsPresented, let selectedTask = selectedTask {
//                    print("Showing details for task: \(selectedTask.title)")
//                }
                if detailsIsPresented, let selectedTask = selectedTask {
                    DetailsTaskView(detailsIsPresented: $detailsIsPresented, initialPosition: selectedTask.position, taskId: selectedTask.id)
                        .transition(.identity)
                }
            }
        }
    }

    private func filteredTasks() -> [Task] {
        var tasksToDisplay = myAppData.tasks
        
        if showCompleteOnly {
            tasksToDisplay = tasksToDisplay.filter { $0.isFinish }
        } else if selectedCategory.name != "All" {
            tasksToDisplay = tasksToDisplay.filter { $0.categorie == selectedCategory && !$0.isFinish }
        } else {
            tasksToDisplay = tasksToDisplay.filter { !$0.isFinish }
        }
        
        if !search.isEmpty {
            tasksToDisplay = tasksToDisplay.filter { $0.title.localizedCaseInsensitiveContains(search) }
        }
        
        // Trier les tâches : d'abord par isImportant, puis par deadline
        return tasksToDisplay.sorted {
            if $0.isImportant != $1.isImportant {
                return $0.isImportant // Place les importantes en premier
            }
            return $0.deadline < $1.deadline // Ensuite, trier par deadline
        }
    }
    
    private func filteredSearch() -> [Task] {
        if !search.isEmpty {
            return myAppData.tasks.filter { $0.title.localizedCaseInsensitiveContains(search) }
        } else {
            return []
        }
    }

    func formattedDate(from date: Date) -> String {
        let calendar = Calendar.current
        let today = Date()
        let dayDifference = calendar.dateComponents([.day], from: today, to: date).day ?? 0
        let weekDifference = calendar.dateComponents([.weekOfYear], from: today, to: date).weekOfYear ?? 0

        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        let timeString = timeFormatter.string(from: date)

        if dayDifference <= 7 {
            if dayDifference == 0 {
                return "| Aujourd'hui à \(timeString) |"
            } else if dayDifference == 1 {
                return "| Demain à \(timeString) |"
            } else {
                return "| Dans \(dayDifference) jours à \(timeString) |"
            }
        } else if weekDifference < 4 {
            return "| Dans \(weekDifference) semaine\(weekDifference > 1 ? "s" : "") à \(timeString) |"
        }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateFormat = "| EEEE d MMMM 'à' HH:mm |"
        return formatter.string(from: date)
    }
}

#Preview {
    TasksView()
        .environmentObject(MyAppData())
}

