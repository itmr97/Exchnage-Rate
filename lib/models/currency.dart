import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Currency extends StatefulWidget {
  const Currency({super.key});

  @override
  State<Currency> createState() {
    return CurrencyState();
  }
}

class CurrencyState extends State<Currency> {
  List<String> _codes = [];
  var _based = 'USD';
  var _terget= 'IQD';
  double _amount = 0;
  dynamic rate;
  dynamic result;
  var _isLoading = true;
   String? _error;

  @override
  void initState() {
    super.initState();
       _loadcountries();
       _convert();
  }

  void _convert() async {
    final response = await http.get(Uri.parse(
        'https://v6.exchangerate-api.com/v6/YOUR-API-KEY/pair/$_based/$_terget/$_amount'));

    final Map<String, dynamic> listData = json.decode(response.body);
    setState(() {
      rate = listData['conversion_rate'];
      result = listData['conversion_result'];
    });
    }
  void _loadcountries() async {
    final List<String> countries_codes = [];
    final response = await http.get(Uri.parse(
        'https://v6.exchangerate-api.com/v6/YOUR-API-KEY/codes'));
      
      try{
     if (response.statusCode >= 400) {
        setState(() {
          _error = 'Failed to fetch data. Please try again later.';
        });
      } 

      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
        });
        return;
      }
    final Map<String, dynamic> listData = json.decode(response.body);
    final List countries = listData['supported_codes'];

    for (final item in countries) {
      countries_codes.add(item.first);
    }
    setState(() {
      _codes = countries_codes;
       _isLoading = false;
    });
      }catch(error)
      {
        setState(() {
        _error = 'Something went wrong! Please try again later.';
      });
      }
  }

  @override
  Widget build(BuildContext context) {
       Widget content = const Center(child: Text('No items added yet.'));

   if (_isLoading) {
      content = const Center(child: CircularProgressIndicator(color:Colors.green));
    }
     if (_error != null) {
      content = Center(child: Text(_error!));
    }

    if(_codes.isNotEmpty)
    {
      content=SingleChildScrollView(
        child: Center(
          child: Column(
        children: [
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.only(left: 140,right: 140),
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
              label: Text('Amount',style: TextStyle(
                fontWeight: FontWeight.w600
              ),)
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 40),
              onChanged: (value) {
                setState(() {
                   _amount = double.parse(value); 
                   if(_amount==0)
                   {
                    result=0;
                   }
                });  
                _convert();
              },
            ),
          ),
         const  SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Text('BASE CURRENCY',style: TextStyle(
                      fontWeight: FontWeight.w800
                    ),),
                    const SizedBox(height: 20),
                    DropdownButton(
                        value: _based,
                        style: const TextStyle(
                          fontSize: 20, color:
                         Colors.black,
                         fontWeight: FontWeight.w500
                         ),
                        items: [
                          for (final item in _codes)
                            DropdownMenuItem(
                            value: item, child: Text(item)
        
                            
                            )
                        ],
                        onChanged: (value) {
                          setState(() {
                             _based = value!;
                             _convert(); 
                          });
                           
                        }),
                  ],
                ),
                    const SizedBox(width: 30),
                     IconButton(onPressed: (){
                      String swip=_based;
                      _based=_terget;
                      _terget=swip;
                      _convert();
        
                     }, 
           icon:const Icon(Icons.swap_horizontal_circle_outlined),
           iconSize: 45,
           ),
           const SizedBox(width: 30),
                     Column(
                       children: [
                       const Text('TERGET CURRENCY',style: TextStyle(
                      fontWeight: FontWeight.w900)),
                      const SizedBox(height: 20),
                         DropdownButton(
                       value: _terget,
                      style: const TextStyle(
                        fontSize: 20, 
                      color: Colors.green,
                       fontWeight: FontWeight.w700
                      ),
                        items: [
                          for (final item in _codes)
                            DropdownMenuItem(value: item, child: Text(item))
                                         ],
                         onChanged: (value) {
                          setState(() {
                           _terget = value!;
                           _convert(); 
                          });                  
                        }),
                       ],
                     ),
              ],
            ),
          ),
         const Divider(
                    color: Colors.black,
                    endIndent: 60,
                    indent: 60,
                   ),
                   Text(_terget,style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.green
                   ),),
                   Text(result.toString(),style: const TextStyle(fontSize: 40, color: Colors.black),),
                   const SizedBox(height: 20),
                   Text('1 $_based = $rate $_terget',
                   style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700
                   ),)
        ],
            )
            ),
      );
    }
    return content;
  }
}
