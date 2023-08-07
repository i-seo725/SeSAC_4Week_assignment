//
//  ViewController.swift
//  SeSAC_4Week_assignment
//
//  Created by 이은서 on 2023/08/07.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    var list: [Int] = Array(1...1079).reversed()
    
    @IBOutlet var selectTextField: UITextField!
    @IBOutlet var resultLabel: UILabel!
    
    let pickerView = UIPickerView()
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        selectTextField.inputView = pickerView
        selectTextField.tintColor = .clear
        
        resultLabel.textAlignment = .center
        callRequest()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        callRequest(num: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(list[row])"
    }
    
    func callRequest(num: Int = 1079) {
        var url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(num)"
        var resultNum = ""
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                for i in 1...6 {
                    resultNum += json["drwtNo\(i)"].stringValue
                    resultNum += " "
                }
                resultNum += json["bnusNo"].stringValue
                self.resultLabel.text = resultNum
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
