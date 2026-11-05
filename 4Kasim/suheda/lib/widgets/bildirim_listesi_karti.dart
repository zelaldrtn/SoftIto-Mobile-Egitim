import 'package:flutter/material.dart';
import '../models/bildirim_modeli.dart';

class BildirimListesiKarti extends StatelessWidget{
    final List<BildirimModeli> bildirimler;
    final String? token;
    final bool konuyaAboneMi;
    final ValueChanged<bool> onAboneDegisti;

    const BildirimListesiKarti({
        super.key,
        required this.bildirimler,
        required this.token,
        required this.konuyaAboneMi,
        required this.onAboneDegisti,
    });

    @override
    Widget build(BuildContext context){
        return Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade300),
            ),
            child: Padding(padding: const EdgeInsets.all(16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                    Row(children: [
                        const Icon(Icons.notifications_active_outlined,
                        color: Color(0xFF006C4A),
                        ),
                        const SizedBox(width:8),
                        const Expanded(child: Text('FCM Bildirim Merkezi', style: TextStyle(
                            fontSize:16,
                            fontWeight:FontWeight.bold,
                            color: Color(0xFF0F172A),
                        ),),),
                        Switch(
                            value:konuyaAboneMi,
                            onChanged:onAboneDegisti,
                            activeThumbColor: const Color.fromARGB(15,160,40,50),
                        ),
                    ],
                    ),
                    Text(
                        konuyaAboneMi ? 'tüm sınıf yayını aktif': 'yayın kapalı',
                        style: TextStyle(
                            fontSize: 12,
                            color: konuyaAboneMi ? const Color.fromARGB(15,24,59,17) : Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                        ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: const Color(0xFF0F172A),
                            borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                const Text(
                                    "Cihazın FCM tokeni",
                                    style: TextStyle(
                                        color: Color.fromARGB(255,26,40,52), 
                                        fontSize: 11,
                                    ),
                                ),
                                const SizedBox(height:2),
                                SelectableText(
                                    token ?? 'token alınıyor.',
                                    style: const TextStyle(
                                        color: Color(0xFF388888),
                                        fontSize: 11,
                                        fontFamily: 'monospace',
                                    ),
                                ),
                            ],
                        ),
                    ),


                    const SizedBox(height:14),
                    Text(
                        'Gelen Bildirimler (${bildirimler.length}):',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color.fromARGB(0,5,249,253),
                        ),
                    ),

                    const SizedBox(height:8),
                    bildirimler.isEmpty ? Container(
                        padding: const EdgeInsets.all(24),
                        alignment: Alignment.center,
                        child: Text(
                            'Henüz gelen bildirim yok',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize:12,
                                color:Colors.grey.shade500,
                            ),
                        )
                    ) 
                    : ListView.separated(
                        shrinkWrap:true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: bildirimler.length,
                        separatorBuilder: (_, _)=> const Divider(height: 1),
                        itemBuilder: (context,index){
                            final b = bildirimler[index];
                            return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const CircleAvatar(
                                    backgroundColor: Color.fromARGB(0,123,238,230),
                                    child: Icon(Icons.mark_email_unread_outlined,
                                    color: Color.fromARGB(0,123,25,25), size:20,),
                                ),
                                title: Text(
                                    b.baslik,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                    ),
                                ),
                                subtitle: Text(b.icerik),
                                trailing: Text(
                                    //padLeft: 2 basamaklı değilse başına 0 koyar
                                    '${b.tarih.hour.toString().padLeft(2,'0')}:${b.tarih.minute.toString().padLeft(2, '0')}',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade500,
                                    ),
                                ),
                            );
                        },
                    ),
                ],
            ),
            ),
        );
    }
}