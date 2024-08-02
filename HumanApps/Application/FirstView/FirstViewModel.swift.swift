import UIKit

class FirstViewModel {
    var originalImage: UIImage?
    
    func applyBlackAndWhiteFilter(to image: UIImage) -> UIImage? {
        guard let filter = CIFilter(name: "CIPhotoEffectMono") else { return nil }
        let ciImage = CIImage(image: image)
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        guard let outputImage = filter.outputImage else { return nil }
        return UIImage(ciImage: outputImage)
    }
    
    func applySepiaFilter(to image: UIImage) -> UIImage? {
        let context = CIContext()
        guard let ciImage = CIImage(image: image) else { return nil }
        let sepiaFilter = CIFilter(name: "CISepiaTone")
        sepiaFilter?.setValue(ciImage, forKey: kCIInputImageKey)
        sepiaFilter?.setValue(0.8, forKey: kCIInputIntensityKey)
        
        guard let outputImage = sepiaFilter?.outputImage,
              let cgImage = context.createCGImage(outputImage, from: ciImage.extent) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }

    func applyNegativeFilter(to image: UIImage) -> UIImage? {
        let context = CIContext()
        guard let ciImage = CIImage(image: image) else { return nil }
        let negativeFilter = CIFilter(name: "CIColorInvert")
        negativeFilter?.setValue(ciImage, forKey: kCIInputImageKey)

        guard let outputImage = negativeFilter?.outputImage,
              let cgImage = context.createCGImage(outputImage, from: ciImage.extent) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }

    func applyBlurFilter(to image: UIImage) -> UIImage? {
        let context = CIContext()
        guard let ciImage = CIImage(image: image) else { return nil }
        let blurFilter = CIFilter(name: "CIGaussianBlur")
        blurFilter?.setValue(ciImage, forKey: kCIInputImageKey)
        blurFilter?.setValue(10.0, forKey: kCIInputRadiusKey) // Радиус размытия
        
        guard let outputImage = blurFilter?.outputImage,
              let cgImage = context.createCGImage(outputImage, from: ciImage.extent) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}
