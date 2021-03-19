//
//  CharacterDetailsViewController.swift
//  RickAndMorty
//
//  Created by Recep Bayraktar on 19.03.2021.
//

import UIKit
import Kingfisher

class CharacterDetailsViewController: UIViewController {
    
    var character: Character?
    
    //MARK: - Outlets
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusColor: UILabel!
    @IBOutlet weak var statusSpeciesGenderLabel: UILabel!
    @IBOutlet weak var lastSeen: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var episodesCountLabel: UILabel!
    @IBOutlet weak var favorited: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFavoriteButton()
        loadDetails()
    }
    
    //MARK: - Get data from API to Outlets
    func loadDetails() {
        guard let characterDetails = character else { return }
        
        avatar.kf.setImage(with: URL(string: characterDetails.image))
        nameLabel.text = characterDetails.name
        statusSpeciesGenderLabel.text = characterDetails.status + " - " + characterDetails.species + " - " + characterDetails.gender
        lastSeen.text = "Last Seen: " + characterDetails.location.name
        originLabel.text = "Origin: " + characterDetails.origin.name
        episodesCountLabel.text = "Seen Episodes: \(characterDetails.episode.count)"
        
        statusColor.textColor = { () -> UIColor in
            if characterDetails.status == "Alive" {
                return UIColor.green
            } else if characterDetails.status == "Dead"{
                return UIColor.red
            } else {
                return UIColor.gray
            }
        }()
    }
    
    //MARK: - Favorite Section in Detail Page
    func setFavoriteButton() {
        
        if let id = self.character?.id {
            
            let favorites = FavoritedCharacterUserDefault.shared.fetchFavorites()
            if FavoritedCharacterUserDefault.shared.isExistsFavorite(id: id, favorites: favorites) {
                self.favorited.setImage(UIImage(named: "star-2"), for: UIControl.State.normal)
            } else {
                self.favorited.setImage(UIImage(named: "star"), for: UIControl.State.normal)
            }
        }
    }
    
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
