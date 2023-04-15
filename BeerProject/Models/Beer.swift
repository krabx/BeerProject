//
//  Beer.swift
//  BeerProject
//
//  Created by Богдан Радченко on 12.04.2023.
//

import Foundation

struct Beer: Decodable {
    let name: String
    let description: String
    let imageURL: String
    let abv: Double
    let ingredients: Ingredients
    let foodPairing: [String]
    let contributedBy: String
    
//    var descriptionOfBeer: String {
//        """
//        Description:
//        \(description)
//        """
//    }
}

struct Ingredients: Decodable {
    let malt: [Malt]
    let yeast: String
}

struct Malt: Decodable {
    let name: String
    let amount: Amount
}

struct Amount: Decodable {
    let value: Double
    let unit: String
}

extension Beer {
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case imageURL = "image_url"
        case abv
        case ingredients
        case foodPairing = "food_pairing"
        case contributedBy = "contributed_by"
    }
}

struct Note {
    let note: String
}
