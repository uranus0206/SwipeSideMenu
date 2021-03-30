
import UIKit

protocol MenuActionDelegate {
    func openSegue(_ segueName: String, sender: AnyObject?)
    func reopenMenu()
}

class MainViewController: UIViewController {

    let interactor = Interactor()

    @IBAction func openMenu(_ sender: Any) {
        if let destinationViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController {
            destinationViewController.transitioningDelegate = self
            destinationViewController.interactor = interactor
            destinationViewController.menuActionDelegate = self
            
            destinationViewController.modalPresentationStyle = .fullScreen
            self.present(destinationViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func edgePanGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        let progress = MenuHelper.calculateProgress(translation, viewBounds: view.bounds, direction: .right)
        
        MenuHelper.mapGestureStateToInteractor(
            sender.state,
            progress: progress,
            interactor: interactor){
            self.openMenu("")
        }
    }
}

extension MainViewController : MenuActionDelegate {
    
    func openSegue(_ segueName: String, sender: AnyObject?) {
        dismiss(animated: true){
            if let destinationViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: segueName) as? UIViewController {
                self.navigationController?.pushViewController(destinationViewController, animated: true)
            }
        }
    }
    
    func reopenMenu(){
        openMenu("")
    }
}

extension MainViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentMenuAnimator()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissMenuAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}
