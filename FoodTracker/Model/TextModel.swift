//
//  TextModel.swift
//  FoodTracker
//
//  Created by Vladislav Mazurov on 16.02.22.
//

import Foundation

class RecognizedContent: ObservableObject {
    @Published var items = [TextItem]()
}

class TextItem: Identifiable {
    var id: String
    //var text: String = ""
    var energy: String = ""
    var fat: String = ""
    var saturatedFat: String = ""
    var carbohydrate: String = ""
    var sugar: String = ""
    var protein: String = ""
    var salt: String = ""
    
    init() {
        id = UUID().uuidString
    }
}
