//
//  ViewController.swift
//  IndMoney_Test
//
//  Created by Personal on 19/11/22.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet var firstPerson: UILabel!
    @IBOutlet var secondPerson: UILabel!
    @IBOutlet var rowField: UITextField!
    @IBOutlet var columnField: UITextField!
    
    var defaultLimit: Position = .init(row: 4, column: 5)
    
    var datasource: SwapeGame? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let policePosition: Position = Util.generatePosition(boundaries: self.defaultLimit, nextPersonPosition: nil)
        let thiefPosition: Position = Util.generatePosition(boundaries: self.defaultLimit, nextPersonPosition: policePosition)
       
        datasource = SwapeGame(police: policePosition,
                               thief: thiefPosition,
                               boundaries: self.defaultLimit)
        

 
        
    }

    @IBAction func changePosition() {
      
        if (self.rowField.text?.isEmpty ?? true) || (self.columnField.text?.isEmpty ?? true) { return }
        self.datasource?.boundaries.row = Int(self.rowField.text ?? "") ?? .zero
        self.datasource?.boundaries.column = Int(self.columnField.text ?? "") ?? .zero
        
        
        self.datasource?.didUpdatePosition()
        self.updateUIData()
    }
    
    func updateUIData() {
        guard let datasource = self.datasource else { return }
        self.firstPerson.text = "Standing at \(datasource.police.row) \(datasource.police.column)"
        self.secondPerson.text = "Standing at \(datasource.thief.row) \(datasource.thief.column)"
    }

}

struct Position {
    var row: Int
    var column: Int
}

class SwapeGame {
    
    var police: Position
    var thief: Position
    var boundaries: Position
    
    init(police: Position, thief: Position, boundaries: Position) {
        self.police = police
        self.thief = thief
        self.boundaries = boundaries
    }
    
    func didUpdatePosition() {
        self.police = Util.generatePosition(boundaries: self.boundaries, nextPersonPosition: self.police)
        self.thief = Util.generatePosition(boundaries: self.boundaries, nextPersonPosition: self.thief)
    }
    
}

class Util {
    
    static func generatePosition(boundaries: Position, nextPersonPosition: Position?) -> Position {
        guard let nextPosition = nextPersonPosition else { return .init(row: 0, column: 0) }
        let generatedPersonRandomIndex = Util.generateIndex(range: boundaries)
        let isValidPosition = Util.checkAlignment(person1: generatedPersonRandomIndex, person2: nextPosition)
        return isValidPosition ? generatedPersonRandomIndex : Util.generatePosition(boundaries: boundaries,
                                                                                      nextPersonPosition: nextPersonPosition)
        
    }
    
    static func generateIndex(range: Position) -> Position {
        let random_row = Int.random(in: 0...range.row)
        let random_column = Int.random(in: 0...range.column)
        
        return Position(row: random_row, column: random_column)
    }
    
    static func checkAlignment(person1: Position , person2: Position) -> Bool {
        return person1.column != person2.column && person1.row != person2.row
    }
    
}


