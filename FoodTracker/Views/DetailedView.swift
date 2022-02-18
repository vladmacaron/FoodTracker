//
//  DetailedView.swift
//  FoodTracker
//
//  Created by Vladislav Mazurov on 12.02.22.
//

import SwiftUI

struct DetailedView: View {
    var food: FoodModel
    
    var body: some View {
        VStack(alignment: .center) {
            Text(food.name)
                .font(.title)
                .fontWeight(.heavy)
                .padding()
            HStack {
                Text("Nutrition Details:")
                    .font(.headline)
                Spacer()
            }
            .padding()
            List {
                HStack {
                    Text("Energy:")
                    Spacer()
                    Text("\(food.nutritionDetails.energy) kcal")
                }
                if food.nutritionDetails.fat != 0.0 {
                    HStack {
                        Text("Fat:")
                        Spacer()
                        Text("\(String(format: "%.1f", food.nutritionDetails.fat)) g")
                    }
                }
                if food.nutritionDetails.saturatedFat != 0.0 {
                    HStack {
                        Text("Saturated Fat:")
                        Spacer()
                        Text("\(String(format: "%.1f", food.nutritionDetails.saturatedFat)) g")
                    }
                }
                if food.nutritionDetails.carbohydrate != 0.0 {
                    HStack {
                        Text("Carbohydrate:")
                        Spacer()
                        Text("\(String(format: "%.1f", food.nutritionDetails.carbohydrate)) g")
                    }
                }
                if food.nutritionDetails.sugar != 0.0 {
                    HStack {
                        Text("Sugar:")
                        Spacer()
                        Text("\(String(format: "%.1f", food.nutritionDetails.sugar)) g")
                    }
                }
                if food.nutritionDetails.protein != 0.0 {
                    HStack {
                        Text("Protein:")
                        Spacer()
                        Text("\(String(format: "%.1f", food.nutritionDetails.protein)) g")
                    }
                }
                if food.nutritionDetails.salt != 0.0 {
                    HStack {
                        Text("Salt:")
                        Spacer()
                        Text("\(String(format: "%.1f", food.nutritionDetails.salt)) g")
                    }
                }
            }
            .listStyle(.plain)
        }
        .padding()
    }
}

struct DetailedView_Previews: PreviewProvider {
    static var previews: some View {
        DetailedView(food: foodData[1])
    }
}
