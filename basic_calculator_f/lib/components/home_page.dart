import 'package:flutter/material.dart';
import 'calculator_logic.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CalculatorLogic _calculatorLogic = CalculatorLogic();
  TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _inputController.addListener(() {
      String inputValue = _inputController.text;
      if (inputValue.length <= 9) {
        _calculatorLogic.updateDisplay(inputValue);
      } else {
        _inputController.text = inputValue.substring(0, 9);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculator"),
        backgroundColor: Colors.grey[500],
      ),
      body: Container(
        padding: EdgeInsets.all(18),
        color: Colors.grey[500],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _inputController,
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.black, fontSize: 46),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '0',
                  hintStyle: TextStyle(fontSize: 46, color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCalculatorButton('7'),
                _buildCalculatorButton('8'),
                _buildCalculatorButton('9'),
                _buildOperatorButton('/'),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCalculatorButton('4'),
                _buildCalculatorButton('5'),
                _buildCalculatorButton('6'),
                _buildOperatorButton('*'),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCalculatorButton('1'),
                _buildCalculatorButton('2'),
                _buildCalculatorButton('3'),
                _buildOperatorButton('-'),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCalculatorButton('0'),
                _buildCalculatorButton('.'),
                _buildOperatorButton('+'),
                ElevatedButton(
                  onPressed: _onEqualsPressed,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text('=', style: TextStyle(color: Colors.red, fontSize: 24),),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _onClearPressed,
              child: Text("Clear (CE)"),
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculatorButton(String text) {
    return ElevatedButton(
      onPressed: () {
        _calculatorLogic.appendNumber(text);
        _updateDisplay();
      },
      child: Text(
        text,
        style: TextStyle(fontSize: 24),
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        onPrimary: Colors.black,
        padding: EdgeInsets.all(20),
        shape: CircleBorder(),
      ),
    );
  }

  Widget _buildOperatorButton(String operator) {
    return ElevatedButton(
      onPressed: () {
        _calculatorLogic.setOperator(operator);
        _updateDisplay();
      },
      child: Text(
        operator,
        style: TextStyle(fontSize: 24),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        padding: EdgeInsets.all(20),
        shape: CircleBorder(),
      ),
    );
  }

  void _updateDisplay() {
    setState(() {
      _inputController.text = _calculatorLogic.displayValue;
    });
  }

  void _onClearPressed() {
    _calculatorLogic.clear();
    _updateDisplay();
  }

  void _onEqualsPressed() {
    _calculatorLogic.calculate();
    _updateDisplay();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }
}
