//
//  FavoritedCharacterUserDefault.swift
//  RickAndMorty
//
//  Created by Recep Bayraktar on 19.03.2021.
//

import Foundation

//MARK: - UserDefault Settings for Favorite Characters from Detail Page
class FavoritedCharacterUserDefault {
    
    static let shared = FavoritedCharacterUserDefault()
    
    private init() { }
    
    func fetchFavorites() -> [FavoritedCharacter] {
        
        let userDefaults = UserDefaults.standard
        
        if let decodedFavorites = userDefaults.object(forKey: "FAVORITED_CHARACTERS") as? Data {
            
            do {
                
                let unarchiver = try NSKeyedUnarchiver(forReadingFrom: decodedFavorites)
                unarchiver.requiresSecureCoding = false
                let decoded = unarchiver.decodeObject(of: [FavoritedCharacter.self], forKey: NSKeyedArchiveRootObjectKey) as? [FavoritedCharacter]
                
                if let decodedArray = decoded {
                    return decodedArray
                } else {
                    return [FavoritedCharacter]()
                }
                
            } catch let error as NSError {
                print(error)
                return [FavoritedCharacter]()
            }
        }
        else {
            return [FavoritedCharacter]()
        }
    }
    
    func isExistsFavorite(id: Int, favorites: [FavoritedCharacter]) -> Bool {
        
        let filteredArray = favorites.filter({$0.id == id})
        
        if !filteredArray.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    func changeFavoriteAs(id: Int, status: Bool, favorites: [FavoritedCharacter]) {
        
        var mutableFavorite = favorites
        
        if !status {
            
            mutableFavorite = mutableFavorite.filter { $0.id != id }
        }
        else {
            
            let characterFavorites = FavoritedCharacter(id: id)
            mutableFavorite.append(characterFavorites)
        }
        
        do {
            
            let userDefaults = UserDefaults.standard
            let encodedData = try NSKeyedArchiver.archivedData(withRootObject: mutableFavorite, requiringSecureCoding: false)
            
            let cacheString = "FAVORITED_CHARACTERS"
            userDefaults.set(encodedData, forKey: cacheString)
            userDefaults.synchronize()
            
        } catch let error as NSError {
            print(error)
        }
    }
}
