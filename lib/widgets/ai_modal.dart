import 'package:flutter/material.dart';
import '../services/ai_service.dart';
import 'dart:typed_data';

class AIModal extends StatefulWidget {
  final String title;
  final String? initialText;
  final bool showInput;
  final String inputLabel;
  final bool isTextArea;
  final Function(String) onAnalyze;
  final Uint8List? imageData;

  const AIModal({
    super.key,
    required this.title,
    this.initialText,
    this.showInput = false,
    this.inputLabel = '',
    this.isTextArea = false,
    required this.onAnalyze,
    this.imageData,
  });

  @override
  State<AIModal> createState() => _AIModalState();
}

class _AIModalState extends State<AIModal> {
  final TextEditingController _textController = TextEditingController();
  bool _isLoading = false;
  String _result = '';

  @override
  void initState() {
    super.initState();
    if (widget.initialText != null) {
      _result = widget.initialText!;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 500),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, size: 28),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Content
            Expanded(
              child: _isLoading
                  ? _buildLoadingState()
                  : _result.isNotEmpty
                      ? _buildResultState()
                      : _buildInputState(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.indigo),
          SizedBox(height: 16),
          Text(
            'Analizando... Por favor, espera.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildInputState() {
    if (!widget.showInput) {
      return const Center(
        child: Text(
          'Preparando análisis...',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Column(
      children: [
        Text(
          widget.inputLabel,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: widget.isTextArea
              ? TextField(
                  controller: _textController,
                  maxLines: null,
                  expands: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: 'Escribe aquí...',
                  ),
                )
              : TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: 'Escribe aquí...',
                  ),
                ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _submitAnalysis,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Enviar'),
          ),
        ),
      ],
    );
  }

  Widget _buildResultState() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Text(
              _result,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Cerrar'),
            ),
          ),
        ],
      ),
    );
  }

  void _submitAnalysis() async {
    if (widget.showInput && _textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa algún texto')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final input = widget.showInput ? _textController.text.trim() : '';
      final result = await widget.onAnalyze(input);

      setState(() {
        _result = result;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _result = 'Error: $error';
        _isLoading = false;
      });
    }
  }
}
