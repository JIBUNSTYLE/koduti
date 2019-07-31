//
//  StoryboardTemplate.swift
//  SwiftShell
//
//  Created by 斉藤 祐輔 on 2019/07/29.
//

import Foundation

struct StoryboardTemplate: Template {
    
    let fileName = "__PREFIX__"
    let fileType = "storyboard"
    
    func parentDirectory() -> String {
        return "Service/Presentation/Storyboards"
    }
    
    func body() -> String {
        return [
            "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
            , "<document type=\"com.apple.InterfaceBuilder3.CocoaTouch.Storyboard.XIB\" version=\"3.0\" toolsVersion=\"14460.31\" targetRuntime=\"iOS.CocoaTouch\" propertyAccessControl=\"none\" useAutolayout=\"YES\" useTraitCollections=\"YES\" useSafeAreas=\"YES\" colorMatched=\"YES\" initialViewController=\"eh6-on-pzc\">"
            , "    <device id=\"retina4_7\" orientation=\"portrait\">"
            , "        <adaptation id=\"fullscreen\"/>"
            , "    </device>"
            , "    <dependencies>"
            , "        <deployment identifier=\"iOS\"/>"
            , "        <plugIn identifier=\"com.apple.InterfaceBuilder.IBCocoaTouchPlugin\" version=\"14460.20\"/>"
            , "        <capability name=\"Safe area layout guides\" minToolsVersion=\"9.0\"/>"
            , "        <capability name=\"documents saved in the Xcode 8 format\" minToolsVersion=\"8.0\"/>"
            , "    </dependencies>"
            , "    <scenes>"
            , "        <!--Category List View Controller-->"
            , "        <scene sceneID=\"B0N-le-Y6a\">"
            , "            <objects>"
            , "                <viewController storyboardIdentifier=\"__PREFIX__\" useStoryboardIdentifierAsRestorationIdentifier=\"YES\" id=\"eh6-on-pzc\" customClass=\"__PREFIX__ViewController\" customModule=\"atorsy\" customModuleProvider=\"target\" sceneMemberID=\"viewController\">"
            , "                    <view key=\"view\" contentMode=\"scaleToFill\" id=\"Pa3-OR-KM4\">"
            , "                        <rect key=\"frame\" x=\"0.0\" y=\"0.0\" width=\"375\" height=\"667\"/>"
            , "                        <autoresizingMask key=\"autoresizingMask\" widthSizable=\"YES\" heightSizable=\"YES\"/>"
            , "                        <color key=\"backgroundColor\" white=\"1\" alpha=\"1\" colorSpace=\"custom\" customColorSpace=\"genericGamma22GrayColorSpace\"/>"
            , "                        <viewLayoutGuide key=\"safeArea\" id=\"EuC-pu-PTd\"/>"
            , "                    </view>"
            , "                </viewController>"
            , "                <placeholder placeholderIdentifier=\"IBFirstResponder\" id=\"ni8-Ps-r1f\" userLabel=\"First Responder\" sceneMemberID=\"firstResponder\"/>"
            , "            </objects>"
            , "            <point key=\"canvasLocation\" x=\"148\" y=\"-78\"/>"
            , "        </scene>"
            , "    </scenes>"
            , "</document>"
        ].joined(separator: "\n")
    }
}
