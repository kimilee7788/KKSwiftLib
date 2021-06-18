//
//  NavigationService.swift
//  Scanner7
//
//  Created by lee kimi on 2021/5/13.
//

import Foundation
import UIKit

let navigationServices = YHNavigationService.sharedManager().navigationServices

//extension NSObject {
//    class var navigationServices: YHNavigationControllerServices {
//        return
//    }
//
//}
class YHNavigationService: NSObject {
    
    private override init() {
        super .init()
        
    }
    var navigationServices = YHNavigationControllerServices()
    
    class func sharedManager() -> YHNavigationService{
        struct onceManager {
            static var manager = YHNavigationService()
        }
        return onceManager.manager
    }
}

class YHNavigationControllerServices: NSObject {
    
    var navigationControllers:[UINavigationController] = [] {
        didSet{
        }
    }
    
    var topNavigationController:UINavigationController{
        return self.navigationControllers.last ?? UINavigationController()
    }
    
    func pushNavigationController(navigationController:UINavigationController){
        if self.navigationControllers.contains(navigationController) {
            return
        }
        self.navigationControllers.append(navigationController)
    }
    
    func popNavigationController(){
        if self.navigationControllers.last != nil {
            self.navigationControllers.removeLast()
        }
    }
    
    var requireNavigationController:UINavigationController{
        return self.topNavigationController
    }
    
    var topViewController:UIViewController{
        return self.topNavigationController.topViewController ?? UIViewController()
    }
    
    var visibleViewController:UIViewController{
        return self.topNavigationController.visibleViewController ?? UIViewController()
    }
    
    //MARK: - ResetRootViewController
    func resetRootViewController(viewController:UIViewController){
        if viewController is UINavigationController {
            let navigationController = viewController as! UINavigationController
            self.pushNavigationController(navigationController: navigationController)
//            UIApplication.shared.delegate?.window??.rootViewController = navigationController
            
        }else{
            
            let navigationController = UINavigationController.init(rootViewController: viewController)
            self.pushNavigationController(navigationController: navigationController)
//            UIApplication.shared.delegate?.window??.rootViewController = navigationController
        }
//        UIApplication.shared.delegate?.window??.makeKeyAndVisible()
    }
    
    //MARK: - viewControllers
    
    var viewControllers:[UIViewController]{
        
        return self.topNavigationController.viewControllers
    }
    
    func setViewController(viewControllers:[UIViewController],animated:Bool){
        self.topNavigationController.setViewControllers(viewControllers, animated: animated)
    }
    
    //MARK: - Push
    
    func push(viewController:UIViewController,animated:Bool){
        self.topNavigationController.pushViewController(viewController, animated: animated)
    }
    
    //MARK: - 自定义Push
    
    func push(viewController:UIViewController,animation:CATransition) {
        self.topNavigationController.view.layer.add(animation, forKey: nil)
        self.topNavigationController.pushViewController(viewController, animated: false)
    }
    
    func push(viewController:UIViewController,fromViewController:UIViewController,animated:Bool){
        var vcs :[UIViewController] = []
        for controller in self.viewControllers {
            vcs.append(controller)
            if controller .isEqual(fromViewController) {
                break
            }
        }
        vcs.append(viewController)
        self.setViewController(viewControllers: vcs, animated: animated)
    }
    
    func push(viewController:UIViewController,excludeViewController:UIViewController,animated:Bool){
        var vcs:[UIViewController] = []
        for controller in self.viewControllers {
            if controller .isEqual(excludeViewController) {
                break
            }
            vcs.append(controller)
        }
        vcs.append(viewController)
        self.setViewController(viewControllers: vcs, animated: animated)
    }
    
    func pushCurrentFrom(viewController:UIViewController,animated:Bool){
        if let fromViewController = self.viewControllers.last{
            self.push(viewController: viewController, fromViewController: fromViewController, animated: animated)
        }
    }
    
    @discardableResult
    func pushPowerful(viewController:UIViewController,animated:Bool) -> [UIViewController]{
        if let displayVC = self.viewControllers.last{
            self.setViewController(viewControllers: [displayVC,viewController], animated: animated)
            self.setViewController(viewControllers: [viewController], animated: false)
            return self.viewControllers
        }
        return []
    }
    
    func show(viewController:UIViewController,sender:Any){
        self.topViewController.show(viewController, sender: sender)
    }
    //MARK: - Pop
    @discardableResult
    func pop(animated:Bool) -> UIViewController{
        return self.topNavigationController.popViewController(animated: animated) ?? UIViewController.init()
    }
    
    @discardableResult
    func pop(animation:CATransition) -> UIViewController {
        self.topNavigationController.view.layer.add(animation, forKey: nil)
        return self.topNavigationController.popViewController(animated: false) ?? UIViewController.init()
    }
    
