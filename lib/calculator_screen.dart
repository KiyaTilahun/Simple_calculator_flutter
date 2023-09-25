// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_based_calculator/buttons.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = "";
  String operand = "";
  String number2 = "";
  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "${number1.toString()} ${operand.toString()} ${number2.toString()}",
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),
            Wrap(
              children: Btn.buttonValues
                  .map((e) => SizedBox(
                      width: e == Btn.n0 ? screen.width / 2 : screen.width / 4,
                      height: screen.width / 5,
                      child: buildButton(e)))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget buildButton(value) {
    return Padding(
      padding: EdgeInsets.all(4),
      child: Material(
        color: getBtncolor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white24),
            borderRadius: BorderRadius.circular(100)),
        child: InkWell(
          onTap: () => onBtnTap(value.toString()),
          child: Center(
              child: Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          )),
        ),
      ),
    );
  }

  Color getBtncolor(value) {
    return [Btn.del, Btn.clr].contains(value)
        ? Colors.blueGrey
        : [
            Btn.per,
            Btn.multiply,
            Btn.add,
            Btn.subtract,
            Btn.divide,
            Btn.calculate
          ].contains(value)
            ? Colors.orange
            : Colors.black87;
  }

  void onBtnTap(String value) {
    if (value == Btn.del) {
      delete();
      return;
    }
    if (value == Btn.clr) {
      clear();
      return;
    }
    if (value == Btn.per) {
      convertTopercentage();
      return;
    }
    if (value == Btn.calculate) {
      calculate();
      return;
    }

    appendValue(value);
  }

  void calculate() {
    if (number1.isEmpty || number2.isEmpty || operand.isEmpty) {
      return;
    }
    double num1 = double.parse(number1);
    double num2 = double.parse(number2);
    var result = 0.0;
    switch (operand) {
      case Btn.add:
        result = num1 + num2;
        break;
      case Btn.subtract:
        result = num1 - num2;
        break;
      case Btn.multiply:
        result = num1 * num2;
        break;
      case Btn.divide:
        result = num1 / num2;
        break;
      default:
    }
    setState(() {
      number1 = "$result";
      if (number1.endsWith(".0")) {
        number1 = number1.substring(0, number1.length - 2);
      }
    });
    operand = "";
    number2 = "";
  }

  void convertTopercentage() {
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {
      calculate();
    }
    if (operand.isNotEmpty) {
      return;
    }
    final number = double.parse(number1);
    setState(() {
      number1 = "${(number / 100)}";
      operand = "";
      number2 = "";
    });
  }

  void delete() {
    if (number2.isNotEmpty) {
      number2 = number2.substring(0, number2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    }
    setState(() {});
  }

  void clear() {
    setState(() {
      number1 = "";
      operand = "";
      number2 = "";
    });
  }

  void appendValue(String value) {
    if (value != Btn.dot && int.tryParse(value) == null) {
      // operanfd pressed
      if (operand.isNotEmpty && number2.isNotEmpty) {
        calculate();
        // if there is already an operand
      }
      operand = value;
    } else if (number1.isEmpty || operand.isEmpty) {
      if (value == Btn.dot && number1.contains(Btn.dot)) return;
      if (value == Btn.dot && (number1.isEmpty || number1 == Btn.n0)) {
        value = "0.";
      }
      number1 += value;
    } else if (number2.isEmpty || operand.isNotEmpty) {
      if (value == Btn.dot && number1.contains(Btn.dot)) return;
      if (value == Btn.dot && (number1.isEmpty || number1 == Btn.n0)) {
        value = "0.";
      }
      number2 += value;
    }
    setState(() {});
  }
}
