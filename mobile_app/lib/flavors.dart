enum FlavorOption {
  dev,
  prod,
}

class Flavors {
  static late final FlavorOption appFlavor;

  static String get name => appFlavor.name;

  static String get title {
    switch (appFlavor) {
      case FlavorOption.dev:
        return 'dev Access Control';
      case FlavorOption.prod:
        return 'Access Control';
    }
  }
}
