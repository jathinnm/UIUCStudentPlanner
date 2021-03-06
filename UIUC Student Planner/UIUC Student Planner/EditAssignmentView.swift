//
//  EditAssignmentView.swift
//  UIUC Student Planner
//
//  Created by Matthew Geimer on 10/7/20.
//

import SwiftUI

struct EditAssignmentView: View {
    //Viewcontext for the database
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    //The item passed in from the parent view
    @State var item: FetchedResults<Assignment>.Element
    
    @State var newName: String = ""
    @State var newPoints: Int64 = 0
    @State var newDate = Date.init(timeIntervalSinceNow: 0)
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Assignment Name")){
                    TextField("Assignment Name", text: $newName)
                        //updates item.name if the user changes the assignment's name
                }
                Section(header: Text("Assignment Details")) {
                    Stepper(value: $newPoints ,in: 0...100){
                       Text(getPoints())
                    }
                }
                DeadlinePickerView.init(selectedDate: self.$newDate)
                Button(action: {
                    saveContext()
                    self.presentationMode.wrappedValue.dismiss()
                }, label : {
                    HStack {
                        Spacer()
                        Text("Save")
                        Spacer()
                    }
                })
            }
            .navigationBarTitle("Edit Assignment")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label : {
                        Text("Cancel")
                    })
                }
            }
        }
        .onAppear {
            newName = item.name ?? "Untitled Assignment"
            newPoints = item.points
            newDate = item.dueDate ?? Date()
        }
    }
    
    func saveContext() {
      do {
        item.name = newName
        item.points = newPoints
        item.dueDate = newDate
        
        try viewContext.save()
      } catch {
        print("Error saving managed object context: \(error)")
      }
    }
    
    func getPoints() -> String {
        //updates the assignment's points and displays the points to the user
        return "\(newPoints) Point\(newPoints != 1 ? "s" : "")"
    }
}

struct EditAssignmentView_Previews: PreviewProvider {
    static var previews: some View {
        EditAssignmentView(item: Assignment(context: PersistenceController.preview.container.viewContext))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

