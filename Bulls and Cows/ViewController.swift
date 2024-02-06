//
//  ViewController.swift
//  Bulls and Cows
//
//  Created by Labe on 2024/2/2.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var guessNumbersLabel: [UILabel]!
    @IBOutlet weak var recordResultLabel1: UILabel!
    @IBOutlet weak var recordResultLabel2: UILabel!
    @IBOutlet var enterNumberButton: [UIButton]!
    @IBOutlet weak var remainingTriesLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var startGameButton: UIButton!
    @IBOutlet weak var gameOverButton: UIButton!
    
    //建立變數
    var index = 0
    var randomNumberIndex = 0
    var guessNumbers:[Int] = []
    var randomNumbers:[Int] = []
    var remainingTries = 0
    var recordResult1: String = ""
    var recordResult2: String = ""
    
    //自訂function
    //是否讓使用者使用"數字"鍵
    func canUseNumberButton(canUse: Bool) {
        if canUse == true {
            for i in 0...enterNumberButton.count - 1 {
                enterNumberButton[i].alpha = 1
                enterNumberButton[i].isEnabled = true
            }
        } else {
            for i in 0...enterNumberButton.count - 1 {
                enterNumberButton[i].alpha = 0.6
                enterNumberButton[i].isEnabled = false
            }
        }
    }
    
    //是否讓使用者使用"清除"及"送出"鍵
    func canUseClearOrSendButton(canUse: Bool) {
        clearButton.isEnabled = canUse
        sendButton.isEnabled = canUse
    }
    
    //是否讓使用者使用"開始遊戲"及"停止"鍵
    func toggleGameStartOrOverButton(start: Bool) {
        startGameButton.isEnabled = start
        gameOverButton.isEnabled = !start
    }
    
    //清除輸入的數字並重置猜數陣列
    func clearGuessNumbersLabel() {
        for i in 0...guessNumbersLabel.count - 1 {
            guessNumbersLabel[i].text = ""
        }
        index = 0
        guessNumbers = []
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        canUseNumberButton(canUse: false)
        canUseClearOrSendButton(canUse: false)
        remainingTriesLabel.text = "請點選開始遊戲❤"
        recordResultLabel1.text = ""
        recordResultLabel2.text = ""
        //調整顯示數字的Label圓角
        for i in 0...3 {
            guessNumbersLabel[i].layer.masksToBounds = true
            guessNumbersLabel[i].layer.cornerRadius = 15
        }
    }

    //數字按鍵-利用button的Title來取相對值(所以sender選擇UIButton)，在Storyboard會設定Title的字為透明色，把圖案設定成背景
    @IBAction func numberButton(_ sender: UIButton) {
        let number = sender.currentTitle!
        //把number存到顯示數字的Label陣列
        guessNumbersLabel[index].text = number
        //因為輸入進去的是String，這邊用一個新的num接String轉成Int的值
        var num = Int(number)!
        //把num加進guessNumbers(猜數)陣列
        guessNumbers.append(num)
        //如果已經按過的數字就不能再按(按鈕取消使用且顏色變淡)，因為數字0的位置在第9個，如果是用0-1會變成-1，所以這邊把０改成10，才能成功設定數字0
        if num == 0 {
            num = 10
        }
        enterNumberButton[num-1].alpha = 0.6
        enterNumberButton[num-1].isEnabled = false
        //每設定一個數字index就加1，如果大於3就不能再按數字(因為只能猜4個數)，而且要４個數字都輸入才能按"送出"鍵
        index += 1
        if index > 3 {
            canUseNumberButton(canUse: false)
            sendButton.isEnabled = true
        }
    }
    
    //清除按鍵-清除已輸入數字，並打開所有"數字"按鍵，關掉"送出"鍵
    @IBAction func deleteButton(_ sender: UIButton) {
        canUseNumberButton(canUse: true)
        sendButton.isEnabled = false
        clearGuessNumbersLabel()
    }
    
    //停止按鍵-結束遊戲，顯示剩餘次數及狀態(放棄猜數)，關掉所有輸入按鍵及清空輸入數字，重置陣列，打開"開始遊戲"按鍵
    @IBAction func gameOverButton(_ sender: Any) {
        canUseNumberButton(canUse: false)
        clearGuessNumbersLabel()
        remainingTriesLabel.text = "剩餘次數：\(remainingTries)  ☹放棄猜數"
        canUseClearOrSendButton(canUse: false)
        randomNumbers = []
        guessNumbers = []
        toggleGameStartOrOverButton(start: true)
    }
    
    //開始遊戲按鍵
    @IBAction func startGameButton(_ sender: Any) {
        //遊戲初始化，設定剩餘次數(remainingTries)、清空顯示紀錄的Label、打開數字、清除按鍵
        remainingTries = 10
        remainingTriesLabel.text = "剩餘次數：10"
        recordResult1 = ""
        recordResultLabel1.text = recordResult1
        recordResult2 = ""
        recordResultLabel2.text = recordResult2
        canUseNumberButton(canUse: true)
        clearButton.isEnabled = true
        
        //產生答案-亂數陣列(randomNumbers)
        randomNumbers = []
        for _ in 1...4 {
            var randomNumber = Int.random(in: 0...9)
            while randomNumbers.contains(randomNumber) {
                randomNumber = Int.random(in: 0...9)
            }
            randomNumbers.append(randomNumber)
        }
        //開始遊戲後就打開"停止"按鍵，並關掉"開始遊戲"按鍵
        toggleGameStartOrOverButton(start: false)
        //方便測試用
        print(randomNumbers)
    }
    
    //送出按鍵
    @IBAction func sendButton(_ sender: Any) {
        //剩餘次數減1
        remainingTries -= 1
        //建立變數用於顯示猜數結果，比較猜數陣列與亂數陣列每個位置的數字是否相同(a就加1)，或是猜數陣列在亂數陣列是否有相同數字(b就加1)
        var a = 0
        var b = 0
        for i in 0...3 {
            if guessNumbers[i] == randomNumbers[i] {
                a += 1
            } else if randomNumbers.contains(guessNumbers[i]) {
                b += 1
            }
        }
        
        //使用map把Int轉換成String，再用joined()把字符串接成一個字串
        let gurssNumberString = guessNumbers.map { String($0) }.joined()
        
        //因為畫面分成2個Label顯示猜數紀錄，所以這邊各分配了5個紀錄，因為有換行的問題(會因畫面超出，顯示出...)，所以在第５行的地方會把換行拿掉
        if remainingTries > 5 {
            recordResult1 += "\(gurssNumberString) \(a)A\(b)B\n"
            recordResultLabel1.text = recordResult1
        } else if remainingTries == 5 {
            recordResult1 += "\(gurssNumberString) \(a)A\(b)B"
            recordResultLabel1.text = recordResult1
        } else if remainingTries < 5, remainingTries > 0 {
            recordResult2 += "\(gurssNumberString) \(a)A\(b)B\n"
            recordResultLabel2.text = recordResult2
        } else if remainingTries == 0 {
            recordResult2 += "\(gurssNumberString) \(a)A\(b)B"
            recordResultLabel2.text = recordResult2
        }
        
        //顯示遊戲結果，如果a=4就過關，如果剩餘次數=0就輸了，遊戲還沒結束就只顯示剩餘次數，並在最後清空輸入數字及猜數陣列
        if a == 4 {
            remainingTriesLabel.text = "剩餘次數：\(remainingTries)  ☺恭喜過關"
            canUseNumberButton(canUse: false)
            canUseClearOrSendButton(canUse: false)
            toggleGameStartOrOverButton(start: true)
        } else if remainingTries == 0 {
            remainingTriesLabel.text = "遊戲結束！ ☹再接再厲"
            canUseNumberButton(canUse: false)
            canUseClearOrSendButton(canUse: false)
            toggleGameStartOrOverButton(start: true)
        } else {
            remainingTriesLabel.text = "剩餘次數：\(remainingTries)"
            canUseNumberButton(canUse: true)
            sendButton.isEnabled = false
        }
        clearGuessNumbersLabel()
        guessNumbers = []
    }
}

