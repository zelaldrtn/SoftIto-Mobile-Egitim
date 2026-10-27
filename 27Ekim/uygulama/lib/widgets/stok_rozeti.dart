import 'package:flutter/material.dart';

class StokRozeti extends StatelessWidget{
    final int stok;

    const StokRozeti({super.key,required this.stok});

    @override
    Widget build(BuildContext context){
        final tukendiMi=stok==0;

        return Container(
            //container: görsel kutu
            padding: const EdgeInsets.symmetric(horizontal: 8,vertical:4),
            decoration: BoxDecoration(
                color: tukendiMi ? Colors.red.shade100: Colors.green.shade100,
                borderRadius: BorderRadius.circular(6), // %6 kadar köşeleri yuvarlar
                border:Border.all(
                    color:tukendiMi ? Colors.red.shade400: Colors.green.shade400,
                    width:0.8,
                ),
                child: Text(
                    tukendiMi ? "Tükendi": 'Stok: $stok',
                    style:TextStyle(
                        color: tukendiMi ? Colors.red.shade900 : Colors.gree.shade900,
                        fontSize:11,
                        fontWeight: FontWeight.bold,
                    ),
                );
            )
        )
    }
}