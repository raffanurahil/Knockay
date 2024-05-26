//
//  ResultModel.swift
//  Knockay Watch App
//
//  Created by Addarda Raffanurahil Aufa on 24/05/24.
//

import UIKit

class Result {
    var stickerName: String
    var stickerImage: String
    var minScore: Int
    var maxScore: Int
    var description: String
    
    init(stickerName: String, stickerImage: String, minScore: Int, maxScore: Int, description: String) {
        self.stickerName = stickerName
        self.stickerImage = stickerImage
        self.minScore = minScore
        self.maxScore = maxScore
        self.description = description
    }
    
    init(){
        self.stickerName = ""
        self.stickerImage = ""
        self.minScore = 0
        self.maxScore = 0
        self.description = ""
    }
}

var resultsArray: [Result] = [
Result(stickerName: "Boxham", stickerImage: "StickerBoxham", minScore: 0, maxScore: 99, description: "Boxham just happened to be here out of nowhere. Me, you, nobody even know if it has the guts to punch.")
]
