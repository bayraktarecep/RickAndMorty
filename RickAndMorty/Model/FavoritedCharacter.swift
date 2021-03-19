//
//  FavoritedCharacter.swift
//  RickAndMorty
//
//  Created by Recep Bayraktar on 19.03.2021.
//

import Foundation

//MARK: - UserDefault Helper Model for saving with id
class FavoritedCharacter: NSObject, NSCoding {
    
    var id: Int?
    
    override init() { }
    
    required init?(coder aDecoder: NSCoder) {
        
        id = aDecoder.decodeObject(forKey: "id") as? Int
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(id, forKey: "id")
    }
    
    init(id: Int) {
        super.init()
        
        self.id = id
    }
}
