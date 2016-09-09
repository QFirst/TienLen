//
//  Hands.swift
//  TienLen
//
//  Created by Robert Edwards on 2/14/16.
//  Copyright © 2016 Panko. All rights reserved.
//

import PlayingCards

public typealias Combo = Set<TienLen.Card>
public typealias Run = Array<TienLen.Card>

private let MinimumRunCount = 3

// MARK: - Hands

extension TienLen.Hand {
    public var runs: [Run] { return cards.runs }
    public var longestRun: Run? { return cards.longestRun }
    public var combos: Set<Combo> { return cards.combos }
}

extension Sequence where Iterator.Element == TienLen.Card {

    public var longestRun: Run? {
        return runs.sorted { $0.0.count > $0.1.count }.first
    }

    public var runs: [Run] {
        var runs = [Run]()

        var currentRun: Run?

        let sortedCards = Array(self).sorted() { $0 < $1 }
        var remainingCards = Set(self)

        for card in sortedCards where remainingCards.contains(card) {

            var currentRank = card.rank

            while let nextRank = next(rank: currentRank) {

                let successors = remainingCards.filter() { $0.rank == nextRank }
                if let nextCard = successors.first {
                    if currentRun != nil {
                        currentRun?.append(nextCard)
                    } else {
                        currentRun = Run([card, nextCard])
                    }
                } else {
                    break
                }

                currentRank = nextRank

            }
            
            if let currentRun = currentRun, currentRun.count >= MinimumRunCount {
                runs.append(currentRun)
                for card in currentRun {
                    remainingCards.remove(card)
                }
            }
            currentRun = nil

        }
        return runs
    }

    public var combos: Set<Combo> {
        var combos = Set<Combo>()
        for card in self {
            let matches = filter() { $0.rank == card.rank }
            if matches.count > 0 {
                let newCombo = matches.reduce(Combo([card])) { $0.union(CollectionOfOne($1)) }
                combos.insert(newCombo)
            }
        }
        return combos
    }

    private func next(rank: Rank) -> Rank? {
        let ranks = TienLen.rankOrder
        guard let rankIndex = ranks.index(of: rank) else {
            fatalError("Rank index must be found")
        }
        let successorIndex = (rankIndex + 1)

        guard ranks.indices.contains(successorIndex) && successorIndex > 0 else {
            return nil
        }
        return ranks[successorIndex]
    }
}
