import UIKit



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    //MARK: - Properties
    var window: UIWindow?
    private var context: AppContext!
    private var appCoordinator: AppCoordinator!


    //MARK: - Delegate - Start
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       

        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .white
        self.window!.makeKeyAndVisible()
        
        self.context = AppContextImpl()
        self.appCoordinator = AppCoordinator(window: self.window!, context: self.context)
        self.appCoordinator.start()
        
        return true
    }

    
    //MARK: - Delegate
    func applicationWillResignActive(_ application: UIApplication) {
    
    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {

    }

}

