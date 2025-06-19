// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {

//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text('You have pushed the button this many times:'),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }

import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(CalculadoraApp());

class CalculadoraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora Científica',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: CalculadoraCientifica(),
    );
  }
}

class CalculadoraCientifica extends StatefulWidget {
  @override
  State<CalculadoraCientifica> createState() => _CalculadoraCientificaState();
}

class _CalculadoraCientificaState extends State<CalculadoraCientifica> {
  String _display = '0';
  double _value = 0.0;
  double _storedValue = 0.0;
  String? _operation;
  bool _shouldClear = false;

  void _append(String text) {
    setState(() {
      if (_shouldClear || _display == '0') {
        _display = text;
        _shouldClear = false;
      } else {
        _display += text;
      }
      _value = double.tryParse(_display) ?? 0.0;
    });
  }

  void _clear() {
    setState(() {
      _display = '0';
      _value = 0.0;
      _storedValue = 0.0;
      _operation = null;
      _shouldClear = false;
    });
  }

  void _setOperation(String op) {
    setState(() {
      _storedValue = _value;
      _operation = op;
      _shouldClear = true;
    });
  }

  void _calculate() {
    if (_operation == null) return;
    double result;
    switch (_operation) {
      case '+':
        result = _storedValue + _value;
        break;
      case '-':
        result = _storedValue - _value;
        break;
      case '*':
        result = _storedValue * _value;
        break;
      case '/':
        result = _value != 0 ? _storedValue / _value : double.nan;
        break;
      default:
        result = _value;
    }

    setState(() {
      _display = result.toStringAsPrecision(10);
      _value = result;
      _operation = null;
      _shouldClear = true;
    });
  }

  void _applyFunction(double Function(double) func) {
    setState(() {
      double res = func(_value);
      _display = res.isNaN ? 'Error' : res.toStringAsPrecision(10);
      _value = res;
      _shouldClear = true;
    });
  }

  void _setPi() {
    setState(() {
      _value = pi;
      _display = _value.toStringAsPrecision(10);
      _shouldClear = true;
    });
  }

  Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
    Color bgColor = const Color(0xFF2E2E2E),
    Color fgColor = Colors.white,
    double fontSize = 22,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: fontSize, color: fgColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> buttons = [
      _buildButton(text: 'sin', onPressed: () => _applyFunction(sin)),
      _buildButton(text: 'cos', onPressed: () => _applyFunction(cos)),
      _buildButton(text: 'tan', onPressed: () => _applyFunction(tan)),
      _buildButton(text: 'π', onPressed: _setPi),
      _buildButton(text: 'log', onPressed: () => _applyFunction((v) => v > 0 ? log(v) : double.nan)),
      _buildButton(text: '√', onPressed: () => _applyFunction((v) => v >= 0 ? sqrt(v) : double.nan)),
      _buildButton(text: 'x²', onPressed: () => _applyFunction((v) => pow(v, 2).toDouble())),
      _buildButton(text: '1/x', onPressed: () => _applyFunction((v) => v != 0 ? 1 / v : double.nan)),
      _buildButton(text: 'exp', onPressed: () => _applyFunction(exp)),
      _buildButton(text: 'abs', onPressed: () => _applyFunction((v) => v.abs())),
      _buildButton(text: 'C', onPressed: _clear, bgColor: Colors.red),
      _buildButton(text: '/', onPressed: () => _setOperation('/'), bgColor: Colors.orange),
      _buildButton(text: '7', onPressed: () => _append('7')),
      _buildButton(text: '8', onPressed: () => _append('8')),
      _buildButton(text: '9', onPressed: () => _append('9')),
      _buildButton(text: '', onPressed: () => _setOperation(''), bgColor: Colors.orange),
      _buildButton(text: '4', onPressed: () => _append('4')),
      _buildButton(text: '5', onPressed: () => _append('5')),
      _buildButton(text: '6', onPressed: () => _append('6')),
      _buildButton(text: '-', onPressed: () => _setOperation('-'), bgColor: Colors.orange),
      _buildButton(text: '1', onPressed: () => _append('1')),
      _buildButton(text: '2', onPressed: () => _append('2')),
      _buildButton(text: '3', onPressed: () => _append('3')),
      _buildButton(text: '+', onPressed: () => _setOperation('+'), bgColor: Colors.orange),
      _buildButton(text: '0', onPressed: () => _append('0')),
      _buildButton(text: '.', onPressed: () => _append('.')),
      _buildButton(text: '=', onPressed: _calculate, bgColor: Colors.green),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Calculadora Científica'),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            alignment: Alignment.centerRight,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Text(
                _display,
                style: const TextStyle(fontSize: 48, color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: GridView.count(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: buttons,
              ),
            ),
          ),
        ],
      ),
    );
  }
}