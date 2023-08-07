//
//  BeerViewController.swift
//  SeSAC_4Week_assignment
//
//  Created by 이은서 on 2023/08/07.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class BeerViewController: UIViewController {

    @IBOutlet var beerImageView: UIImageView!
    @IBOutlet var beerNameLabel: UILabel!
    @IBOutlet var matchingLabel: UILabel!
    @IBOutlet var descripLabel: UILabel!
    @IBOutlet var emptyLabel: UILabel!
    
    @IBOutlet var randomButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beerNameLabel.textAlignment = .center
        matchingLabel.numberOfLines = 0
        matchingLabel.textAlignment = .center
        matchingLabel.text = ""
        descripLabel.numberOfLines = 0
        emptyLabel.text = ""
        emptyLabel.textAlignment = .center
        randomButton.setTitle("새 정보 불러오기", for: .normal)
        callRequest()
    }

    func callRequest() {
        let url = "https://api.punkapi.com/v2/beers/random"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                               
                //이미지 불러오기
                print(json[0]["image_url"].stringValue)
                let imageURL = URL(string: "\(json[0]["image_url"].stringValue)")
                if json[0]["image_url"].stringValue == "" {
                    self.emptyLabel.text = "이미지가 없습니다."
                } else {
                    self.beerImageView.kf.setImage(with: imageURL)
                }
                //이름 가져오기
                self.beerNameLabel.text = json[0]["name"].stringValue
                
                //페어링 음식 가져오기
                for i in 0...2 {
                    self.matchingLabel.text! += json[0]["food_pairing"][i].stringValue
                    self.matchingLabel.text! += "\n"
                }
                
                //설명 가져오기
                self.descripLabel.text = json[0]["description"].stringValue
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func randomButtonTapped(_ sender: UIButton) {
        beerNameLabel.text = ""
        emptyLabel.text = ""
        descripLabel.text = ""
        matchingLabel.text = ""
        beerImageView.image = nil
        callRequest()
    }
}
