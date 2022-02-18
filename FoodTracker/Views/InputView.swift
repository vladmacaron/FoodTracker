//
//  InputView.swift
//  FoodTracker
//
//  Created by Vladislav Mazurov on 14.02.22.
//

import SwiftUI

struct InputView: View {
    @State var presentedAsModal: Bool
    @State private var showScanner = false
    @State private var isRecognizing = false
    
    @State private var name: String = ""
    @State private var nameError = false
    @State private var energyString: String = ""
    @State private var energyError = false
    @State private var fatString: String = ""
    @State private var saturatedFatString: String = ""
    @State private var carbohydrateString: String = ""
    @State private var sugarString: String = ""
    @State private var proteinString: String = ""
    @State private var saltString: String = ""
    
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var recognizedContent = RecognizedContent()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if isRecognizing {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color(UIColor.systemIndigo)))
                    //.padding(.bottom, 20)
            }
        }
        VStack {
            VStack {
                HStack {
                    Text("Take data directly from Nutrition Etiquett:")
                        .font(.headline)
                        .padding()
                    Button("Photo") {
                        showScanner = true
                    }
                }
                .padding()
                Form {
                    Section("Add manually:") {
                        VStack {
                            TextField(
                                "Name",
                                text: $name,
                                prompt: Text("Name*"))
                            if nameError {
                                Text("Name is required")
                                    .foregroundColor(.red)
                            }
                        }
                        VStack {
                            TextField(
                                "Energy",
                                text: $energyString,
                                prompt: Text("Energy*"))
                                .keyboardType(.decimalPad)
                            if energyError {
                                Text("Energy is required")
                                    .foregroundColor(.red)
                            }
                        }
                        VStack {
                            TextField(
                                "Fat",
                                text: $fatString,
                                prompt: Text("Fat"))
                                .keyboardType(.decimalPad)
                        }
                        VStack {
                            TextField(
                                "Saturated Fat",
                                text: $saturatedFatString,
                                prompt: Text("Saturated Fat"))
                                .keyboardType(.decimalPad)
                        }
                        VStack {
                            TextField(
                                "Carbohydrate",
                                text: $carbohydrateString,
                                prompt: Text("Carbohydrate"))
                                .keyboardType(.decimalPad)
                        }
                        VStack {
                            TextField(
                                "Sugar",
                                text: $sugarString,
                                prompt: Text("Sugar"))
                                .keyboardType(.decimalPad)
                        }
                        VStack {
                            TextField(
                                "Protein",
                                text: $proteinString,
                                prompt: Text("Protein"))
                                .keyboardType(.decimalPad)
                        }
                        VStack {
                            TextField(
                                "Salt",
                                text: $saltString,
                                prompt: Text("Salt"))
                                .keyboardType(.decimalPad)
                        }
                    }
                }
                HStack {
                    Button {
                        if name.isEmpty || energyString.isEmpty {
                            nameError = name.isEmpty
                            energyError = energyString.isEmpty
                        } else {
                            fatString = fatString.replacingOccurrences(of: ",", with: ".")
                            saturatedFatString = saturatedFatString.replacingOccurrences(of: ",", with: ".")
                            carbohydrateString = carbohydrateString.replacingOccurrences(of: ",", with: ".")
                            sugarString = sugarString.replacingOccurrences(of: ",", with: ".")
                            proteinString = proteinString.replacingOccurrences(of: ",", with: ".")
                            saltString = saltString.replacingOccurrences(of: ",", with: ".")
                            print(fatString)
                            let item = FoodModel(name: name, nutritionDetails: Nutrition(energy: Int(energyString)!, fat: fatString=="" ? 0.0 : Double(fatString)!, saturatedFat: saturatedFatString=="" ? 0.0 : Double(saturatedFatString)!, carbohydrate: carbohydrateString=="" ? 0.0 : Double(carbohydrateString)!, sugar: sugarString=="" ? 0.0 : Double(sugarString)!, protein: proteinString=="" ? 0.0 : Double(proteinString)!, salt: saltString=="" ? 0.0 : Double(saltString)!))
                            addItem(item: item)
                            presentationMode.wrappedValue.dismiss()
                        }
                    } label: {
                        Text("Add")
                            .foregroundColor(.white)
                            .font(.headline)
                            .frame(maxWidth: 200)
                    }
                    .tint(Color.green)
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle(radius: 5))
                    .controlSize(.large)
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                            .foregroundColor(.white)
                            .font(.headline)
                            .frame(maxWidth: 200)
                    }
                    .tint(Color.red)
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle(radius: 5))
                    .controlSize(.large)
                }
                .padding()
            }
        }
        .sheet(isPresented: $showScanner) {
            ScannerView { result in
                switch result {
                case .success(let scannedImages):
                    isRecognizing = true
                    TextRecognition(scannedImages: scannedImages,
                                    recognizedContent: recognizedContent) {
                        // Text recognition is finished
                        isRecognizing = false
                        energyString = recognizedContent.items.first!.energy
                        fatString = recognizedContent.items.first!.fat
                        saturatedFatString = recognizedContent.items.first!.saturatedFat
                        carbohydrateString = recognizedContent.items.first!.carbohydrate
                        sugarString = recognizedContent.items.first!.sugar
                        proteinString = recognizedContent.items.first!.protein
                        saltString = recognizedContent.items.first!.salt
                    }
                    .recognizeText()
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
                showScanner = false
            } didCancelScanning: {
                showScanner = false
            }
        }

    }
    
    private func addItem(item: FoodModel) {
        let newItem = Item(context: viewContext)
        newItem.name = item.name
        newItem.energy = Int16(item.nutritionDetails.energy)
        newItem.fat = item.nutritionDetails.fat
        newItem.saturatedFat = item.nutritionDetails.saturatedFat
        newItem.carbohydrate = item.nutritionDetails.carbohydrate
        newItem.sugar = item.nutritionDetails.sugar
        newItem.protein = item.nutritionDetails.protein
        newItem.salt = item.nutritionDetails.salt
        
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

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(presentedAsModal: true)
    }
}
