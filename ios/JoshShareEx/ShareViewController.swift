//
//  ShareViewController.swift
//  JoshShareEx
//
//  Created by Ajay Sareriya on 12/01/21.
//

import UIKit
import Social
import SafariServices
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {
  override func isContentValid() -> Bool {
    // Do validation of contentText and/or NSExtensionContext attachments here
    return true
  }
  override func viewDidLoad() {
    didSelectPost()
  }
  override func didSelectPost() {
//    self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
//    super.didSelectCancel()
//    self.dismiss(animated: true)
    
    if let item = extensionContext?.inputItems.first as? NSExtensionItem {
      if let attachments = item.attachments {
        for attachment: NSItemProvider in attachments {
          if attachment.hasItemConformingToTypeIdentifier("public.url") {
            attachment.loadItem(forTypeIdentifier: "public.url", options: nil, completionHandler: { (url, error) in
              if let shareURL = url as? NSURL {
                // Do stuff with your URL now.
                let url = NSURL(string: "test.app.link://App/\(shareURL)")
                let selectorOpenURL = sel_registerName("openURL:")
                let context = NSExtensionContext()
                context.open(url! as URL, completionHandler: nil)
                var responder = self.parent as UIResponder?
                while (responder != nil){
                  if responder?.responds(to: selectorOpenURL) == true{
                    responder?.perform(selectorOpenURL, with: url)
                  }
                  responder = responder!.next
                }
              }
              //If we uncomment this line then we are getting the Post pop up.
//              self.extensionContext?.completeRequest(returningItems: [], completionHandler:nil)

              super.didSelectCancel()
              self.dismiss(animated: true)
              self.dismiss(animated: true) {
                self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
              }
            })
          }
          if attachment.hasItemConformingToTypeIdentifier(kUTTypeImage as String) {
            attachment.loadItem(forTypeIdentifier: (kUTTypeImage as String), options: nil, completionHandler: { (item, error) in
              if let resultURL = item as? NSURL {
                // if let itemImage = item as? UIImage{
                let url = NSURL(string: "test.app.link://page1/\(resultURL)")
                let selectorOpenURL = sel_registerName("openURL:")
                let context = NSExtensionContext()
                context.open(url! as URL, completionHandler: nil)
                var responder = self.parent as UIResponder?
                while (responder != nil){
                  if responder?.responds(to: selectorOpenURL) == true{
                    responder?.perform(selectorOpenURL, with: url)
                  }
                  responder = responder!.next
                }
              }
              self.extensionContext?.completeRequest(returningItems: [], completionHandler:nil)
              //super.didSelectCancel()
            })
          }
        }
      }
    }
    // self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
  }
  //    override func configurationItems() -> [Any]! {
  //        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
  //        return []
  //    }
  override func didSelectCancel() {
    super.didSelectCancel()
    self.extensionContext?.completeRequest(returningItems: [], completionHandler:nil)
  }
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
      dismiss(animated: true)
      self.extensionContext?.completeRequest(returningItems: [], completionHandler:nil)
    }
}
