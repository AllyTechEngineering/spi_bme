import 'package:flutter/material.dart';
import 'package:spi_bme/utilities/bme280_spi.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _chipId = 'Unknown';

  @override
  void initState() {
    super.initState();
    _getBme280Id();
  }

  void _getBme280Id() async {
    try {
      final bme280Spi = Bme280Spi();
      final chipId = bme280Spi.getBme280Id('/dev/spidev0.0');
      setState(() {
        _chipId = chipId.toString();
      });
    } catch (e) {
      setState(() {
        _chipId = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SPI BME280 Demo'),
      ),
      body: Center(
        child: Text('BME280 Chip ID: $_chipId'),
      ),
    );
  }
}