class Degerlendirme{
    final double puan;
    final int oySayisi;

    const Degerlendirme({
        required this.puan,
        required this.oySayisi,
    });

    //fromJson json verisini alıp nesneye çevirmek içindir.
    //dynamic olmasının sebebi: bazen string bazen int gelebilir. Bu yüzden dynamic kullanıyoruz. Tipsiz.
    factory Degerlendirme.fromJson(Map<String,dynamic> json) {
        return Degerlendirme(
            puan:(json['rate'] as num?)?.toDouble() ?? 0.0,
            oySayisi:(json['count'] as num?)?.toInt() ?? 0,
        );
    }

}