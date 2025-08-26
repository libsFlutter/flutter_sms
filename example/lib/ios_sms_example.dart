import 'package:flutter/material.dart';
import 'package:flutter_smsussd/flutter_smsussd.dart';

class IOSSmsExample extends StatefulWidget {
  const IOSSmsExample({super.key});

  @override
  State<IOSSmsExample> createState() => _IOSSmsExampleState();
}

class _IOSSmsExampleState extends State<IOSSmsExample> {
  final FlutterSmsussd _plugin = FlutterSmsussd();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  String _status = '';

  @override
  void dispose() {
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendSms() async {
    if (_phoneController.text.isEmpty || _messageController.text.isEmpty) {
      setState(() {
        _status = 'Please enter both phone number and message';
      });
      return;
    }

    setState(() {
      _status = 'Opening SMS composer...';
    });

    try {
      final success = await _plugin.sendSms(
        phoneNumber: _phoneController.text,
        message: _messageController.text,
      );

      setState(() {
        if (success) {
          _status = 'SMS composer opened successfully!';
        } else {
          _status = 'Failed to open SMS composer';
        }
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    }
  }

  Future<void> _checkPermissions() async {
    try {
      final hasPermissions = await _plugin.hasSmsPermissions();
      setState(() {
        _status = hasPermissions 
            ? 'SMS functionality is available' 
            : 'SMS functionality is not available';
      });
    } catch (e) {
      setState(() {
        _status = 'Error checking permissions: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('iOS SMS Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'iOS SMS Limitations',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('• Cannot read SMS messages'),
                    Text('• Cannot send SMS programmatically'),
                    Text('• Can only open native SMS composer'),
                    Text('• No special permissions required'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                hintText: '+1234567890',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Message',
                hintText: 'Enter your message here...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _checkPermissions,
              child: const Text('Check SMS Availability'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _sendSms,
              child: const Text('Open SMS Composer'),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Status:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(_status.isEmpty ? 'Ready' : _status),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
