//
//  ViewController.swift
//  UpDownGame
//
//  Created by 박준우 on 1/9/25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var gameButton: UIButton!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textField: UITextField!
    
    let gameManager: GameManager = GameManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDefaultView()
        configureTitleLabel()
        configureGameButton()
        configureCenterView()
        configureSubTitle()
        configureImageView()
        configureTextField()
        configureCollectionView()
    }
    
    @IBAction func tapGameButton(_ sender: UIButton) {
        switch gameManager.gameState {
        case .settingGame:
            gameManager.gameState = .enterGame
            gameManager.setRandomNumber()
            collectionView.reloadData()
            setAllUI()
        case .enterGame:
            setTitleLabel()
            if gameManager.isCorrect {
                if gameManager.isEnd {
                    gameManager.resetGame()
                    setAllUI()
                } else {
                    gameManager.tryCount += 1
                    gameManager.isEnd = true
                    gameButton.setTitle("다시하기", for: .normal)
                }
            } else {
                gameManager.reloadNumberArray()
                setCollectionView()
                collectionView.reloadData()
                setGameButton()
            }
            setSubTitle()
        }
    }
    
    func setAllUI() {
        setSubTitle()
        setImageView()
        setTextField()
        setGameButton()
        setTitleLabel()
        setCollectionView()
    }
}

// MARK: - UI 구성 메서드
extension ViewController {
    
    func configureDefaultView() {
        view.backgroundColor = UIColor.background
    }
    
    func configureTitleLabel() {
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 48)

        setTitleLabel()
    }
    
    func setTitleLabel() {
        titleLabel.text = gameManager.titleString
    }
    
    func configureGameButton() {
        gameButton.setTitleColor(UIColor.white, for: .disabled)
        gameButton.setTitleColor(UIColor.white, for: .normal)
        
        setGameButton()
    }
    
    func setGameButton() {
        gameButton.setTitle(gameManager.gameState.gameButtonString, for: .normal)
        
        if (gameManager.gameState == .enterGame && gameManager.selectedNumber == nil) || (gameManager.gameState == .settingGame && gameManager.maxNumber == nil) {
            gameButton.backgroundColor = UIColor.lightGray
            gameButton.isEnabled = false
        } else {
            gameButton.backgroundColor = UIColor.black
            gameButton.isEnabled = true
        }
    }
    
    func configureCenterView() {
        centerView.backgroundColor = UIColor.clear
        setCollectionView()
    }
    
    func configureSubTitle() {
        subTitleLabel.textAlignment = .center
        setSubTitle()
    }
    
    func setSubTitle() {
        switch gameManager.gameState {
        case .settingGame:
            subTitleLabel.font = UIFont.systemFont(ofSize: 20)
            subTitleLabel.text = gameManager.gameState.subTitleString
        case .enterGame:
            subTitleLabel.font = UIFont.boldSystemFont(ofSize: 20)
            subTitleLabel.text = "\(gameManager.gameState.subTitleString)\(gameManager.tryCount)"
        }
    }
    
    func configureImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.image = .emotion1
        
        setImageView()
    }
    
    func setImageView() {
        switch gameManager.gameState {
        case .settingGame:
            imageView.isHidden = false
        case .enterGame:
            imageView.isHidden = true
        }
    }
}

// MARK: - CollectionView 관련 구현
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func configureCollectionView() {
        collectionView.backgroundColor = .clear
        
        let sectionSpacing: CGFloat = 8
        let cellSpacing: CGFloat = 8
        let itemCount: CGFloat = 6.0
        
        var itemWidth: CGFloat {
            let width: CGFloat = UIScreen.main.bounds.width
            return (width - (sectionSpacing * 2) - (cellSpacing * (itemCount - 1))) / itemCount
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: sectionSpacing, bottom: 0, right: sectionSpacing)
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        collectionView.collectionViewLayout = layout

        connectCollectionView()
        
        setCollectionView()
    }
    
    func connectCollectionView() {
        let xib = UINib(nibName: CustomCollectionViewCell.id, bundle: nil)
        collectionView.register(xib, forCellWithReuseIdentifier: CustomCollectionViewCell.id)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func setCollectionView() {
        switch gameManager.gameState {
        case .settingGame:
            collectionView.isHidden = true
        case .enterGame:
            collectionView.isHidden = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        gameManager.numberArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.id, for: indexPath) as! CustomCollectionViewCell
        cell.numberLabel.text = "\(gameManager.numberArray[indexPath.item])"
        
        if let selectedNumber = gameManager.selectedNumber, selectedNumber - 1 == indexPath.item {
            cell.configureSelectedCell()
        } else {
            cell.configureUnSelectedCell()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if !gameManager.isEnd {
            let selectedCell = collectionView.cellForItem(at: indexPath) as! CustomCollectionViewCell
            if let selectedNumber = gameManager.selectedNumber {
                if selectedNumber == Int(selectedCell.numberLabel.text!) {
                    selectedCell.configureUnSelectedCell()
                    
                    gameManager.setSelectedNumber(nil)
                } else {
                    if let unselectedCell = collectionView.cellForItem(at: IndexPath(item: gameManager.numberArray.firstIndex(of: selectedNumber)!, section: 0)) as? CustomCollectionViewCell {
                        
                        unselectedCell.configureUnSelectedCell()
                    }
                    
                    selectedCell.configureSelectedCell()
                    
                    gameManager.setSelectedNumber(selectedCell.numberLabel.text)
                }
            } else {
                selectedCell.configureSelectedCell()
                
                gameManager.setSelectedNumber(selectedCell.numberLabel.text)
            }
            setGameButton()
        }
    }
}

// MARK: - UITextField 관련
extension ViewController: UITextFieldDelegate {
    func configureTextField() {
        textField.placeholder = "숫자를 입력해주세요."
        textField.backgroundColor = UIColor.clear
        textField.borderStyle = .none
        textField.tintColor = UIColor.black
        textField.textAlignment = .center
        let line = UIView(frame: CGRect(x: 0, y: textField.frame.height, width: textField.frame.width - 8, height: 2))
        line.backgroundColor = UIColor.systemGray6
        textField.font = UIFont.boldSystemFont(ofSize: 24)
        textField.addSubview(line)
        connectTextField()
        setTextField()
    }
    
    func setTextField() {
        switch gameManager.gameState {
        case .settingGame:
            textField.isHidden = false
        case .enterGame:
            textField.text = nil
            textField.isHidden = true
        }
    }
    
    func connectTextField() {
        textField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        gameManager.setMaxNumber(textField.text ?? "")
        setGameButton()
        return true
    }
}
