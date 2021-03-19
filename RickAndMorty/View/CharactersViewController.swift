//
//  CharactersViewController.swift
//  RickAndMorty
//
//  Created by Recep Bayraktar on 19.03.2021.
//

import UIKit

//MARK: - Created Protocol for the filtering data from TableView
protocol CharactersFilterDelegate {
    func filterCharactersBy(nameValue: String?, statusValue: String?)
    func clearFilter()
}

class CharactersViewController: UIViewController, CharactersFilterDelegate {
    
    //MARK: - Outlets for ViewController
    private var characters = [Character]()
    private var currentPage = 1
    private var totalPages = 34
    @IBOutlet weak var collectionView: UICollectionView!
    
    var isGridFlowLayoutUsed: Bool = false {
        didSet {
            updateButtonAppearance()
        }
    }
    
    @IBOutlet weak var gridButton: UIButton!
    
    var gridFlowLayout = GridLayout()
    var listFlowLayout = ListLayout()
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        isGridFlowLayoutUsed = true
        
        self.collectionView.reloadData()
        
        self.getCharacters()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
    }
    
    //MARK: - Grid - List and Filter Buttons Settings
    @IBAction func gridbutton(_ sender: Any) {
        
        if !isGridFlowLayoutUsed {
            isGridFlowLayoutUsed = true
            gridButton.setImage(UIImage(named: "listview"), for: UIControl.State())
        } else {
            isGridFlowLayoutUsed = false
            gridButton.setImage(UIImage(named: "gridview"), for: UIControl.State())
        }
    }
    
    @IBAction func filterCharacters(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "filters") as? FilterCharactersTableViewController
        vc?.charactersFilterDelegate = self
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    
    fileprivate func updateButtonAppearance() {
        
        let layout = isGridFlowLayoutUsed ? gridFlowLayout : listFlowLayout
        UIView.animate(withDuration: 0.2) { () -> Void in
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.setCollectionViewLayout(layout, animated: true)
        }
    }
    
    //MARK: - Fetch Rick and Morty Characters from Api
    func getCharacters() {
        
        NetworkVM.shared.fetchData(pageNumber: currentPage) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success( let rmCharacters):
                self.characters.append(contentsOf: rmCharacters.results!)
                self.totalPages = rmCharacters.info.pages
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.collectionView.reloadData()
                }
            case .failure( let error):
                print(error.rawValue)
            }
        }
    }
    
    //MARK: - Filter Section
    func filterCharactersBy(nameValue: String?, statusValue: String?) {
        
        NetworkVM.shared.filterData(name: nameValue, status: statusValue) { (result) in
            
            switch result {
            case .success(let rmCharacters):
                
                if let characters = rmCharacters.results {
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.characters = characters
                        self.collectionView.reloadData()
                        self.navigationController?.popToRootViewController(animated: true)
                        UIView.animate(withDuration: 0.5) {
                            self.collectionView.alpha = 1
                        }
                    }
                }
                
            case .failure(let error):
                print(error)
            }
            
        }
    }
    //MARK: - Check Filter Clear
    func clearFilter() {
        
        self.navigationController?.popToRootViewController(animated: true)
        
        self.collectionView.reloadData()
        self.getCharacters()
    }
    
    
}

//MARK: - CollectionView Delegate and Data Source

extension CharactersViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CharactersCollectionViewCell {
            
            //MARK: - Loading next pages to the end of the CollectionView (Pagination)
            let lastRow = self.characters.count - 1
            if indexPath.row == lastRow && currentPage < totalPages {
                currentPage += 1
                self.getCharacters()
            }
            //MARK: - Check for Favorited Characters
            if let id = self.characters[indexPath.item].id {
                
                let favorites = FavoritedCharacterUserDefault.shared.fetchFavorites()
                if FavoritedCharacterUserDefault.shared.isExistsFavorite(id: id, favorites: favorites) {
                    cell.favorited.setImage(UIImage(named: "star-2"), for: UIControl.State.normal)
                } else {
                    cell.favorited.setImage(UIImage(named: "star"), for: UIControl.State.normal)
                }
            }
            
            let character = characters[indexPath.row]
            cell.loadData(character)
            return cell
        }
        return UICollectionViewCell()
    }
    
    //MARK: - Segue for Details Page of Characters
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "details") as? CharacterDetailsViewController
        vc?.character = characters[indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
