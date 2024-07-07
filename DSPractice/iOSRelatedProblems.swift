//
//  iOSRelatedProblems.swift
//  DSPractice
//
//  Created by Ankita Kalangutkar on 07/07/24.
//

import Foundation

/*
 // Works
 // ref: https://mehrdad-ahmadian.medium.com/ios-faang-interview-question-finding-the-closest-parent-view-of-two-uiviews-c62f388f6f79
 struct iOSRelatedProblems {
 func findClosestCommonParent(view1: UIView, view2: UIView) -> UIView? {
 
 var view1Array = [UIView]() // v1, v1s1, v1s2
 var view2Array = [UIView]() // v2, v1s1
 
 var currentView1: UIView? = view1
 while currentView1 != nil {
 view1Array.append(currentView1!)
 currentView1 = currentView1?.superview
 }
 
 var currentView2: UIView? = view2
 while currentView2 != nil {
 view2Array.append(currentView2!)
 currentView2 = currentView2?.superview
 }
 
 // go through both the arrays to find the common view
 let view2Set = Set(view2Array)
 for view1 in view1Array {
 if view2Set.contains(view1) {
 return view1
 }
 }
 
 return nil
 
 }
 }
 */
