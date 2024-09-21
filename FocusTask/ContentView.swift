//
//  ContentView.swift
//  FocusTask
//
//  Created by Klesya Loha on 12/09/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var showModal = false
    @State private var selectedItem: Item? = nil
    @State private var selectedItemPosition: CGRect = .zero
    
    let items = [
        Item(id: 1, title: "Élément 1", details: "Détails de l'élément 1"),
        Item(id: 2, title: "Élément 2", details: "Détails de l'élément 2"),
        Item(id: 3, title: "Élément 3", details: "Détails de l'élément 3")
    ]
    
    var body: some View {
        ZStack {
            VStack {
                ForEach(items) { item in
                    Button(action: {
                        withAnimation {
                            self.selectedItem = item
                            self.showModal = true
                        }
                    }) {
                        Text(item.title)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .background(GeometryReader { geo -> Color in
                        DispatchQueue.main.async {
                            if item == selectedItem {
                                self.selectedItemPosition = geo.frame(in: .global)
                            }
                        }
                        return Color.clear
                    })
                    .padding()
                }
            }
            .blur(radius: showModal ? 10 : 0)
            
            // Afficher la modale si un élément est sélectionné
            if showModal, let selectedItem = selectedItem {
                ModalView(isPresented: $showModal, item: selectedItem, initialPosition: selectedItemPosition)
                    .transition(.identity) // Pas de transition par défaut
            }
        }
    }
}

struct ModalView: View {
    @Binding var isPresented: Bool
    var item: Item
    var initialPosition: CGRect
    
    @State private var modalPosition: CGSize = .zero
    @State private var scale: CGFloat = 0.1

    var body: some View {
        VStack {
            Text(item.title)
                .font(.title)
                .padding()
            
            Text(item.details)
                .padding()
            
            Button("Fermer") {
                withAnimation {
                    isPresented = false
                }
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
        .shadow(radius: 20)
        .offset(x: modalPosition.width, y: modalPosition.height)
        .scaleEffect(scale) // Échelle de la modale
        .onAppear {
            let screenSize = UIScreen.main.bounds.size
            let targetPosition = CGSize(
                width: screenSize.width / 2 - initialPosition.midX,
                height: screenSize.height / 2 - initialPosition.midY
            )
            
            // Déplacer la modale de sa position initiale au centre
            modalPosition = targetPosition
            withAnimation(.spring()) {
                modalPosition = .zero // Déplacer la modal au centre
                scale = 1.0 // Élargir à la taille normale
            }
        }
        .onDisappear {
            // Réinitialiser la position et l'échelle à la position d'origine
            modalPosition = CGSize(
                width: initialPosition.midX - UIScreen.main.bounds.width / 2,
                height: initialPosition.midY - UIScreen.main.bounds.height / 2
            )
            scale = 0.1 // Rappetisser avant de disparaître
        }
    }
}

struct Item: Identifiable, Equatable {
    var id: Int
    var title: String
    var details: String
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
