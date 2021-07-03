import UIKit
import Foundation

class Game{
    
    public let game_images = [#imageLiteral(resourceName: "Chen"),#imageLiteral(resourceName: "DrawRanger"),#imageLiteral(resourceName: "Kotel"),#imageLiteral(resourceName: "GyroCopter"),#imageLiteral(resourceName: "Lina"),#imageLiteral(resourceName: "Silencer"),#imageLiteral(resourceName: "Luna"),#imageLiteral(resourceName: "Invoker")]

    private let backCard = #imageLiteral(resourceName: "CardBack")
    private var successCounter = 0
    private var timer = Timer()
    private var board:[UIImage] = []
    private var score = 0

    public func getGameImagesEasyMode() -> [UIImage] {
        return self.game_images
    }

    public func getBoardByIndex(index: Int) -> UIImage {
        return self.board[index]
    }
    
    public func getBackCard() -> UIImage {
        return self.backCard
    }
    
    public func getSuccessCounter() -> Int {
        return self.successCounter
    }
    
    public func getScore() -> Int {
        return self.score
    }

    public func setScore(score: Int){
        self.score += score
    }
    
    public func setSuccessCounter(successCounter: Int) {
        self.successCounter = successCounter
    }
    
    func initGame(cards: [UIImage]){
        board.removeAll()
        shuffle(cards: cards)
        successCounter = 0
    }
    
    func addMove(){
        successCounter += 1
    }
    
    func shuffle(cards: [UIImage]){
        for image in cards {
            self.board.append(image)
            self.board.append(image)
        }
        self.board.shuffle()
    }
    
    func openCard(card: UIButton){
        UIView.transition(with: card, duration: 0.5, options: .transitionFlipFromLeft,
                          animations: nil, completion: nil)
    }
    
    
    func closeCard(card: UIButton){
        card.setImage(self.backCard, for: .normal)
        UIView.transition(with: card, duration: 0.5, options: .transitionFlipFromRight,
                          animations: nil, completion: nil)
    }
    
    func setTimer(on: Bool, timerLabel: UILabel){
        if(on) {//run timer each second
            var duration = 0
            
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            duration += 1
            let mins = duration / 60 % 60
            let secs = duration % 60
            timerLabel.text = ((mins<10) ? "0" : "") + String(mins) + ":" + ((duration<10) ? "0" : "") + String(secs) + " S"
            }
        }
        else {
            timerLabel.text = "00:00 S"
            timer.invalidate()//pause
        }
    }
    
}
