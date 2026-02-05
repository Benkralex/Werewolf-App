class GameTime {
  int phase;

  // boolean getters for each phase/day/night
  bool get isSunrise {
    return (phase == 0);
  }

  bool get isSunset {
    return (phase == 1);
  }

  bool get isPreWerewolves {
    return (phase == 2);
  }

  bool get isWithWerewolves {
    return (phase == 3);
  }

  bool get isAfterWerewolves {
    return (phase == 4);
  }

  bool get isDay {
    return isSunrise || isSunset;
  }

  bool get isNight {
    return isPreWerewolves || isWithWerewolves || isAfterWerewolves;
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

  static GameTime get preWerewolves {
    return GameTime(2);
  }

  static GameTime get withWerewolves {
    return GameTime(3);
  }

  static GameTime get afterWerewolves {
    return GameTime(4);
  }

  // Override toString, equals, and hashCode methods
  @override
  String toString() {
    if (isSunrise) {
      return "sunrise";
    } else if (isSunset) {
      return "sunset";
    } else if (isPreWerewolves) {
      return "preWerewolves";
    } else if (isWithWerewolves) {
      return "withWerewolves";
    } else if (isAfterWerewolves) {
      return "afterWerewolves";
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