    @discardableResult
    func popTo(viewController:UIViewController,animated:Bool) -> [UIViewController]{
        return self.topNavigationController.popToViewController(viewController, animated: animated) ?? []
    }
    @discardableResult
    func popToRoot(animated:Bool) -> [UIViewController]{
        return self.topNavigationController.popToRootViewController(animated: animated) ?? []
    }
    
    //MARK: - 自定义Pop
    @discardableResult
    func popToClass(controllerClass:AnyClass, animated:Bool) -> [UIViewController]{
        
        for viewController in self.viewControllers {
            if viewController.isMember(of: controllerClass) {
                return self.popTo(viewController: viewController, animated: animated)
            }
        }
        return []
    }
    @discardableResult
    func popToExternal(externalViewController:UIViewController,excludeViewController:UIViewController,animated:Bool) -> [UIViewController]{
        var vcs:[UIViewController] = []
        for controller in self.viewControllers {
            if controller == excludeViewController {
                break
            }
            vcs.append(controller)
        }
        vcs.append(externalViewController)
        vcs.append(excludeViewController)
        self.setViewController(viewControllers: vcs, animated: false)
        vcs.removeLast()
        self.setViewController(viewControllers: vcs, animated: animated)
        return self.viewControllers
    }
    @discardableResult
    func popToExternal(externalViewController:UIViewController,toViewController:UIViewController,animated:Bool) -> [UIViewController]{
        
        
        if (self.viewControllers.last != nil) {
            
            if self.viewControllers.last == toViewController {
                return []
            }else{
                var vcs:[UIViewController] = []
                for controller in self.viewControllers {
                    if controller == toViewController {
                        vcs .append(controller)
                    }
                    vcs.append(controller)
                }
                vcs.append(externalViewController)
                vcs.append(self.viewControllers.last!)
                self.setViewController(viewControllers: vcs, animated: false)
                vcs.removeLast()
                self.setViewController(viewControllers: vcs, animated: animated)
                return self.viewControllers
            }
        }else{
            return []
        }
        
    }
    @discardableResult
    func popToPrevious(viewController:UIViewController,animated:Bool) -> [UIViewController]{
        var continued = false
        for controller in self.viewControllers.reversed() {
            if controller == viewController {
                continued = true
                continue
            }
            if continued{
                return self .popTo(viewController: controller, animated: animated)
            }
        }
        return []
    }
    @discardableResult
    func popToPowerful(viewController:UIViewController,animated:Bool) -> [UIViewController]{
        if let displayVC = self.viewControllers.last{
            self.setViewController(viewControllers: [viewController,displayVC], animated: false)
            self.setViewController(viewControllers: [viewController], animated: animated)
            return self.viewControllers
        }
        return []
    }
    
    //MARK: - Present
    
    func present(viewController:UIViewController,animated:Bool,presentationStyle:UIModalPresentationStyle = .fullScreen, completion:@escaping ()->Void){
        let presentingViewController = self.topNavigationController
        if presentationStyle == .overCurrentContext{
            presentingViewController.modalPresentationStyle = .currentContext
        }
        if viewController is UINavigationController {
            self.pushNavigationController(navigationController: viewController as! UINavigationController)
            viewController.modalPresentationStyle = presentationStyle
            presentingViewController .present(viewController, animated: animated, completion: completion)
        }else{
            
            let navigationController = KMNavigationController.init(rootViewController: viewController)
            self .pushNavigationController(navigationController: navigationController)
            navigationController.modalPresentationStyle = presentationStyle
            presentingViewController .present(navigationController, animated: animated, completion: completion)
        }
    }
    
    func dismiss(animated:Bool,completion:@escaping () ->Void){
        self .popNavigationController()
        self.topNavigationController.dismiss(animated: animated, completion: completion)
    }
    
    @discardableResult
    func tailWithout(viewController:UIViewController) -> [UIViewController]{
        var vcs:[UIViewController] = []
        
        for controller in self.viewControllers {
            if controller != viewController && vcs.count == 0{
                continue
            }
            vcs.append(controller)
        }
        if vcs.count != 0 {
            vcs.removeFirst()
        }
        return vcs
        
    }
    /**
    * 获取@viewController之前的一个控制器，如果没有则返回nil
    */
    @discardableResult
    func previous(viewController:UIViewController) -> UIViewController{
        let vcidx = self.viewControllers.firstIndex(of: viewController)
        if vcidx == NSNotFound {
            abort()
        }
        if vcidx == 0 {
            abort()
        }
        return self.viewControllers[vcidx! - 1]
    }
    
    func tabBar(selectedIndex:Int){
        var tabVC:UITabBarController?
        for vc in navigationServices.viewControllers {
            if vc is UITabBarController{
                tabVC = (vc as! UITabBarController)
                break
            }
        }
        if  selectedIndex + 1 < tabVC?.viewControllers?.count ?? 0{
            
            tabVC?.selectedIndex = selectedIndex
        }
    }
}
