class GameTime {
  int phase;

  // boolean getters for each phase/day/night
  bool get isSunrise {
    return (phase == 0);
  }

  bool get isSunset {
    return (phase == 1);
  }

  bool get isPreWerewolfs {
    return (phase == 2);
  }

  bool get isWithWerewolfs {
    return (phase == 3);
  }

  bool get isAfterWerewolfs {
    return (phase == 4);
  }

  bool get isDay {
    return isSunrise || isSunset;
  }

  bool get isNight {
    return isPreWerewolfs || isWithWerewolfs || isAfterWerewolfs;
  }

  // GameTime constructor and controller
  GameTime(this.phase);

  void next() {
    phase = (phase + 1) % 5;
  }

  // Static getters for each phase
  static GameTime get sunrise {
    return GameTime(0);
  }

  static GameTime get sunset {
    return GameTime(1);
  }

  static GameTime get preWerewolfs {
    return GameTime(2);
  }

  static GameTime get withWerewolfs {
    return GameTime(3);
  }

  static GameTime get afterWerewolfs {
    return GameTime(4);
  }

  // Override toString, equals, and hashCode methods
  @override
  String toString() {
    if (isSunrise) {
      return "Sunrise";
    } else if (isSunset) {
      return "Sunset";
    } else if (isPreWerewolfs) {
      return "PreWerewolfs";
    } else if (isWithWerewolfs) {
      return "WithWerewolfs";
    } else if (isAfterWerewolfs) {
      return "AfterWerewolfs";
    } else {
      throw Exception("Unknown phase");
    }
  }

  @override
  bool operator ==(Object other) {
    if (other is! GameTime) return false;
    return phase == other.phase;
  }

  @override
  int get hashCode => phase;
}
