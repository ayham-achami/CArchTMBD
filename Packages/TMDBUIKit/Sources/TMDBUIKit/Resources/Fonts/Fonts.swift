//
//  Fonts.swift

import UIKit
import Foundation

// MARK: - UIFont + VKC
extension UIFont {
    
    public enum Regular {
        
        public static var title1: UIFont {
            UIFont.systemFont(ofSize: 34, weight: .regular)
        }
        
        public static var title2: UIFont {
            UIFont.systemFont(ofSize: 28, weight: .regular)
        }
        
        public static var title3: UIFont {
            UIFont.systemFont(ofSize: 22, weight: .regular)
        }
        
        public static var title4: UIFont {
            UIFont.systemFont(ofSize: 20, weight: .regular)
        }
        
        public static var headline: UIFont {
            UIFont.systemFont(ofSize: 17, weight: .semibold)
        }
        
        public static var body1: UIFont {
            UIFont.systemFont(ofSize: 17, weight: .regular)
        }
        
        public static var body2: UIFont {
            UIFont.systemFont(ofSize: 15, weight: .regular)
        }
        
        public static var button: UIFont {
            UIFont.systemFont(ofSize: 16, weight: .regular)
        }
        
        public static var footnote: UIFont {
            UIFont.systemFont(ofSize: 13, weight: .regular)
        }
        
        public static var caption1: UIFont {
            UIFont.systemFont(ofSize: 12, weight: .regular)
        }
        
        public static var caption2: UIFont {
            UIFont.systemFont(ofSize: 11, weight: .regular)
        }
    }
    
    public enum Bold {
        
        public static var title1: UIFont {
            UIFont.systemFont(ofSize: 34, weight: .bold)
        }
        
        public static var title2: UIFont {
            UIFont.systemFont(ofSize: 28, weight: .bold)
        }
        
        public static var title3: UIFont {
            UIFont.systemFont(ofSize: 22, weight: .bold)
        }
        
        public static var title4: UIFont {
            UIFont.systemFont(ofSize: 20, weight: .semibold)
        }
        
        public static var headline: UIFont {
            UIFont.systemFont(ofSize: 17, weight: .semibold)
        }
        
        public static var body1: UIFont {
            UIFont.systemFont(ofSize: 17, weight: .semibold)
        }
        
        public static var body2: UIFont {
            UIFont.systemFont(ofSize: 15, weight: .semibold)
        }
        
        public static var button: UIFont {
            UIFont.systemFont(ofSize: 16, weight: .semibold)
        }
        
        public static var footnote: UIFont {
            UIFont.systemFont(ofSize: 13, weight: .semibold)
        }
        
        public static var caption1: UIFont {
            UIFont.systemFont(ofSize: 12, weight: .medium)
        }
        
        public static var caption2: UIFont {
            UIFont.systemFont(ofSize: 11, weight: .semibold)
        }
    }
}
