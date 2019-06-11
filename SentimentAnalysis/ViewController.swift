//
//  ViewController.swift
//  SentimentAnalysis
//
//  Created by Micah Yong on 4/25/19.
//  Copyright © 2019 iosdecal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var sentimentLabel: UILabel!
    @IBOutlet weak var inputTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextView.becomeFirstResponder()
        // You might want to initialize some things - but it's up to you.
    }
    
    @IBAction func analyzeButtonPressed(_ sender: Any) {
        guard let textToAnalyze = inputTextView.text else { return }
        // Your code here
        let inputHistogram : [String : Double] = inputToHistogram(textToAnalyze)
        let mlModel = SentimentPolarity()
        
        let inputSentiment = SentimentPolarityInput(input: inputHistogram)
        do {
            let outputSentiment = try? mlModel.prediction(input: inputSentiment)
            sentimentLabel.text = outputSentiment?.classLabel
        }
    }
    
    func inputToHistogram(_ text: String) -> [String : Double] {
        var histogram : [String : Double] = [String: Double]()
        let cleanStrings : [String] = cleanTextToArray(text)
        for word in cleanStrings {
            if let val = histogram[word] {
                histogram[word] = val + 1.0
            } else {
                histogram[word] = 1.0
            }
        }
        return histogram
    }
    
    func cleanTextToArray(_ text: String) -> [String] {
        return text.lowercased().words
    }
    
}

extension String {
    var words: [String] {
        return components(separatedBy: .punctuationCharacters)
            .joined()
            .components(separatedBy: .whitespaces)
            .filter{!$0.isEmpty}
    }
}

