1. Widget Tree
*İskelet
*Immutable (değişmez)
*Çok ucuz (hafif)
*saniyede 60-120 kez ÇÖPE atılıpy eniden üretilir.
*widgetlar ekranda çizim yapmaz
*sadece şablon sunar

2. Element Tree
*yönetici bölümü & Yaşayan Omurga
*Mutable (durumu ve referanslı hafızada canlı tutar değişir.)
*widget ile renderobject arasındaki koordinatördür (organizasyonu sunar)

//canUpdate
static bool canUpdate(Widget oldWidget, Widget newWidget){
    return oldWidget.runType=newWidget.runTimeType && oldWidget.key ==newWidget.key;
}

State Yaşam Döngüsü

*StatefulWidget immutable (olarak değişmez) her rebuildde yeniden olştrlr
*State mutable (durumu saklar) rebuil sırasında çöpe atılmaz element tarafında devam eder. 

Eğer iki sınıf birleşik olsaydı her rebuild esnasında kullanıcı girdiler yayaçlar controllerlar vb. sıfırlanırdı.

