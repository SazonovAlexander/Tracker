import UIKit


final class TabBarController: UITabBarController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension TabBarController {
    
    func setup() {
        setupViewControllers()
        setAppearance()
    }
    
    func setAppearance() {
        let lineLayer = CALayer()
        lineLayer.backgroundColor = UIColor.grayYP.cgColor
        lineLayer.frame = CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 1)
        tabBar.layer.addSublayer(lineLayer)
    }
    
    
    func setupViewControllers() {
        let trackersViewController = TrackersViewController()
        let trackersNavController = UINavigationController(rootViewController: trackersViewController)
        trackersNavController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("trackers", comment: "Trackers"),
            image: UIImage(named: "TrackersTabBar"),
            selectedImage: nil
        )
        
            
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("statistics", comment: "Staticstics"),
            image: UIImage(named: "StatisticsTabBar"),
            selectedImage: nil
        )
   
           
       self.viewControllers = [ trackersNavController, statisticsViewController]
    }
    
}

