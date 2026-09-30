mixin YuzmeYetisi {
  void dalisYap() {
    print("Denizci su altna daldı");
  }
}

class Denizci with YuzmeYetisi {
}

void main() {
  final Denizci denizci = Denizci();
  denizci.dalisYap();
}