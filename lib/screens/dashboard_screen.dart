import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:zonix/providers/pet_provider.dart';
import 'package:zonix/services/ad_service.dart';
import 'package:zonix/widgets/ad_banner.dart';
import 'package:zonix/widgets/rewarded_button.dart';
import 'package:zonix/screens/edit_pet_screen.dart';
import 'package:zonix/screens/view_pet_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF3F4F6), Color(0xFFE5E7EB)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.pets,
                                size: 32,
                                color: Colors.indigo[700],
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Ficha Pet',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo[700],
                                ),
                              ),
                            ],
                          ),
                          const RewardedButton(),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'El registro digital de todos tus compañeros',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                // Dashboard Content
                Expanded(
                  child: Consumer<PetProvider>(
                    builder: (context, petProvider, child) {
                      if (petProvider.pets.isEmpty) {
                        return _buildEmptyState();
                      }

                      return Column(
                        children: [
                          // Header with title and add button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Mis Mascotas',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () => _addNewPet(context),
                                icon:
                                    const Icon(Icons.add, color: Colors.white),
                                label: const Text(
                                  'Agregar Mascota',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green[600],
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 2,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Pet list
                          Expanded(
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.85,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                              itemCount: petProvider.pets.length,
                              itemBuilder: (context, index) {
                                final pet = petProvider.pets[index];
                                return _buildPetCard(context, pet, index);
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: 8, top: 4),
          child: Center(child: AdBanner()),
        ),
      ),
      floatingActionButton: Consumer<PetProvider>(
        builder: (context, petProvider, child) {
          if (petProvider.pets.isNotEmpty) return const SizedBox.shrink();

          return FloatingActionButton.extended(
            onPressed: () => _addNewPet(context),
            icon: const Icon(Icons.add),
            label: const Text('Agregar Mascota'),
            backgroundColor: Colors.green[600],
            foregroundColor: Colors.white,
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.pets,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 24),
          Text(
            'No tienes mascotas registradas',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '¡Agrega tu primera mascota para empezar!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPetCard(BuildContext context, Pet pet, int index) {
    return GestureDetector(
      onTap: () => _viewPet(context, pet),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Pet image
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  image: DecorationImage(
                    image: pet.petImage.startsWith('data:')
                        ? MemoryImage(base64Decode(pet.petImage.split(',')[1]))
                            as ImageProvider
                        : AssetImage(pet.petImage) as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    // Delete button
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => _deletePet(context, pet, index),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red[400],
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.delete,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Pet info
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      pet.name.isNotEmpty ? pet.name : 'Sin Nombre',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pet.breed.isNotEmpty ? pet.breed : 'Raza no especificada',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addNewPet(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context, listen: false);
    final newPet = Pet(id: DateTime.now().millisecondsSinceEpoch.toString());
    petProvider.addPet(newPet);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPetScreen(pet: newPet),
      ),
    );
  }

  void _viewPet(BuildContext context, Pet pet) {
    // Show interstitial ad occasionally before navigating
    AdService.showInterstitialIfAvailable();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewPetScreen(pet: pet),
      ),
    );
  }

  void _deletePet(BuildContext context, Pet pet, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text(
            '¿Estás seguro de que quieres eliminar a ${pet.name.isNotEmpty ? pet.name : 'esta mascota'}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              final petProvider =
                  Provider.of<PetProvider>(context, listen: false);
              petProvider.removePet(pet.id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
