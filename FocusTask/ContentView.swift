//
//  ContentView.swift
//  FocusTask
//
//  Created by Klesya Loha on 12/09/2024.
//

import SwiftUI

struct MyTask: Identifiable {
    let id = UUID()
    var title: String
}

struct SwipeToDeleteView: View {
    @State private var tasks = [
        MyTask(title: "Task 1"),
        MyTask(title: "Task 2"),
        MyTask(title: "Task 3")
    ]
    
    var body: some View {
        VStack {
            ForEach(tasks) { task in
                TaskRow(task: task, tasks: $tasks)
                    .padding(.horizontal)
                    .padding(.vertical, 4)
            }
        }
        .padding()
    }
}

struct TaskRow: View {
    let task: MyTask
    @Binding var tasks: [MyTask]
    
    @State private var offset: CGFloat = 0
    
    var body: some View {
        ZStack {
            HStack {
                Button(action: {
                    if let index = tasks.firstIndex(where: { $0.id == task.id }) {
                        tasks.remove(at: index)
                    }
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .clipShape(Circle())
                }
                .padding(.trailing, 20)
                .offset(x: offset > 0 ? -offset : 0)
            }
            .animation(.default, value: offset)
            
            HStack {
                Text(task.title)
                    .padding()
                Spacer()
            }
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .offset(x: offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let dragAmount = value.translation.width
                        if dragAmount < 0 {
                            offset = dragAmount
                        }
                    }
                    .onEnded { value in
                        if value.translation.width < -100 {
                            if let index = tasks.firstIndex(where: { $0.id == task.id }) {
                                tasks.remove(at: index)
                            }
                        }
                        offset = 0
                    }
            )
        }
    }
}

struct SwipeToDeleteView_Previews: PreviewProvider {
    static var previews: some View {
        SwipeToDeleteView()
    }
}
