class CalculatorLogic {
  String _displayValue = '0';
  double _storedValue = 0.0;
  double _secondOperand = 0.0;
  double _firstOperand = 0.0;
  String _operator = '';
  bool _isDecimalPressed = false;

  String get displayValue => _displayValue;

  void updateDisplay(String newValue) {
    _displayValue = newValue;
  }

  void clear() {
    _displayValue = '0';
    _storedValue = 0.0;
    _secondOperand = 0.0;
    _firstOperand = 0.0;
    _operator = '';
    _isDecimalPressed = false;
  }

  void delete() {
    if (_displayValue.isNotEmpty) {
      _displayValue = _displayValue.substring(0, _displayValue.length - 1);
      if (_displayValue.isEmpty) {
        clear();
      }
    }
  }

  void appendNumber(String number) {
    if (_displayValue == '0' && number != '.') {
      _displayValue = number; // Replace '0' with the new number
    } else {
      _displayValue += number;
    }

    if (number == '.') {
      _isDecimalPressed = true;
    }

    if (_operator.isEmpty) {
      _firstOperand = double.parse(_displayValue);
    } else {
      _secondOperand = double.parse(_displayValue);
    }
  }

  void setOperator(String newOperator) {
    if (_operator.isEmpty) {
      _operator = newOperator;
      _storedValue = _firstOperand;
      _displayValue = '';
      _isDecimalPressed = false;
    }
  }

  void calculate() {
    if (_operator.isNotEmpty) {
      switch (_operator) {
        case '+':
          _storedValue = _storedValue + _secondOperand;
          break;
        case '-':
          _storedValue = _storedValue - _secondOperand;
          break;
        case '*':
          _storedValue = _storedValue * _secondOperand;
          break;
        case '/':
          if (_secondOperand == 0) {
            _displayValue = 'Error';
          } else {
            _storedValue = _storedValue / _secondOperand;
          }
          break;
        case '%':
          _storedValue = _storedValue / 100;
          break;
      }
      _displayValue = _storedValue.toString();
      _operator = '';
      _secondOperand = 0.0;
      _isDecimalPressed = _displayValue.contains('.');
    }
  }

  void calculatePercentage() {
    if (_displayValue.isNotEmpty) {
      _storedValue = double.parse(_displayValue) / 100;
      _displayValue = _storedValue.toString();
    }
  }
}
