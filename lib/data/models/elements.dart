enum Element { WATER, EARTH, FIRE, WIND }

class Elements {
  int water;
  int earth;
  int fire;
  int wind;

  Elements({this.water, this.earth, this.fire, this.wind});

  void addElement(Element element) {
    switch (element) {
      case Element.WATER:
        water += 1;
        break;
      case Element.EARTH:
        earth += 1;
        break;
      case Element.FIRE:
        fire += 1;
        break;
      case Element.WIND:
        wind += 1;
        break;
    }
  }
}
