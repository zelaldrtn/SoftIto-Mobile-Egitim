// mekan verilerini düzenli bir arada tutmak için oluşturulan veri modeli sınıfı
class PlaceItem {
  // final: nesne oluşturulduktan sonra bu değerlerin sonradan değiştirilemeyeceğini belirtir
  final String name;
  final String city;
  final String category;
  final double rating;
  final double entryFee;

  // const constructor: derleme zamanında sabit nesneler üreterek bellek tüketimini azaltır
  // required: nesne oluşturulurken bu parametrelerin doldurulmasını zorunlu kılar
  const PlaceItem({
    required this.name,
    required this.city,
    required this.category,
    required this.rating,
    required this.entryFee,
  });
}

