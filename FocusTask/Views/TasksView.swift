//
//  TasksView.swift
//  FocusTask
//
//  Created by Klesya Loha on 12/09/2024.
//

import SwiftUI

struct TasksView: View {
    @State private var search: String = ""
    @State private var selectedCategory = Category(name: "All", colorTheme: .gray, symbolName: "circle.fill")
    @State private var showCompleteOnly: Bool = false
    @State private var title = "Tout"
    @State private var titleColor : Color = .black
    @State private var addViewPresented = false

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
                            ForEach(filteredCategoryFinish()) { task in
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
                                                ForEach(task.subtasks) { subtask in
                                                    HStack(spacing: 4){
                                                        Image(systemName: "circle")
                                                            .font(.system(size: 12))
                                                        
                                                        Text(subtask.title)
                                                            .font(.system(size: 9))
                                                            .fontWeight(.semibold)
                                                    }
                                                }
                                                .padding(.leading, 8.0)
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                        
                                        Image(systemName: "exclamationmark.circle.fill")
                                            .font(.system(size: 27))
                                            .foregroundColor(task.categories.colorTheme)
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
                    Text("Salut")
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
        if showCompleteOnly == true {
            return myAppData.tasks.filter { $0.isFinish }
        }
        if selectedCategory.name == "All" {
            return myAppData.tasks.filter { $0.isFinish == false }
        } else {
            return myAppData.tasks.filter { $0.categories == selectedCategory && $0.isFinish == false }
        }
    }
    
    private func filteredSearch() -> [Task] {
        if !search.isEmpty {
            return myAppData.tasks.filter { $0.title.localizedCaseInsensitiveContains(search) }
        } else {
            return []
        }
    }
}

#Preview {
    TasksView()
        .environmentObject(MyAppData())  // Ajoutez un environnement pour les prévisualisations
}
