/*
 
 Copyright © 2015 Xavier Merino. All rights reserved.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */

//
//  XMSegmentedControl.swift
//  XMSegmentedControl
//
//  Created by Xavier Merino on 9/29/15.
//  Updated by Xavier Merino on 11/28/15.
//

import UIKit

///The delegate of `XMSegmentedControl` must adopt `XMSegmentedControlDelegate` protocol. It allows retrieving information on which segment was tapped.
public protocol XMSegmentedControlDelegate {
    /// Tells the delegate that a specific segment is now selected.
    func xmSegmentedControl(_ xmSegmentedControl: XMSegmentedControl, selectedSegment:Int)
}

/**
 Highlighted Styles for the selected segments.
 - Background: The background of the selected segment is highlighted.
 - TopEdge: The top edge of the selected segment is highlighted.
 - BottomEdge: The bottom edge of the selected segment is highlighted.
 */
public enum XMSelectedItemHighlightStyle {
    case background
    case topEdge
    case bottomEdge
}

/**
 Content Type for the segmented control.
 - Text: The segmented control displays only text.
 - Icon: The segmented control displays only icons/images.
 - Hybrid: The segmented control displays icons and text.
 */
public enum XMContentType {
    case text
    case icon
    case hybrid
}

/**
 XMSegmentedControl is a replacement for the standard segmented control.
 It allows text, icon, and text + icon segments.
 Conform to `XMSegmentedControlDelegate` to obtain the selected segment.
 */

@IBDesignable
open class XMSegmentedControl: UIView {
    open var delegate:XMSegmentedControlDelegate?
    fileprivate var highlightView:UIView!
    
    /**
     Defines the height of the highlighted edge if `selectedItemHighlightStyle` is either `TopEdge` or `BottomEdge`
     - Note: Changes only take place if `selectedItemHighlightStyle` is either `TopEdge` or `BottomEdge`
     */
    open var edgeHighlightHeight:CGFloat = 3.0
    
    /// Changes the background of the selected segment.
    @IBInspectable open var highlightColor:UIColor = UIColor(red: 42/255, green: 132/255, blue: 210/255, alpha: 1) {
        didSet {
            update()
        }
    }
    
    /// Changes the font color or the icon tint color for the segments.
    @IBInspectable open var tint:UIColor = UIColor.white {
        didSet {
            update()
        }
    }
    
    /// Changes the font color or the icon tint for the selected segment.
    @IBInspectable open var highlightTint:UIColor = UIColor.white {
        didSet {
            update()
        }
    }
    
    /**
     Sets the segmented control content type to `Text` and uses the content of the array to create the segments.
     - Note: Only six elements will be displayed.
     */
    open var segmentTitle:[String] = []{
        didSet {
            segmentTitle = segmentTitle.count > 6 ? Array(segmentTitle[0..<6]) : segmentTitle
            contentType = .text
            update()
        }
    }
    
    /**
     Sets the segmented control content type to `Icon` and uses the content of the array to create the segments.
     - Note: Only six elements will be displayed.
     */
    open var segmentIcon:[UIImage] = []{
        didSet {
            segmentIcon = segmentIcon.count > 6 ? Array(segmentIcon[0..<6]) : segmentIcon
            contentType = .icon
            update()
        }
    }
    
    /**
     Sets the segmented control content type to `Hybrid` (i.e. displaying icons and text) and uses the content of the tuple to create the segments.
     - Note: Only six elements will be displayed. The arrays will be truncated.
     */
    open var segmentContent:(text:[String], icon:[UIImage]) = ([], []) {
        didSet {
            /// Checks if `segmentContent.text` and `segmentContent.icon` have the same size. Size must be synchronized.
            if (segmentContent.text.count == segmentContent.icon.count) {
                segmentContent.text = segmentContent.text.count > 6 ? Array(segmentContent.text[0..<6]) : segmentContent.text
                segmentContent.icon = segmentContent.icon.count > 6 ? Array(segmentContent.icon[0..<6]) : segmentContent.icon
                /// Resize images to fit within the button. See the `resizeImage` function for more details.
                segmentContent.icon = segmentContent.icon.map(resizeImage)
                contentType = .hybrid
                update()
            } else {
                print("Text and Icon arrays out of sync.")
            }
        }
    }
    
    /**
     The index of the selected segment.
     - Note: Read-only. Changing `selectedSegment` won't do anything.
     */
    open var selectedSegment:Int = 0
    
    /**
     Sets the font for the text displayed in the segmented control.
     - Note: Changes only take place if `contentType` is `Text` or `Hybrid`
     */
    open var font:UIFont = UIFont(name: "AvenirNext-DemiBold", size: 15)!
    
    /// Sets the segmented control selected item highlight style to `Background`, `TopEdge` or `BottomEdge`.
    open var selectedItemHighlightStyle:XMSelectedItemHighlightStyle = .background
    
    /// Sets the segmented control content type to `Text`, `Icon`, or `Hybrid`
    open var contentType:XMContentType = .text
    
