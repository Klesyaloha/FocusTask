//
//  DetailsTaskView.swift
//  FocusTask
//
//  Created by Klesya Loha on 17/09/2024.
//

import SwiftUI

struct DetailsTaskView: View {
    @Binding var detailsIsPresented : Bool
    
    var initialPosition: CGPoint
    
    @State private var detailsViewPosition: CGPoint = CGPoint(x: 0, y: 300)
    @State private var scale: CGFloat = 0.1
    @State var taskId : Int
    
    @EnvironmentObject var myAppData: MyAppData  // Utilisez @EnvironmentObject pour accéder aux données
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        // Réinitialiser la position et l'échelle à la position d'origine
                        detailsViewPosition = CGPoint(x: 0, y: -UIScreen.main.bounds.size.width + initialPosition.y)
                        scale = 0.1 // Rappetisser avant de disparaître
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            // Code à exécuter après 1 secondes
                            detailsIsPresented = false
                        }
                    }
                }, label: {
                    Image(systemName: "xmark.circle")
                        .font(.system(size: 30))
                        .foregroundStyle(myAppData.tasks[taskId - 1].categorie.colorTheme)
                })
                .padding(.trailing, 20)
            }
            
            Text(myAppData.tasks[taskId - 1].title)
                .font(.system(size: 20))
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.bottom, 8)
            
            HStack(spacing: 8) {
                Spacer()
                
                Button(action: {
                    if let index = myAppData.tasks.firstIndex(where: { $0.id == myAppData.tasks[taskId - 1].id }) {
                        myAppData.tasks[index].isFinish.toggle()
                    }
                }, label: {
                    Image(systemName: myAppData.tasks[taskId - 1].isFinish ? "checkmark.square.fill" : "square")
                        .foregroundColor(.black)
                        .font(.system(size: 27))
                })
                .padding(.top, -42)
                .padding(.leading, 16)
                .background(.red)
//                .buttonStyle(.borderedProminent)
                
                VStack(alignment: .leading, spacing: 5) {
                    
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(Array(myAppData.tasks[taskId - 1].subtasks.enumerated()), id: \.element.id) { index, subtask in
                            HStack(spacing: 4){
                                Button(action: {
                                    // Accéder à la sous-tâche via l'index et la modifier
                                    let updatedTask = myAppData.tasks[taskId - 1]
                                    updatedTask.subtasks[index].isFinish.toggle()
                                    myAppData.tasks[taskId - 1] = updatedTask
                                }, label: {
                                    Image(systemName: subtask.isFinish ? "checkmark.circle.fill" : "circle")
                                        .font(.system(size: 20))
                                        .foregroundStyle(.black)
                                })
                                
                                
                                
                                Text(subtask.title)
                                    .font(.system(size: 15))
                                    .fontWeight(.regular)
                            }
                        }
                        .padding(.leading, 8.0)
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack(spacing: 15) {
                        Circle()
                            .frame(width: 20)
                            .foregroundStyle(myAppData.tasks[taskId - 1].categorie.colorTheme)
                        
                        ZStack {
                            // Cercle d'arrière-plan
                            Circle()
                                .stroke(lineWidth: 7)
                                .frame(width: 30)
                                .opacity(0.3)
                                .foregroundColor(Color.gray)
                            
                            // Cercle de progression
                            Circle()
                                .trim(from: 0.0, to: CGFloat(myAppData.tasks[taskId - 1].progress))  // Le "to:" dépend de la progression
                                .stroke(style: StrokeStyle(lineWidth: 7, lineCap: .round, lineJoin: .round))
                                .foregroundColor(Color.green)  // Change la couleur si besoin
                                .rotationEffect(Angle(degrees: -90))  // Pour commencer à 12h au lieu de 3h
                            
                            // Texte au centre affichant le pourcentage
                            Text(String(format: "%.0f%%", myAppData.tasks[taskId - 1].progress * 100))
                                .font(.system(size: 8))
                                .bold()
                        }
                        .frame(width: 18)
                        
                        Text(formattedDate(from: myAppData.tasks[taskId - 1].deadline))
                            .font(.system(size: 12))
                            .fontWeight(.semibold)
                        
                    }
                    .padding(.vertical, 10)
                    .foregroundColor(.gray)
                }
                
                Image(systemName: "exclamationmark.circle.fill")
                    .font(.system(size: 27))
                    .foregroundColor(myAppData.tasks[taskId - 1].categorie.colorTheme)
                    .padding(.trailing, 16)
                
                Spacer()
            }
            
        }
        .padding(.vertical, 20)
        .background(.white)
        .frame(width: UIScreen.main.bounds.size.width - 20)
        .cornerRadius(23)
        .shadow(radius: 10)
        .scaleEffect(scale) // Échelle de la modale
        .onAppear {
            let targetPosition = CGPoint(x: 0, y: -UIScreen.main.bounds.size.width + initialPosition.y)
            // Déplacer la modale de sa position initiale au centre
            detailsViewPosition = targetPosition
            withAnimation(.easeIn(duration: 0.5)) {
                detailsViewPosition = .zero // Déplacer la modal au centre
                scale = 1.0 // Élargir à la taille normale
            }
        }
        .offset(x: detailsViewPosition.x, y: detailsViewPosition.y)
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

struct DetailsTaskView_Previews: PreviewProvider {
    static var previews: some View {
        // Aperçu avec des données simulées
        DetailsTaskView(
            detailsIsPresented: .constant(true),
            initialPosition: CGPoint(x: 0, y: 0),
            taskId: 1
        )
        .environmentObject(MyAppData())
    }
}
