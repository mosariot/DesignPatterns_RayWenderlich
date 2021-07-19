/// Copyright (c) 2019 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation

// flyweght class
public final class Fonts {
  
  public static let large = loadFont(name: fontName, size: 30.0)
  public static let medium = loadFont(name: fontName, size: 25.0)
  public static let small = loadFont(name: fontName, size: 18.0)
  
  public static let fontName = "coolstory-regular"
  
  private static func loadFont(name: String, size: CGFloat) -> UIFont {
    if let font = UIFont(name: name, size: size) {
      return font
    }
    
    let bundle = Bundle(for: Fonts.self)
    guard let url = bundle.url(forResource: name, withExtension: "ttf"),
    let fontData = NSData(contentsOf: url),
    let provider = CGDataProvider(data: fontData),
    let cgFont = CGFont(provider),
    let fontName = cgFont.postScriptName as String? else {
      preconditionFailure("Unable to load font named \(name)")
    }
    CTFontManagerRegisterGraphicsFont(cgFont, nil)
    return UIFont(name: fontName, size: size)!
  }
}
