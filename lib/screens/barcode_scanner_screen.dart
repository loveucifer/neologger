import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:neologger/constants.dart';
import 'package:neologger/providers/food_provider.dart';
import 'package:neologger/screens/food_detail_screen.dart';
import 'package:neologger/widgets/neologger_button.dart';
import 'package:provider/provider.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  bool _isScanning = false;
  String? _scannedBarcode;
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Scan Barcode',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: AppFonts.headline3,
          ),
        ),
        backgroundColor: AppColors.background,
      ),
      body: Column(
        children: [
          if (_scannedBarcode == null && !_isLoading && _errorMessage.isEmpty)
            Expanded(
              child: MobileScanner(
                onDetect: (barcodes) {
                  if (!_isScanning && barcodes.barcodes.isNotEmpty) {
                    _isScanning = true;
                    final barcode = barcodes.barcodes.first;
                    if (barcode.rawValue != null) {
                      setState(() {
                        _scannedBarcode = barcode.rawValue;
                        _isLoading = true;
                        _errorMessage = '';
                      });
                      _lookupFoodByBarcode(_scannedBarcode!);
                    } else {
                      _isScanning = false;
                    }
                  }
                },
              ),
            )
          else if (_isLoading)
            Expanded(
              child: Container(
                color: AppColors.background,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      color: AppColors.accent,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Looking up food information...',
                      style: TextStyle(
                        fontSize: AppFonts.bodyLarge,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (_errorMessage.isNotEmpty)
            Expanded(
              child: Container(
                color: AppColors.background,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error,
                      color: AppColors.accent,
                      size: 80,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Error',
                      style: TextStyle(
                        fontSize: AppFonts.headline2,
                        fontWeight: AppFonts.semiBold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      _errorMessage,
                      style: TextStyle(
                        fontSize: AppFonts.bodyMedium,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    NeologgerButton(
                      onPressed: () {
                        setState(() {
                          _scannedBarcode = null;
                          _isScanning = false;
                          _isLoading = false;
                          _errorMessage = '';
                        });
                      },
                      text: 'Scan Again',
                    ),
                  ],
                ),
              ),
            )
          else if (_scannedBarcode != null)
            Expanded(
              child: Container(
                color: AppColors.background,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: AppColors.accent,
                      size: 80,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Barcode Scanned',
                      style: TextStyle(
                        fontSize: AppFonts.headline2,
                        fontWeight: AppFonts.semiBold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      _scannedBarcode!,
                      style: TextStyle(
                        fontSize: AppFonts.bodyLarge,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Looking up food information...',
                      style: TextStyle(
                        fontSize: AppFonts.bodyMedium,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _lookupFoodByBarcode(String barcode) async {
    try {
      final foodProvider = Provider.of<FoodProvider>(context, listen: false);
      final food = await foodProvider.getFoodByBarcode(barcode);
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        if (food != null) {
          // Navigate to food detail screen
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FoodDetailScreen(food: food),
            ),
          );
        } else {
          setState(() {
            _errorMessage = 'Food not found in database. Please try another barcode.';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error looking up food: $e';
        });
      }
    }
  }
}