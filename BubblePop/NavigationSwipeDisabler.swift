

import SwiftUI

/// Disables iOS interactive pop (back-swipe) for the enclosing navigation controller.
struct NavigationSwipeDisabler: UIViewControllerRepresentable {
    let disabled: Bool
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = UIViewController()
        DispatchQueue.main.async {
            vc.navigationController?.interactivePopGestureRecognizer?.isEnabled = !disabled ? true : false
        }
        return vc
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        DispatchQueue.main.async {
            uiViewController.navigationController?.interactivePopGestureRecognizer?.isEnabled = !disabled ? true : false
        }
    }
}
