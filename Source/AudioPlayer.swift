import AVFoundation

public class AudioPlayer {

  enum Error: ErrorType {
    case SoundNotFound
  }

  var player: AVAudioPlayer?

  var session: AVAudioSession {
    return AVAudioSession.sharedInstance()
  }

  // MARK: - Start playback

  public func play(sound: Sound) throws {
    try session.setCategory(AVAudioSessionCategoryPlayback)
    try session.setActive(true)

    let bundle = NSBundle.mainBundle()

    guard let path = bundle.pathForResource(sound.rawValue, ofType: "aiff") else {
      throw Error.SoundNotFound
    }

    let URL = NSURL(fileURLWithPath: path)

    if player?.playing == true {
      stop()
    }

    player = try AVAudioPlayer(contentsOfURL: URL)
    player?.prepareToPlay()
    player?.play()
  }

  public func playSafely(sound: Sound) {
    do {
      try play(sound)
    } catch {}
  }

  public func resume() {
    guard let player = player where !player.playing else {
      return
    }

    player.play()
  }

  // MARK: - Stop playback

  public func stop() {
    player?.stop()
    player?.currentTime = 0
    player = nil
  }

  public func pause() {
    guard let player = player where player.playing else {
      return
    }

    player.pause()
  }
}