//
//  Beer.swift
//  BeerProject
//
//  Created by Богдан Радченко on 12.04.2023.
//

import Foundation

struct Beer: Codable {
    let id: Int
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

struct Ingredients: Codable {
    let malt: [Malt]
    let yeast: String
}

struct Malt: Codable {
    let name: String
    let amount: Amount
}

struct Amount: Codable {
    let value: Double
    let unit: String
}

extension Beer {
    enum CodingKeys: String, CodingKey {
        case id
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

var likeBeer: [Beer] = []
