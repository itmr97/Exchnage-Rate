import 'package:exchnage_rate/models/currency.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ExchnageRate extends StatelessWidget
{
  const ExchnageRate({super.key});
  @override
  Widget build(BuildContext context)
  {
    
 
    return  MaterialApp(
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
        home: Center(
          child: Scaffold(
            appBar: AppBar(title: const Text('Currency Converter',
              style: TextStyle(
              color: Colors.green,
              fontSize: 25,
              fontWeight: FontWeight.w700
              ),
              ),
              centerTitle: true,
              backgroundColor: Colors.black87,
            ),
            body: const Currency()
            )
          ),
        );
  
  }

}