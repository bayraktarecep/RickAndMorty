//
//  CharactersCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Recep Bayraktar on 19.03.2021.
//

import UIKit
import Kingfisher

class CharactersCollectionViewCell: UICollectionViewCell {
    
    var character: Character?
    
    //MARK: - Cell Outlets
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var statusColor: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var favorited: UIButton!
    
    //MARK: - Fetch Outlets with Data from Api
    func loadData(_ character: Character) {
        nameLabel.text = character.name
        speciesLabel.text = character.species
        statusLabel.text = character.status
        statusColor.textColor = { () -> UIColor in
            if character.status == "Alive" {
                return UIColor.green
            } else if character.status == "Dead" {
                return UIColor.red
            } else {
                return UIColor.gray
            }
        }()
        
        let imageUrl = URL(string: character.image)
        avatar.kf.indicatorType = .activity
        avatar.kf.setImage(with: imageUrl)
        
    }
    
    //MARK: - Favorite section in CollectionView Cell
    @IBAction func addedFavorites(_ sender: Any) {
        
        if let id = self.character?.id {
            
            let favorites = FavoritedCharacterUserDefault.shared.fetchFavorites()
            if FavoritedCharacterUserDefault.shared.isExistsFavorite(id: id, favorites: favorites) {
                FavoritedCharacterUserDefault.shared.changeFavoriteAs(id: id, status: false, favorites: favorites)
                self.favorited.setImage(UIImage(named: "star"), for: UIControl.State.normal)
            } else {
                FavoritedCharacterUserDefault.shared.changeFavoriteAs(id: id, status: true, favorites: favorites)
                self.favorited.setImage(UIImage(named: "star-2"), for: UIControl.State.normal)
            }
        }
    }
}
