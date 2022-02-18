//
//  TextRecognition.swift
//  FoodTracker
//
//  Created by Vladislav Mazurov on 16.02.22.
//

import SwiftUI
import Vision

struct TextRecognition {
    var scannedImages: [UIImage]
    @ObservedObject var recognizedContent: RecognizedContent
    var didFinishRecognition: () -> Void
    
    private func getTextRecognitionRequest(with textItem: TextItem) -> VNRecognizeTextRequest {
        let request = VNRecognizeTextRequest { request, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            var textBoxes = [TextBox]()
            
            observations.forEach { observation in
                for text in observation.topCandidates(1) {
                    let component = TextBox()
                    component.x = observation.boundingBox.origin.x
                    component.y = observation.boundingBox.origin.y
                    component.text = text.string
                    textBoxes.append(component)
                }
            }
            
            for i in stride(from: 1, to: textBoxes.count - 1, by: 1) {
                if textBoxes[i].text.contains("Energie") {
                    let stringSplit = textBoxes[i+1].text.split(separator: " ")
                    textItem.energy = stringSplit[stringSplit.firstIndex(of: "kcal")!-1].components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                }
                
                if textBoxes[i].text.contains("Fett/") {
                    textItem.fat = textBoxes[i+1].text.replacingOccurrences(of: "g", with: "").trimmingCharacters(in: .whitespaces)
                }
                
                if textBoxes[i].text.contains("Fettsäuren") {
                    
                    if (textBoxes[i].y-textBoxes[i+1].y)<0.01 {
                        textItem.saturatedFat = textBoxes[i+1].text.replacingOccurrences(of: "g", with: "").trimmingCharacters(in: .whitespaces)
                    } else {
                        textItem.saturatedFat = textBoxes[i+2].text.replacingOccurrences(of: "g", with: "").trimmingCharacters(in: .whitespaces)
                    }
                }
                
                if textBoxes[i].text.contains("Kohlenhydrate") {
                    textItem.carbohydrate = textBoxes[i+1].text.replacingOccurrences(of: "g", with: "").trimmingCharacters(in: .whitespaces)
                }
                
                if textBoxes[i].text.contains("Zucker") {
                    textItem.sugar = textBoxes[i+1].text.replacingOccurrences(of: "g", with: "").trimmingCharacters(in: .whitespaces)
                }
                
                if textBoxes[i].text.contains("Eiweiß") {
                    textItem.protein = textBoxes[i+1].text.replacingOccurrences(of: "g", with: "").trimmingCharacters(in: .whitespaces)
                }
                
                if textBoxes[i].text.contains("Salz") {
                    textItem.salt = textBoxes[i+1].text.replacingOccurrences(of: "g", with: "").trimmingCharacters(in: .whitespaces)
                }
            }

        }
        
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        
        return request
    }
    
    func recognizeText() {
        let queue = DispatchQueue(label: "textRecognitionQueue", qos: .userInitiated)
        queue.async {
            for image in scannedImages {
                guard let cgImage = image.cgImage else { return }
                let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                do {
                    let textItem = TextItem()
                    try requestHandler.perform([getTextRecognitionRequest(with: textItem)])
                    DispatchQueue.main.async {
                        recognizedContent.items.append(textItem)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            DispatchQueue.main.async {
                didFinishRecognition()
            }
        }
    }
}
