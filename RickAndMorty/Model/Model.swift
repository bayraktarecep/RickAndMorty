//
//  Model.swift
//  RickAndMorty
//
//  Created by Recep Bayraktar on 19.03.2021.
//

import Foundation

enum CharacterStatus: String {
    
    case Alive
    case Dead
    case unknown
}

enum CharacterGender: String {
    
    case Female
    case Male
    case Genderless
    case unknown
}

//MARK: - JSON Decode from Api with Structs

struct Characters: Codable {
    let info: Info
    let results: [Character]?
}

struct Info: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

struct Character: Codable {
    let id: Int?
    let name: String
    let status: String
    let species: String
    let image: String
    let gender: String
    let origin: Origin
    let location: Location
    let episode: [String]
}

struct Origin: Codable {
    let name: String
}

struct Location: Codable {
    let name: String
}
