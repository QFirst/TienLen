//
//  Cards.swift
//  TienLen
//
//  Created by Robert Edwards on 3/27/16.
//  Copyright © 2016 Panko. All rights reserved.
//

// MARK: - Card Order

extension TienLen.Card: Comparable { }
public func <(lhs: TienLen.Card, rhs: TienLen.Card) -> Bool {
    let rankOrder = TienLen.rankOrder
    let suitOrder = TienLen.suitOrder
    
    guard
        let lhsRankIndex = rankOrder.indexOf(lhs.rank),
        let rhsRankIndex = rankOrder.indexOf(rhs.rank),
        let lhsSuitIndex = suitOrder.indexOf(lhs.suit),
        let rhsSuitIndex = suitOrder.indexOf(rhs.suit) else {
            fatalError("Rank order and suit order should contain all possible types.")
    }
    
    if lhs.rank != rhs.rank {
        return lhsRankIndex < rhsRankIndex
    } else {
        return lhsSuitIndex < rhsSuitIndex
    }
}
