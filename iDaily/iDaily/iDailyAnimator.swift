//
//  iDailyAnimator.swift
//  iDaily
//
//  Created by P. Chu on 5/31/16.
//  Copyright © 2016 Poodar. All rights reserved.
//

import UIKit

//iDailyAnimator定义了转场的过渡动画效果
//@protocol:  UIViewControllerAnimatedTransitioning
// The methods in this protocol let you define an animator object, 
// which creates the animations for transitioning a view controller on or off screen in a fixed amount of time.
// 使用这个协议创建的动画必须是可交互的
// 为了创建可交互的动画对象，必须将该动画对象和其他控制动画时间的对象结合使用


// 实现了协议的类必须实现以下方法
// 1. public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval
// 2. public func animateTransition(transitionContext: UIViewControllerContextTransitioning)
// 3. optional public func animationEnded(transitionCompleted: Bool)   第三个方法是可选的

class iDailyAnimator: NSObject, UIViewControllerAnimatedTransitioning
{
    //These constants define the type of navigation controller transitions that can occur.
    //case None
    //case Push
    //case Pop
    var operation: UINavigationControllerOperation!
    
    //转场时长
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.4
    }
    
    //转场参数的变化
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        //获取转场舞台
        //即动画view的父view
        //The view that acts as the superview for the views involved in the transition.
        let containerView = transitionContext.containerView()
        
        //从x场景
        //Identifies the view controller that is visible at the beginning of the transition
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let fromView = fromVC!.view
        
        //转到x场景
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let toView = toVC!.view
        
        //起始时，设置toView为透明状态
        toView.alpha = 0.0
        
        //UINavigationControllerOperation.Pop用于判断是转入还是转出
        if operation == UINavigationControllerOperation.Pop {
            //如果要返回旧场景，那么设置要转入的场景初始缩放为原始大小
            toView.transform = CGAffineTransformMakeScale(1.0, 1.0)
        }
        else {
            //如果是转到新场景，设置新场景的初始缩放为0.3
            toView.transform = CGAffineTransformMakeScale(0.3, 0.3)
        }
        
        //在舞台上插入场景
        containerView!.insertSubview(toView, aboveSubview: fromView)
        
        //开始动画
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { 
            if self.operation == UINavigationControllerOperation.Pop {
                //放大要转出的场景
                fromView.transform = CGAffineTransformMakeScale(3.3, 3.3)  //1.0 -> 3.3
            }
            else {
                //从原始大小的0.3倍逐渐开始还原为原始场景的大小
                toView.transform = CGAffineTransformMakeScale(1.0, 1.0)   //0.3 -> 1.0
            }
            toView.alpha = 1.0  //将toView置为可见
            }, completion: { finished in
                // 通知 NavigationController 已经完成转场
                // Notifies the system that the transition animation is done.
                transitionContext.completeTransition(true)
        })
    }
}