//
//  ImageGalleryViewController.swift
//  ECommerceApp
//
//  Created by Anton Novoselov on 19/11/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit
import ImagePicker
import IDMPhotoBrowser

protocol ImageGalleryViewControllerDelegate: class {
    func didFinishEditingImages(allImages: [UIImage])
}

class ImageGalleryViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var property: Property?
    var allImages: [UIImage] = []
    
    weak var delegate: ImageGalleryViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if property != nil {
            loadImages()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    
    override func viewWillLayoutSubviews() {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    
    
    func loadImages() {
        // image
        
        self.allImages = []
        
        if let imageLinks = property?.imageLinks, imageLinks != "" {
            
            downloadImages(urls: imageLinks, withBlock: { (images) in
                if let images = images {
                    self.allImages = images
                }
                
                self.activityIndicator.stopAnimating()
                self.collectionView.reloadData()
            })
            
        } else {
            // we have no images
            self.activityIndicator.stopAnimating()
            self.collectionView.reloadData()
        }
    }

    
    // MARK: - ACTIONS
    @IBAction func actionBackButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    
    
    @IBAction func actionCameraButtonTapped(_ sender: Any) {
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = kMAXIMAGENUMBER
        
        self.present(imagePickerController, animated: true)
        
    }
    
    @IBAction func actionSaveButtonTapped(_ sender: Any) {
        delegate?.didFinishEditingImages(allImages: allImages)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    

}


extension ImageGalleryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allImages.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCollectionViewCell", for: indexPath) as! GalleryCollectionViewCell
        
        cell.configureCell(image: allImages[indexPath.row], indexPath: indexPath)
        
        cell.delegate = self
        
        return cell
        
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let photos = IDMPhoto.photos(withImages: allImages)
        
        let browser = IDMPhotoBrowser(photos: photos)
        
        browser?.setInitialPageIndex(UInt(indexPath.row))
        
        self.present(browser!, animated: true, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width / 2 - 8, height: CGFloat(115))
        
    }
    
}

extension ImageGalleryViewController: GalleryCollectionViewCellDelegate {
    func didTapDeleteButton(indexPath: IndexPath) {
        self.allImages.remove(at: indexPath.row)
        self.collectionView.reloadData()
        
    }
}

extension ImageGalleryViewController: ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        allImages += images
        
        self.collectionView.reloadData()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}




