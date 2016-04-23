//
//  AutoCompleteViewController.swift
//  Autocomplete
//
//  Created by Amir Rezvani on 3/6/16.
//  Copyright © 2016 cjcoaxapps. All rights reserved.
//

import UIKit
import Alamofire

let AutocompleteCellReuseIdentifier = "autocompleteCell"

public class AutoCompleteViewController: UIViewController {
    //MARK: - outlets
    @IBOutlet private weak var tableView: UITableView!

    //MARK: - internal items
    internal var autocompleteItems: [AutocompletableOption]?
    internal var cellHeight: CGFloat?
    internal var cellDataAssigner: ((cell: UITableViewCell, data: AutocompletableOption) -> Void)?
    internal var textField: UITextField?
    internal let animationDuration: NSTimeInterval = 0.2    

    //MARK: - private properties
    private var autocompleteThreshold: Int?
    private var maxHeight: CGFloat = 0
    private var height: CGFloat = 0

    //MARK: - public properties
    public weak var delegate: AutocompleteDelegate?

    //MARK: - view life cycle
    override public func viewDidLoad() {
        super.viewDidLoad()

        self.view.hidden = true
        self.textField = self.delegate!.autoCompleteTextField()

        self.height = self.delegate!.autoCompleteHeight()
        self.view.frame = CGRect(x: CGRectGetMinX(self.textField!.frame),
            y: CGRectGetMaxY(self.textField!.frame),
            width: CGRectGetWidth(self.textField!.frame),
            height: self.height)

        self.tableView.registerNib(self.delegate!.nibForAutoCompleteCell(), forCellReuseIdentifier: AutocompleteCellReuseIdentifier)

        self.textField?.addTarget(self, action: #selector(UITextInputDelegate.textDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        self.autocompleteThreshold = self.delegate!.autoCompleteThreshold(self.textField!)
        self.cellDataAssigner = self.delegate!.getCellDataAssigner()

        self.cellHeight = self.delegate!.heightForCells()
        // not to go beyond bound height if list of items is too big
        self.maxHeight = CGRectGetHeight(UIScreen.mainScreen().bounds) - CGRectGetMinY(self.view.frame)
    }

    //MARK: - private methods
    @objc func textDidChange(textField: UITextField) {
        let numberOfCharacters = textField.text?.characters.count
        if let numberOfCharacters = numberOfCharacters {
            if numberOfCharacters > self.autocompleteThreshold! {
                self.view.hidden = false
                guard let searchTerm = textField.text else { return }
                
                var result = [AutocompletableOption]()
                
                let url = "http://certain-mystery-126718.appspot.com/"
                Alamofire.request(.GET, url, parameters: ["term": searchTerm]).responseJSON {
                    response in switch response.result {
                    case .Success(let JSON):
//                        print("Success with JSON: \(JSON)")
                        let response = JSON as! NSArray
                        for tmp in response {
                            let symbolCompany = tmp as! NSDictionary
                            let row =  "\(symbolCompany.objectForKey("Symbol")!)-\(symbolCompany.objectForKey("Name")!)-\(symbolCompany.objectForKey("Exchange")!)"
                            result.append(AutocompleteCellData(text: row, image: nil) as AutocompletableOption)
                        }
                        self.autocompleteItems = result
                        UIView.animateWithDuration(self.animationDuration,
                            delay: 0.0,
                            options: .CurveEaseInOut,
                            animations: { () -> Void in
                                self.view.frame.size.height = min(
                                    CGFloat(self.autocompleteItems!.count) * CGFloat(self.cellHeight!),
                                    self.maxHeight,
                                    self.height
                                )
                            },
                            completion: nil)
                        
                        UIView.transitionWithView(self.tableView,
                            duration: self.animationDuration,
                            options: .TransitionCrossDissolve,
                            animations: { () -> Void in
                                self.tableView.reloadData()
                            },
                            completion: nil)
                        
                    case .Failure(let error):
                        print("Request failed with error: \(error)")
                    }
                }
            } else {
                self.view.hidden = true
            }
        }
    }

}
