//
//  ViewController.swift
//  UICollectionViewExperimental
//
//  Created by Corry Timothy on 16/7/2023.
//

import UIKit


let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height

class ViewController: UIViewController {

    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let layout = CustomLayout()
    
    var itemW: CGFloat {
        return screenWidth * 0.4
    }
    
    var itemH: CGFloat {
        return itemW * 1.45
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                let indexPath = IndexPath(item: 1, section: 0)
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
                layout.currentPage = indexPath.item
                layout.previousOffset = layout.updateOffset(collectionView)
        
        
                if let cell = collectionView.cellForItem(at: indexPath) {
                    transformCell(cell)
                }
    }
    
}

extension ViewController {
    private func setupViews() {
        collectionView.backgroundColor = .cyan
        collectionView.decelerationRate = .fast
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0.0, left: 50.0, bottom: 0.0, right: 50.0)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        collectionView.collectionViewLayout = layout
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 50.0
        layout.minimumInteritemSpacing = 50.0
        layout.itemSize.width = itemW
        
        
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: screenWidth),
        ])
    }
}


extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.contentView.backgroundColor = .red
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == layout.currentPage {
            print("didSelectItemAt")
        } else {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
            layout.currentPage = indexPath.item
            layout.previousOffset = layout.updateOffset(collectionView)
            setupCell()
        }
        
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemW, height: itemH)
    }
}

extension ViewController {
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("didselectitemat")
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate {
            setupCell()
        }
    }
    
    
    private func setupCell() {
        let indexPath = IndexPath(item: layout.currentPage, section: 0)
        if let cell = collectionView.cellForItem(at: indexPath) {
            transformCell(cell)
        }
    }
    
    private func transformCell(_ cell: UICollectionViewCell, isEffect: Bool = true) {
        if !isEffect {
            cell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            return
        }
        
        UIView.animate(withDuration: 0.2) {
            cell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        
        for otherCell in collectionView.visibleCells {
            if let indexPath = collectionView.indexPath(for: otherCell) {
                if indexPath.item != layout.currentPage {
                    UIView.animate(withDuration: 0.2) {
                        otherCell.transform = .identity
                    }
                }
            }
        }
    }
}
