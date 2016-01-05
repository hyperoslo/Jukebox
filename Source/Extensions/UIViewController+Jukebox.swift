import UIKit

extension UIViewController {

  // MARK: - Method Swizzling

  public override class func initialize() {
    struct Static {
      static var token: dispatch_once_t = 0
    }

    if self !== UIViewController.self { return }

    dispatch_once(&Static.token) {
      MethodSwizzler.swizzleMethod("viewWillAppear:", cls: self)
      MethodSwizzler.swizzleMethod("viewWillDisappear:", cls: self)
    }
  }

  func jukebox_viewWillAppear(animated: Bool) {
    jukebox_viewWillAppear(animated)

    guard animated && Jukebox.autoPlay else { return }

    var sound: Sound?

    if isMovingToParentViewController() {
      sound = .Forward
    } else if isBeingPresented() {
      sound = .Forward
    }

    guard let soundToPlay = sound else { return }

    do {
      try Jukebox.player.play(soundToPlay)
    } catch {
      print(error)
    }
  }

  func jukebox_viewWillDisappear(animated: Bool) {
    jukebox_viewWillDisappear(animated)

    guard animated && Jukebox.autoPlay else { return }

    var sound: Sound?

    if isMovingFromParentViewController() {
      sound = .Back
    } else if isBeingDismissed() {
      sound = .Back
    }

    guard let soundToPlay = sound else { return }

    do {
      try Jukebox.player.play(soundToPlay)
    } catch {
      print(error)
    }
  }
}
