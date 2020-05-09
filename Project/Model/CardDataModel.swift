//
//  CardDataModel.swift
//  Project
//
//  Created by Aayush Pareek on 09/05/20.
//  Copyright © 2020 Aayush Pareek. All rights reserved.
//

import Foundation

protocol CardDataModelDelegate {
    func didUpdateData(cardDataModel: CardDataModel,cardDataArray: [CardData])
    func didFailWithError(error: Error)
}

class CardDataModel {

    var delegate: CardDataModelDelegate?
    
    func performRequest() {
        let dataURL = K.url
        if let url = URL(string: dataURL) {
            let session = URLSession(configuration: .default)
            let dataTask = session.dataTask(with: url) { (data, response, err) in
                if let err = err {
                    self.delegate?.didFailWithError(error: err)
                    return
                }
                if let safeData = data {
                    if let data = self.parseJSON(with: safeData) {
                        self.delegate?.didUpdateData(cardDataModel: self, cardDataArray: data)
                    }
                }
            }
            dataTask.resume()
        }
    }

    func parseJSON(with data: Data) -> [CardData]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([CardData].self, from: data)
            return decodedData
        } catch {
            self.delegate?.didFailWithError(error: error)
        }
        return nil
    }
}
