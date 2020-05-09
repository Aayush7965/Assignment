//
//  TableViewController.swift
//  Project
//
//  Created by Aayush Pareek on 09/05/20.
//  Copyright © 2020 Aayush Pareek. All rights reserved.
//

import UIKit
import SDWebImage

class TableViewController: UITableViewController {
    
    var cardDataModel = CardDataModel()
    var cardArray = [CardData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: K.nibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        cardDataModel.delegate = self
        cardDataModel.performRequest()
    }
    
    //MARK:- TableView Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! CardViewCell
        let cardInfo = cardArray[indexPath.row]
        cell.nameLabel.text = cardInfo.name
        cell.ageLabel.text = cardInfo.age
        cell.locationLabel.text = cardInfo.location
        if let url = URL(string: cardInfo.url) {
            cell.profileImageView.sd_setImage(with: url)
        }
        return cell
    }
}

//MARK:- CardDataModelDelegate

extension TableViewController: CardDataModelDelegate {
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func didUpdateData(cardDataModel: CardDataModel, cardDataArray: [CardData]) {
        DispatchQueue.main.async {
            self.cardArray = cardDataArray
            self.tableView.reloadData()
        }
    }
}

