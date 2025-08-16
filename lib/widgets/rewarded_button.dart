import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:zonix/services/ad_service.dart';

class RewardedButton extends StatefulWidget {
  const RewardedButton({super.key});

  @override
  State<RewardedButton> createState() => _RewardedButtonState();
}

class _RewardedButtonState extends State<RewardedButton> {
  bool _showSuccess = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: _showSuccess ? '¡Gracias!' : 'Apoya viendo un anuncio',
      onPressed: () async {
        final messenger = ScaffoldMessenger.of(context);
        final ok = await AdService.showRewardedIfAvailable(
          onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
            setState(() => _showSuccess = true);
            Future.delayed(const Duration(seconds: 3), () {
              if (mounted) setState(() => _showSuccess = false);
            });
          },
        );
        if (!ok) {
          messenger.showSnackBar(
            const SnackBar(content: Text('Anuncio no disponible por ahora')),
          );
        }
      },
      icon: Icon(_showSuccess ? Icons.favorite : Icons.volunteer_activism,
          color: _showSuccess ? Colors.pink : Colors.indigo),
    );
  }
}
