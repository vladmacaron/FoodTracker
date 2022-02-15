//
//  ListRowView.swift
//  FoodTracker
//
//  Created by Vladislav Mazurov on 11.02.22.
//

import SwiftUI

struct FoodListRow: View {
    
    var food: FoodModel
    
    var body: some View {
        HStack {
            Text(food.name)
            Spacer()
        }
    }
}

struct FoodListRow_Previews: PreviewProvider {
    static var previews: some View {
        FoodListRow(food: foodData[0])
    }
}
