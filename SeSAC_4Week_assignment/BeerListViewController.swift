//
//  BeerListViewController.swift
//  SeSAC_4Week_assignment
//
//  Created by 이은서 on 2023/08/08.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

struct Beer {
    var name: String
    var imageURL: String
    var description: String
}

class BeerListViewController: UIViewController {
    
    @IBOutlet var beerListCollectionView: UICollectionView!
    var beerList: [Beer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beerListCollectionView.dataSource = self
        beerListCollectionView.delegate = self
        callRequest()
        configLayout()
    }

    func callRequest() {
        let url = "https://api.punkapi.com/v2/beers"
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
               
                for item in json.arrayValue {
                    let name = item["name"].stringValue
                    let image = item["image_url"].stringValue
                    let description = item["description"].stringValue
                    let beer = Beer(name: name, imageURL: image, description: description)
                    self.beerList.append(beer)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
extension BeerListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("셀 만들어짐")
        return beerList.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "beerCell", for: indexPath) as? BeerCollectionViewCell else { return UICollectionViewCell() }
        cell.beerNameLabel.text = beerList[indexPath.item].name
        cell.beerNameLabel.textAlignment = .center
        
        cell.beerDescriptionLabel.text = beerList[indexPath.row].description
        cell.beerDescriptionLabel.numberOfLines = 0
        
        guard let imageURL = URL(string: "\(beerList[indexPath.row].imageURL)") else { return UICollectionViewCell() }
        if "\(imageURL)" == "" {
            cell.emptyImageLabel.text = "이미지가 없습니다."
        } else {
            cell.beerImageView.kf.setImage(with: imageURL)
        }
        print("만들어짐")
        return cell
    }
    
    func configLayout() {
        let layout = UICollectionViewFlowLayout()
        let space: CGFloat = 12
        let width = UIScreen.main.bounds.width - 16 * 3
        
        layout.itemSize = .init(width: width / 2, height: width / 2 + 30)
        layout.minimumLineSpacing = space
        layout.minimumInteritemSpacing = space
        
    }
    
}
