//bir canavar sınıfı tanımlancak soyut olrk içinde void kükre diye boş gövdesiz
//metod onun içinde kurt canavarı ve ejderha canavarı olcak çalıştırıp
// kükreme eslerini ekrna yazcaz

abstract class Canavar {
  void kukre();
}

class Kurt extends Canavar {
  @override
  void kukre(){
    print("Kurt: Auu");
  }
}

class Ejderha extends Canavar{
  @override
  void kukre(){
    print("Ejderha: rawr");
  }
}

void canavarlarKukresin(List<Canavar> canavarlar){
  print("Canavarlar kükremeye başlasın");
  for(var canavar in canavarlar){
    canavar.kukre();
  }
}

void main(){
  print("Canavarlar");
  final List<Canavar> canavarlar =[
    Kurt(),
    Ejderha(),
  ];
    
  canavarlarKukresin(canavarlar);
}