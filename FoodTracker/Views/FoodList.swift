//
//  FoodList.swift
//  FoodTracker
//
//  Created by Vladislav Mazurov on 12.02.22.
//

import SwiftUI

struct FoodList: View {
    @State var presentingInputView = false
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.name, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    let food = FoodModel(name: item.name!, nutritionDetails: Nutrition(energy: Int(item.energy), fat: item.fat, saturatedFat: item.saturatedFat, carbohydrate: item.carbohydrate, sugar: item.sugar, protein: item.protein, salt: item.salt))
                    NavigationLink {
                        DetailedView(food: food)
                    } label: {
                        FoodListRow(food: food)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    //Button(action: {}) {
                      //  Label("Add Item", systemImage: "plus")
                      //  self.presentingInputView = true
                    //}
                    Button("Add") {
                        self.presentingInputView = true
                    }
                    .sheet(isPresented: $presentingInputView) {
                        InputView(presentedAsModal: presentingInputView)
                    }
                  
                }
            }
            .navigationTitle("Food list")
            .listStyle(.sidebar)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct FoodList_Previews: PreviewProvider {
    static var previews: some View {
        FoodList()
    }
}
