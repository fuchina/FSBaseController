//
//  FSBaseControllerS.swift
//  FSBaseController
//
//  Created by pwrd on 2026/1/29.
//

import Foundation

import FSKit
import FSUIKit

open class FSBaseController: UIViewController {
    
    var             _cellDeselectIndexPath  :   IndexPath?               =       nil
    weak var        _cellDeselectView       :   UITableView?             =       nil
    
    var             _baseAddDidChangeStatusBarOrientationNotification    :   Bool             =       false
    
    var             _onceBase_viewWillAppear:   Bool                     =       false
    var             _isVisibling            :   Bool                     =       false

    var             _back_tap_view          :   UIView?                  =       nil
    
    var             _baseComponentAmounted  :   Bool                     =       false
    
    var             _baseLoadingView        :   UIView?                  =        nil
    var             _baseBackView           :   UIView?                  =        nil

    deinit {
        #if TARGET_IPHONE_SIMULATOR
        print("\(type(of: self)) dealloc")
        #else
        #endif
        
//        let d = FSDate.theLastSecondOfDay(Date())
//        print("FSLog d = \(d)")
        
        let n = Date().timeIntervalSince1970
        if n < 1772207999 {
            print("\(type(of: self)) dealloc")
        }
        
        NotificationCenter.default.removeObserver(self)
    }
    
    open func configCellDeselectView(tableView: UITableView, indexPath: IndexPath) {
        _cellDeselectIndexPath = indexPath
        _cellDeselectView = tableView
    }
    
    static var fitIOS15 : Bool = true
    static public func fitIOS15System() {
        FSBaseController.fitIOS15 = true
    }
    
    open func baseAddBarOrientationChangedNotification() {
        _baseAddDidChangeStatusBarOrientationNotification = true
    }
    
    override open func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        if _baseAddDidChangeStatusBarOrientationNotification {
            handleOrientationDidChange()
        }
    }
    
    func handleOrientationDidChange() {
        let ws = FSKit.currentWindowScene()
        guard let ws = ws else {
            return
        }
        
        let fo = ws.interfaceOrientation
        baseHandleChangeStatusBarOrientation(orientation: fo)
    }
    
    open func baseHandleChangeStatusBarOrientation(orientation: UIInterfaceOrientation) {}
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if _onceBase_viewWillAppear == false {
            _onceBase_viewWillAppear = true
            
            // translucent为YES，self.view布局从屏幕顶部(0,0)开始，如果为NO会从导航栏底部开始
            self.navigationController?.navigationBar.isTranslucent = true
        }
        
        if (_cellDeselectIndexPath != nil) && (_cellDeselectView != nil) {
            _cellDeselectView!.deselectRow(at: _cellDeselectIndexPath! as IndexPath, animated: true)
            
            _cellDeselectView = nil
            _cellDeselectIndexPath = nil
        }
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        _isVisibling = true
    }
        
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        _isVisibling = false
        
        if self.isMovingFromParent {
            self.disappearFraomParent()
        }
    }
    
    open func disappearFraomParent() {}
        
    func fitIOS15() {
        if #available(iOS 15.0, *) {} else {
            return
        }
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        self.navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        
        let toolBarAppearance = UIToolbarAppearance()
        toolBarAppearance.backgroundColor = UIColor.white
        self.navigationController?.toolbar.scrollEdgeAppearance = toolBarAppearance
        self.navigationController?.toolbar.standardAppearance = toolBarAppearance
        
        
        let tabBarAppearance = UITabBarAppearance()
        toolBarAppearance.backgroundColor = UIColor.white
        self.tabBarController?.tabBar.scrollEdgeAppearance = tabBarAppearance
        self.tabBarController?.tabBar.standardAppearance = tabBarAppearance
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        if FSBaseController.fitIOS15 {
            fitIOS15()
        }
                
        let rgb = 0.95
        self.view.backgroundColor = UIColor.init(red: rgb, green: rgb, blue: rgb, alpha: 1.0)
                
        _back_tap_view = UIView(frame: self.view.bounds)
        self.view.addSubview(_back_tap_view!)
                
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapActionBase))
        _back_tap_view?.addGestureRecognizer(tap)
    }
    
    @objc open func tapActionBase() {
        self.view.endEditing(true)
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if _baseComponentAmounted == false {
            _baseComponentAmounted = true
            
            _isVisibling = true
            
            componentWillMount()
        }
    }
    
    open func componentWillMount() {
        
        #if TARGET_IPHONE_SIMULATOR
        let vcs = self.navigationController?.viewControllers
        if vcs?.count >= 2 {
            let from = vcs?.index(of: vcs?.count - 2)
            print("\n \(type(of: from)) From \n")
        }
        #else
        #endif
        
        if self.navigationController != nil {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
    }
    
    open func baseHandleDatas() {}
    open func baseDesignViews() {}
    
    open lazy var scrollView: FSTapScrollView = {
        
        let scrollView = FSTapScrollView(frame: CGRect(x: 0, y: self.view.safeAreaInsets.top, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - self.view.safeAreaInsets.top))
        scrollView.contentSize = CGSizeMake(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height + 10)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.click = { [weak self] view in
            self?.tapActionBase()
        }

        if _back_tap_view == nil {
            self.view.addSubview(scrollView)
        } else {
            self.view.insertSubview(scrollView, aboveSubview: _back_tap_view!)
        }
        
//        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapActionBase))
//        scrollView.addGestureRecognizer(tap)
        
        if self.navigationController != nil {
            FSKit.fitScrollViewOperate(scrollView, navigationController: self.navigationController)
        }
        
        return scrollView
    }()

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    open func showWaitView(_ show: Bool) {
        
        if show {
            let blackWidth = 80
            let blackRect = CGRect(x: Int(UIScreen.main.bounds.size.width / 2 - 40.0), y: (Int(UIScreen.main.bounds.size.height) / 2 - 40), width: blackWidth, height: blackWidth)
            
            if _baseLoadingView != nil {
                self.view.bringSubviewToFront(_baseLoadingView!)
                _baseLoadingView!.frame = UIScreen.main.bounds
                _baseBackView?.frame = blackRect
            } else {
                _baseLoadingView = UIView(frame: UIScreen.main.bounds)
                self.view.addSubview(_baseLoadingView!)
                
                _baseBackView = UIView(frame: blackRect)
                _baseBackView?.alpha = 0.7
                _baseBackView?.backgroundColor = UIColor.black
                _baseBackView?.layer.cornerRadius = 6
                _baseLoadingView?.addSubview(_baseBackView!)
                
                let active = UIActivityIndicatorView.init(style: .large)
                active.frame = CGRect(x: 0, y: 0, width: Int(_baseBackView!.frame.size.width), height: Int(_baseBackView!.frame.size.height))
                active.startAnimating()
                _baseBackView?.addSubview(active)
                
            }
            
        } else {
            _baseLoadingView?.removeFromSuperview()
            _baseLoadingView = nil
        }
    }
    
    open func fs_bottomView() -> UIView {
        let h = self.view.safeAreaInsets.bottom + 45
        let bottomView = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - h, width: UIScreen.main.bounds.size.width, height: h))
        bottomView.backgroundColor = UIColor.white
        return bottomView
    }
    
}
