//
//  FoodModel.swift
//  FoodTracker
//
//  Created by Vladislav Mazurov on 12.02.22.
//

import Foundation

class FoodModel {
    
    let name: String
    let nutritionDetails: Nutrition
    
    init(name: String, nutritionDetails: Nutrition) {
        self.name = name
        self.nutritionDetails = nutritionDetails
    }
}