    /// Initializes and returns a newly allocated XMSegmentedControl object with the specified frame rectangle. It sets the segments of the control from the given `segmentTitle` array and the highlight style for the selected item.
    public init (frame: CGRect, segmentTitle: [String], selectedItemHighlightStyle:XMSelectedItemHighlightStyle) {
        super.init (frame: frame)
        commonInit(segmentTitle, highlightStyle: selectedItemHighlightStyle)
    }
    
    /// Initializes and returns a newly allocated XMSegmentedControl object with the specified frame rectangle. It sets the segments of the control from the given `segmentIcon` array and the highlight style for the selected item.
    public init (frame: CGRect, segmentIcon: [UIImage], selectedItemHighlightStyle:XMSelectedItemHighlightStyle) {
        super.init (frame: frame)
        commonInit(segmentIcon, highlightStyle: selectedItemHighlightStyle)
    }
    
    /// Initializes and returns a newly allocated XMSegmentedControl object with the specified frame rectangle. It sets the segments of the control from the given `segmentContent` tuple and the highlight style for the selected item. Notice that the tuple consists of an array containing the titles and another array containing the icons. The two arrays must be the same size.
    public init (frame: CGRect, segmentContent: ([String], [UIImage]), selectedItemHighlightStyle:XMSelectedItemHighlightStyle) {
        super.init (frame: frame)
        commonInit(segmentContent, highlightStyle: selectedItemHighlightStyle)
    }
    
