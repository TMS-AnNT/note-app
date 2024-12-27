//
//  ViewController.swift
//  Notelist
//
//  Created by cao duc tin  on 23/12/24.
//

import UIKit
import UIKit
//
//class ViewController: UIViewController {
//
//    let animatedView = UIView()
//    let animatedView1 = UIView()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupView()
//
//        // Gọi hàm để bắt đầu animation sau khi view đã được setup
//        animateRotation()
//        animateView()
//    }
//
//    // Thiết lập view cần animation
//    func setupView() {
//        animatedView.frame = CGRect(x: 0, y: 50, width: 100, height: 100)
//        animatedView.backgroundColor = .systemBlue
//        animatedView1.frame = CGRect(x: 20, y: 50, width: 100, height: 100)
//        animatedView1.backgroundColor = .systemBlue
//        self.view.addSubview(animatedView)
//        self.view.addSubview(animatedView1)
//
//    }
//
//    // Hàm tạo Core Animation
//    func animateView() {
//        // Tạo một CABasicAnimation cho thuộc tính "position"
//        let animation = CABasicAnimation(keyPath: "position")
//
//        // Thiết lập giá trị bắt đầu của animation
//        animation.fromValue = animatedView1.layer.position
//
//        // Thiết lập giá trị kết thúc của animation (vị trí mới)
//        animation.toValue = CGPoint(x: 300, y: 800)
//
//        
//        // Thời gian chạy animation
//        animation.duration = 2.0
//
//        animation.autoreverses = true
//        animation.repeatCount = Float.infinity
//        // Tùy chọn để giữ nguyên trạng thái sau khi animation kết thúc
//        animation.fillMode = .both
//        
//        animation.isRemovedOnCompletion = false
//        
//        
//        // Thêm animation vào layer của view
//        animatedView1.layer.add(animation, forKey: "moveAnimation")
//    }
//    func animateRotation() {
//        let animation = CABasicAnimation(keyPath: "transform.rotation")
//        animation.fromValue = 0
//        animation.toValue = CGFloat.pi * 2 // Xoay 360 độ
//        animation.duration = 4.0
//        animation.repeatCount = Float.infinity
//        animatedView.layer.add(animation, forKey: "rotationAnimation")
//        
//    }
//
//}

import Foundation

protocol MainViewModelDelegate: AnyObject {
    func didUpdateNodes()
}
//
//import UIKit
//
//class ViewController: UIViewController {
//    let mainView = UIView()
//    let buttonLeft = UIButton()
//    let buttonRight = UIButton()
//    let label = UILabel()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupViews()
//        setupGestures()
//    }
//    
//    func setupViews() {
//        // Main View
//        mainView.frame = view.bounds
//        mainView.backgroundColor = .systemGray5
//        view.addSubview(mainView)
//        
//        // Label
//        label.frame = CGRect(x: 50, y: 200, width: view.frame.width - 100, height: 50)
//        label.text = "Swipe Left or Right"
//        label.textAlignment = .center
//        label.font = UIFont.systemFont(ofSize: 18)
//        mainView.addSubview(label)
//        
//        // Button Left
//        buttonLeft.frame = CGRect(x: -100, y: 400, width: 100, height: 50)
//        buttonLeft.setTitle("Left", for: .normal)
//        buttonLeft.backgroundColor = .systemBlue
//        buttonLeft.layer.cornerRadius = 10
//        mainView.addSubview(buttonLeft)
//        
//        // Button Right
//        buttonRight.frame = CGRect(x: view.frame.width, y: 400, width: 100, height: 50)
//        buttonRight.setTitle("Right", for: .normal)
//        buttonRight.backgroundColor = .systemGreen
//        buttonRight.layer.cornerRadius = 10
//        mainView.addSubview(buttonRight)
//    }
//    
//    func setupGestures() {
//        // Swipe Left Gesture
//        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
//        swipeLeft.direction = .left
//        mainView.addGestureRecognizer(swipeLeft)
//        
//        // Swipe Right Gesture
//        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
//        swipeRight.direction = .right
//        mainView.addGestureRecognizer(swipeRight)
//    }
//    
//    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
//        switch gesture.direction {
//        case .left:
//            // Move buttonLeft into view
//            UIView.animate(withDuration: 0.3) {
//                self.buttonLeft.frame.origin.x = 20
//                self.buttonRight.frame.origin.x = self.view.frame.width
//            }
//            label.text = "Swiped Left!"
//        case .right:
//            // Move buttonRight into view
//            UIView.animate(withDuration: 0.3) {
//                self.buttonLeft.frame.origin.x = -100
//                self.buttonRight.frame.origin.x = self.view.frame.width - 120
//            }
//            label.text = "Swiped Right!"
//        default:
//            break
//        }
//    }
//}import UIKit

class ViewController: UIViewController {
    
    let menuView = UIView()
    var originalMenuPosition: CGFloat = 0
    let menuWidth: CGFloat = 250
    var isMenuOpen = false
    var toggleMenuButton = UIButton()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenu()
        setupPanGesture()
        setupToggleMenuButton()
        view.backgroundColor = .white // Đặt nền của viewController thành màu trắng sáng
    }
    
    func setupMenu() {
        // Tạo menu
        menuView.frame = CGRect(x: 0, y: 0, width: menuWidth, height: self.view.frame.height-20)
        menuView.backgroundColor = .systemBlue // Màu của menu
        self.view.addSubview(menuView)
        originalMenuPosition = menuView.frame.origin.x
    }
    
    func setupToggleMenuButton(){
        toggleMenuButton.frame = CGRect(x: 20, y: 50, width: 100, height: 50)
        toggleMenuButton.setTitle("Togle Menu", for: .normal)
        toggleMenuButton.backgroundColor = .systemGreen

        
        // Áp dụng bo tròn cho góc trên bên trái và góc dưới bên phải
        toggleMenuButton.roundCorners(corners: [.topLeft, .bottomRight], radius: 20)
        toggleMenuButton.addTarget(self, action: #selector(toggleMenu), for: .touchUpInside)
        
        self.view.addSubview(toggleMenuButton)
    }
    
    
    func setupPanGesture() {
        // Tạo pan gesture cho menu
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        menuView.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        // Cập nhật vị trí menu dựa trên dịch chuyển của ngón tay
        var newX = menuView.frame.origin.x + translation.x
        
        // Đảm bảo menu không di chuyển ra ngoài phạm vi
        newX = max(newX, -menuWidth)  // Menu không được ra ngoài bên trái
        newX = min(newX, 0)           // Menu không được ra ngoài bên phải (vị trí mở)

        menuView.frame.origin.x = newX
        
        // Reset translation
        gesture.setTranslation(.zero, in: view)
        
        // Khi pan gesture kết thúc, kiểm tra vị trí của menu
        if gesture.state == .ended {
            // Nếu menu đã kéo được tầm một khoảng (x > -150), mở menu
            if newX > -menuWidth / 2 {
                openMenu()
            } else {
                closeMenu()
            }
        }
    }
    
    @objc func toggleMenu() {
        if isMenuOpen {
            closeMenu()
        } else {
            openMenu()
        }
    }

    func openMenu() {
        // Mở menu
        UIView.animate(withDuration: 0.2, animations: {
            self.menuView.frame.origin.x = 0
        })
        isMenuOpen = true
    }
    
    func closeMenu() {
        // Đóng menu
        UIView.animate(withDuration: 0.3, animations: {
            self.menuView.frame.origin.x = -self.menuWidth
        })
        isMenuOpen = false
    }
}
