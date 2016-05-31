//
//  iDailyAnimator.swift
//  iDaily
//
//  Created by P. Chu on 5/31/16.
//  Copyright © 2016 Poodar. All rights reserved.
//

import UIKit

class iDailyAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var operation: UINavigationControllerOperation!
    
    //转场时长
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.4
    }
    
    //转场参数的变化
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        //获取转场舞台
        let containerView = transitionContext.containerView()
        
        //从x场景
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let fromView = fromVC!.view
        
        //转到x场景
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let toView = toVC!.view
        
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
                fromView.transform = CGAffineTransformMakeScale(3.3, 3.3)
            }
            else {
                //从原始大小的0.3倍逐渐开始还原为原始场景的大小
                toView.transform = CGAffineTransformMakeScale(1.0, 1.0)
            }
            toView.alpha = 1.0
            }, completion: { finished in
                transitionContext.completeTransition(true)
                //通知 NavigationController 已经完成转场
        })
    }
}