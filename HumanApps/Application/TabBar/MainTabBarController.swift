import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstViewController = FirstViewController()
        let firstViewModel = FirstViewModel()
        firstViewController.viewModel = firstViewModel
        firstViewController.tabBarItem = UITabBarItem(title: "Main", image: UIImage(systemName: "photo.fill"), tag: 0)
        
        let secondViewController = SecondViewController()
        let secondViewModel = SecondViewModel()
        secondViewController.viewModel = secondViewModel
        secondViewController.tabBarItem = UITabBarItem(title: "Setting", image: UIImage(systemName: "gearshape.fill"), tag: 1)
        
        viewControllers = [firstViewController, secondViewController]
    }
}

