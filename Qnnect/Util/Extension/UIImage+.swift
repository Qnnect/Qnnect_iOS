//
//  UIImage+.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/23.
//

import UIKit

extension UIImage {
    func with(_ insets: UIEdgeInsets) -> UIImage {
          let targetWidth = size.width + insets.left + insets.right
          let targetHeight = size.height + insets.top + insets.bottom
          let targetSize = CGSize(width: targetWidth, height: targetHeight)
          let targetOrigin = CGPoint(x: insets.left, y: insets.top)
          let format = UIGraphicsImageRendererFormat()
          format.scale = scale
          let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
          return renderer.image { _ in
              draw(in: CGRect(origin: targetOrigin, size: size))
          }.withRenderingMode(renderingMode)
      }
    
    fileprivate func resizeImage(image: UIImage!, targetHeight: CGFloat) -> UIImage {
        // Get current image size
        let size = image.size

        // Compute scaled, new size
        let heightRatio = targetHeight / size.height
        let newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Create new image
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        image?.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        // Return new image
        return newImage!
    }

}
