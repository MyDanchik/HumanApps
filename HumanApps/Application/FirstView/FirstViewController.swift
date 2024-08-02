import UIKit

class FirstViewController: UIViewController {
    var viewModel: FirstViewModel!
    
    private let frameView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.yellow.cgColor
        view.layer.borderWidth = 2
        view.clipsToBounds = true
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = UIColor(.black)
        button.setImage(UIImage(systemName: "photo.badge.plus"), for: .normal)
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 35)
        button.setPreferredSymbolConfiguration(symbolConfiguration, forImageIn: .normal)
        return button
    }()
    
    private let applyFilterSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Original", "B&W", "Sepia", "Negative", "Blur"])
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = UIColor(.black)
        button.setImage(UIImage(systemName: "square.and.arrow.down"), for: .normal)
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 35)
        button.setPreferredSymbolConfiguration(symbolConfiguration, forImageIn: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        setupActions()
        setupGestures()
    }
    
    private func setupUI() {
        view.addSubview(frameView)
        frameView.addSubview(imageView)
        view.addSubview(selectPhotoButton)
        view.addSubview(applyFilterSegmentedControl)
        view.addSubview(saveButton)
        
        frameView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        selectPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        applyFilterSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            selectPhotoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            selectPhotoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
        
            saveButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            frameView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            frameView.topAnchor.constraint(equalTo: selectPhotoButton.bottomAnchor, constant: 30),
            frameView.widthAnchor.constraint(equalToConstant: 300),
            frameView.heightAnchor.constraint(equalToConstant: 450),
            
            imageView.topAnchor.constraint(equalTo: frameView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: frameView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: frameView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: frameView.bottomAnchor),

            applyFilterSegmentedControl.topAnchor.constraint(equalTo: frameView.bottomAnchor, constant: 30),
            applyFilterSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            applyFilterSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            applyFilterSegmentedControl.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func setupActions() {
        selectPhotoButton.addTarget(self, action: #selector(selectPhoto), for: .touchUpInside)
        applyFilterSegmentedControl.addTarget(self, action: #selector(applyFilter), for: .valueChanged)
        saveButton.addTarget(self, action: #selector(savePhoto), for: .touchUpInside)
    }
    
    private func setupGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture))
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotateGesture))
        
        imageView.addGestureRecognizer(panGesture)
        imageView.addGestureRecognizer(pinchGesture)
        imageView.addGestureRecognizer(rotateGesture)
    }
    
    @objc private func selectPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc private func applyFilter() {
        guard let originalImage = viewModel.originalImage else { return }
        
        switch applyFilterSegmentedControl.selectedSegmentIndex {
        case 0:
            imageView.image = originalImage
        case 1:
            if let filteredImage = viewModel.applyBlackAndWhiteFilter(to: originalImage) {
                imageView.image = filteredImage
            }
        case 2:
            if let filteredImage = viewModel.applySepiaFilter(to: originalImage) {
                imageView.image = filteredImage
            }
        case 3:
            if let filteredImage = viewModel.applyNegativeFilter(to: originalImage) {
                imageView.image = filteredImage
            }
        case 4:
            if let filteredImage = viewModel.applyBlurFilter(to: originalImage) {
                imageView.image = filteredImage
            }
        default:
            break
        }
    }
    
    @objc private func savePhoto() {
        let renderer = UIGraphicsImageRenderer(bounds: frameView.bounds)
        let renderedImage = renderer.image { context in
            frameView.layer.render(in: context.cgContext)
        }
        
        UIImageWriteToSavedPhotosAlbum(renderedImage, nil, nil, nil)
    }
    
    @objc private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: frameView)
        imageView.transform = imageView.transform.translatedBy(x: translation.x, y: translation.y)
        gesture.setTranslation(.zero, in: frameView)
    }
    
    @objc private func handlePinchGesture(gesture: UIPinchGestureRecognizer) {
        imageView.transform = imageView.transform.scaledBy(x: gesture.scale, y: gesture.scale)
        gesture.scale = 1.0
    }
    
    @objc private func handleRotateGesture(gesture: UIRotationGestureRecognizer) {
        imageView.transform = imageView.transform.rotated(by: gesture.rotation)
        gesture.rotation = 0
    }
}

extension FirstViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            viewModel.originalImage = selectedImage
            imageView.image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
