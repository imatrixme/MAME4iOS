//
//  GameInfoController.swift
//  MAME4iOS
//
//  Created by Todd Laney on 5/8/22.
//  Copyright © 2022 MAME4iOS Team. All rights reserved.
//

import Foundation
import UIKit

#if os(tvOS)
class TVOSScrollView: UIScrollView {
    override var canBecomeFocused: Bool { true }
}
#endif

public class ScaleAspectFitImageView : UIImageView {
    private var heightConstraint: NSLayoutConstraint?

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder:aDecoder)
    self.setup()
  }

  public override init(frame:CGRect) {
    super.init(frame:frame)
    self.setup()
  }

  public override init(image: UIImage!) {
    super.init(image:image)
    self.setup()
  }

  public override init(image: UIImage!, highlightedImage: UIImage?) {
    super.init(image:image,highlightedImage:highlightedImage)
    self.setup()
  }

  override public var image: UIImage? {
    didSet {
      self.updateHeightConstraint()
    }
  }

  private func setup() {
    self.contentMode = .scaleAspectFit
    self.updateHeightConstraint()
  }

    public override func layoutSubviews() {
        super.layoutSubviews()
        updateHeightConstraint()
    }

  /// Removes any pre-existing aspect ratio constraint, and adds a new one based on the current image
  private func updateHeightConstraint() {
      // remove any existing aspect ratio constraint
      if let c = self.heightConstraint {
          self.removeConstraint(c)
      }
      self.heightConstraint = nil
      
      if let imageSize = image?.size, frame.size.width < imageSize.width {
          let aspectratio = imageSize.height / imageSize.width
          let heightConstraint = NSLayoutConstraint(
            item: self,
            attribute: .height,
            relatedBy: .equal,
            toItem: self,
            attribute: .width,
            multiplier: aspectratio,
            constant: 0
          )
          addConstraint(heightConstraint)
          self.heightConstraint = heightConstraint
      }
  }
}


@objcMembers class GameInfoController : UIViewController {

    private let attributes : [UIFont.TextStyle:[NSAttributedString.Key:Any]] = [
        .largeTitle: [
            .font:UIFont.systemFont(ofSize:UIFont.preferredFont(forTextStyle:.body).pointSize * 2, weight:.heavy),
            .foregroundColor:UIColor.white,
            .paragraphStyle: NSParagraphStyle.center,
        ],
        .headline: [
            .font:UIFont.preferredFont(forTextStyle:.headline),
            .foregroundColor:UIColor.white,
        ],
        .body: [
            .font:UIFont.preferredFont(forTextStyle:.body),
            .foregroundColor:UIColor.lightGray,
        ]
    ]
    
    private let game:GameInfo
    
    #if os(tvOS)
    private let scrollView = TVOSScrollView()
    #else
    private let scrollView = UIScrollView()
    #endif
    private let contentView = UIView()
    private let imageView = ScaleAspectFitImageView()
    private let label = UILabel()
        
    init(game:GameInfo) {
        self.game = game
        super.init(nibName: nil, bundle: nil)
        title = "Info"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        #if os(iOS)
        view.backgroundColor = UIColor.systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:.done, target:self, action:#selector(done))
        #else
        scrollView.panGestureRecognizer.allowedTouchTypes = [NSNumber(value: UITouch.TouchType.indirect.rawValue)]
        view.backgroundColor = UIColor.black
        #endif
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
        label.backgroundColor = view.backgroundColor
        
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        contentView.addSubview(label)
        setupConstraints()

        let text = NSMutableAttributedString(string:"")
        
        imageView.image = ChooseGameController.getGameIcon(game)
        
        text.append(ChooseGameController.getGameText(game))
        text.append(NSAttributedString(string:"\n\n"))

        text.append(getMetaText())

        if let info = getInfoText("history") {
            text.append(NSAttributedString(string:"History\n", attributes:attributes[.largeTitle]))
            text.append(info)
        }
            
        if let info = getInfoText("mameinfo") {
            text.append(NSAttributedString(string:"MAME Info\n", attributes:attributes[.largeTitle]))
            text.append(info)
        }
            
        label.attributedText = text
    }
    
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        #if os(tvOS)
        let scrollViewTopConstraint = scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        #else
        let scrollViewTopConstraint = scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        #endif
        
        NSLayoutConstraint.activate([
            scrollViewTopConstraint,
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),
            imageView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.8),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor)
        ])
    }
    
#if os(iOS)
    @objc func done() {
        presentingViewController?.dismiss(animated: true)
    }
#endif
}

private extension GameInfoController {

    func getMetaText() -> NSAttributedString {
        
        let text = NSMutableAttributedString()
        
        var keyWidth = 0.0
        let dict = game.gameDictionary
        for key in dict.keys.sorted(by:<) {
            guard var val = dict[key], !val.isEmpty else { continue }
            if val.contains(",") && !val.contains(", ") {
                val = val.replacingOccurrences(of: ",", with: ", ")
            }
            let keyText = NSAttributedString(string:"\(key)\t", attributes:attributes[.headline])
            let valText = NSAttributedString(string:"\(val)\n", attributes:attributes[.body])

            text.append(keyText)
            text.append(valText)
            keyWidth = max(keyWidth, ceil(keyText.size().width))
        }
        keyWidth += 4.0;

        let para = NSMutableParagraphStyle()
        para.tabStops = [NSTextTab(textAlignment:.left, location:keyWidth)]
        para.defaultTabInterval = keyWidth
        para.headIndent = keyWidth
        para.firstLineHeadIndent = 0
        para.paragraphSpacing = 0
        
        text.addAttribute(.paragraphStyle, value:para, range:NSRange(location:0, length:text.length))
        
        return text;
    }
    
    func getInfoText(_ name:String) -> NSAttributedString?
    {
        let db = InfoDatabase(path: getDocumentPath("dats/\(name).dat"))

        return db.attributedString(forKey:game.gameName, attributes:attributes) ??
               db.attributedString(forKey:game.gameParent, attributes:attributes)
    }
}

private extension NSAttributedString {
    convenience init(image:UIImage) {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        self.init(attachment: imageAttachment)
    }
}

private extension NSParagraphStyle {
    class var center : NSParagraphStyle {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        return paragraph
    }
}
private extension NSAttributedString {
    var centered:NSAttributedString {
        let text = NSMutableAttributedString(attributedString:self)
        text.addAttribute(.paragraphStyle, value:NSParagraphStyle.center, range:NSRange(location:0, length:text.length))
        return text
    }
}

#if os(tvOS)
extension UIFont.TextStyle {
    // HACK: re-use callout as largeTitle on tvOS
    static let largeTitle = UIFont.TextStyle.callout
}
#endif

