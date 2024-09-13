//
//  TasksView.swift
//  FocusTask
//
//  Created by Klesya Loha on 12/09/2024.
//

import SwiftUI

struct TasksView: View {
    @State private var search: String = ""
    @EnvironmentObject var myAppData: MyAppData  // Utilisez @EnvironmentObject pour accéder aux données

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.white,.gray], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 10) {
                        Text("Tout")
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
                                        // Action à réaliser lors du clic sur le bouton
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
                        
                        ForEach(myAppData.tasks) { task in
                            Text(task.title)
                                .font(.headline)
                            ForEach(task.subtasks) { subtask in
                                HStack {
                                    Image(systemName: "circle")
                                    Text(subtask.title)
                                        .font(.subheadline)
                                }
                                .padding(.leading, 16.0)
                            }
                        }
                    }
                    .padding(.top)
                }
            }
        }
    }
}

#Preview {
    TasksView()
        .environmentObject(MyAppData())  // Ajoutez un environnement pour les prévisualisations
}