    /// Common initializer. The `Any` type allows accepting the tuple and the array data structures. It then gets unwrapped.
    fileprivate func commonInit(_ data:Any, highlightStyle:XMSelectedItemHighlightStyle){
        if let segmentTitle = data as? [String] {
            self.segmentTitle = segmentTitle
        } else if let segmentIcon = data as? [UIImage] {
            self.segmentIcon = segmentIcon
        } else if let segmentContent = data as? ([String], [UIImage]) {
            self.segmentContent = segmentContent
        }
        self.backgroundColor = UIColor(red: 45/255, green: 62/255, blue: 100/255, alpha: 1)
        self.selectedItemHighlightStyle = highlightStyle
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 45/255, green: 62/255, blue: 100/255, alpha: 1)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor(red: 45/255, green: 62/255, blue: 100/255, alpha: 1)
    }
    
    /// Prepares the render of the view for the Storyboard.
    override open func prepareForInterfaceBuilder() {
        segmentTitle = ["Only", "For", "Show"]
        self.backgroundColor = UIColor(red: 45/255, green: 62/255, blue: 100/255, alpha: 1)
    }
    
    /// Function gets automatically called whenever orientation changes and when view is loaded.
    override open func layoutSubviews() {
        update()
    }
    
    /**
     Forces the segmented control to reload.
     Function gets called whenever orientation is changed.
     */
    open func update(){
        
        /**
         Adds the segments to the segmented control. It takes `starting` where you specify the starting X position for the first segment. `sections` takes the number of total segments to be added. `width` and `height` specify size constraints for the segment.
         */
        func addSegments(startingPosition starting:CGFloat, sections:Int, width:CGFloat, height:CGFloat){
            
            for  i in 0 ..< sections{
                let frame = CGRect(x: starting + (CGFloat(i) * width), y: 0, width: width, height: height)
                let tab:UIButton = UIButton(type: UIButtonType.system)
                tab.frame = frame
                
                switch contentType {
                case .icon:
                    /// Icon Mode sets insets. In a 44 height control the image becomes 20x20. The imageView in the UIButton is set to ScaleAspectFit to preserve aspect ratio and resize to fit.
                    tab.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
                    tab.imageView?.contentMode = UIViewContentMode.scaleAspectFit
                    tab.tintColor = i == selectedSegment ? highlightTint : tint
                    tab.setImage(segmentIcon[i], for: UIControlState())
                    
                case .text:
                    tab.setTitle(segmentTitle[i], for: UIControlState())
                    tab.setTitleColor(i == selectedSegment ? highlightTint : tint, for: UIControlState())
                    tab.titleLabel?.font = font
                    
                case .hybrid:
                    /// Modify `insetAmount` to change spacing between borders, icon, and text
                    /// Hybrid Mode sets insets. In a 44 height control the image becomes 20x20. The imageView in the UIButton is set to ScaleAspectFit to preserve aspect ratio and resize to fit.
                    let insetAmount:CGFloat = 8 / 2.0
                    tab.imageEdgeInsets = UIEdgeInsetsMake(12, -insetAmount, 12, insetAmount)
                    tab.titleEdgeInsets = UIEdgeInsetsMake(0, insetAmount*2, 0, 0)
                    tab.contentEdgeInsets = UIEdgeInsetsMake(0, insetAmount, 0, insetAmount)
                    tab.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
                    tab.setTitle(segmentContent.text[i], for: UIControlState())
                    tab.setImage(segmentContent.icon[i], for: UIControlState())
                    tab.titleLabel?.font = font
                    tab.imageView?.contentMode = UIViewContentMode.scaleAspectFit
                    tab.tintColor = i == selectedSegment ? highlightTint : tint
                    
                }
                
                /// The tag identifies the index of the segment.
                tab.tag = i
                tab.addTarget(self, action: #selector(XMSegmentedControl.segmentPressed(_:)), for: UIControlEvents.touchUpInside)
                self.addSubview(tab)
            }
        }
        
        /**
         Adds the highlight view. The X position is specified by `starting`. The height is is set to `edgeHighlightHeight` unless you specifiy `selectedItemHighlightStyle` as `Background`
         */
        func addHighlightView(startingPosition starting:CGFloat, width:CGFloat){
            switch selectedItemHighlightStyle {
            case .background:
                highlightView = UIView(frame: CGRect(x: starting, y: 0, width: width, height: self.frame.height))
                //highlightView = UIView(frame: CGRect(x: starting, y: 0, width: width / 2, height: self.frame.height))
                
            case .topEdge:
                highlightView = UIView(frame: CGRect(x: starting, y: 0, width: width, height: edgeHighlightHeight))
            case .bottomEdge:
                //highlightView = UIView(frame: CGRect(x: starting, y: frame.height - edgeHighlightHeight, width: width, height: edgeHighlightHeight))
                highlightView = UIView(frame: CGRect(x: width / 2 - width / 4, y: self.frame.height - edgeHighlightHeight, width: width / 2, height: edgeHighlightHeight))
                
                //47
            }
            highlightView.backgroundColor = highlightColor
            self.addSubview(highlightView)
        }
        
        /// Removes all segments from the segment control.
        (self.subviews as [UIView]).forEach { $0.removeFromSuperview() }
        let totalWidth = self.frame.width
        
        if contentType == .text {
            let tabBarSections:Int = segmentTitle.count
            let sectionWidth = totalWidth / CGFloat(tabBarSections)
            addHighlightView(startingPosition: CGFloat(selectedSegment) * sectionWidth, width: sectionWidth)
            addSegments(startingPosition: 0, sections: tabBarSections, width: sectionWidth, height: self.frame.height)
        } else if contentType == .icon {
            /// Icon Mode assumes that there are always 6 segments so that it can center the icons in the middle of the bar.
            let tabBarSections:Int = segmentIcon.count
            let sectionWidth = totalWidth / 6
            let availableSpace = totalWidth - (sectionWidth * CGFloat(6 - tabBarSections))
            let startingXPosition = (totalWidth - availableSpace) / 2
            addHighlightView(startingPosition: startingXPosition + (sectionWidth * CGFloat(selectedSegment)), width: sectionWidth)
            addSegments(startingPosition: startingXPosition, sections: tabBarSections, width: sectionWidth, height: self.frame.height)
        } else { // Hybrid
            let tabBarSections:Int = segmentContent.text.count
            let sectionWidth = totalWidth / CGFloat(tabBarSections)
            addHighlightView(startingPosition: CGFloat(selectedSegment) * sectionWidth, width: sectionWidth)
            addSegments(startingPosition: 0, sections: tabBarSections, width: sectionWidth, height: self.frame.height)
        }
    }
    
    /// Called whenever a segment is pressed. Sends the information to the delegate.
    @objc fileprivate func segmentPressed(_ sender:UIButton){
        /// Returns true if the view is a `UIButton`
        func isUIButton(_ view:UIView) -> Bool {
            return view is UIButton ? true : false
        }
        
        let xPosition:CGFloat = sender.frame.origin.x
        // let newPosition:CGPoint = CGPoint(x: xPosition + highlightView.frame.size.width / 2, y: highlightView.frame.origin.y )
        let newPosition:CGPoint = CGPoint(x: xPosition, y: highlightView.frame.origin.y)
        
        
        /// Animates the movement of the `highlightView` and sets the appropiate tint.
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.highlightView.frame.origin = newPosition
            
            switch(self.contentType){
            case .icon, .hybrid:
                ((self.subviews.filter(isUIButton)) as! [UIButton]).forEach { $0.tintColor = self.tint }
                sender.tintColor = self.highlightTint
            case .text:
                ((self.subviews.filter(isUIButton)) as! [UIButton]).forEach { $0.setTitleColor(self.tint, for: UIControlState()) }
                sender.setTitleColor(self.highlightTint, for: UIControlState())
            }
            
        }, completion: nil)
        
        selectedSegment = sender.tag
        delegate?.xmSegmentedControl(self, selectedSegment: selectedSegment)
    }
    
    /**
     Scales an image to the set size. The size is 20x20. It takes into account alpha and uses the screen's scale to resize.
     - ToDo: Allow the size to be variable and changed instead of fixed. As of now it looks good in a segmentedControl with a height of 44.
     */
    fileprivate func resizeImage(_ image:UIImage) -> UIImage {
        let size = CGSize(width: 20, height: 20)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        image.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
}
