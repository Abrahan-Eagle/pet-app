import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pet_provider.dart';
import '../services/ai_service.dart';
import '../widgets/ai_modal.dart';
import 'edit_pet_screen.dart';
import 'dart:typed_data';
import 'dart:convert';

class ViewPetScreen extends StatelessWidget {
  final Pet pet;

  const ViewPetScreen({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ficha de Mascota',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.indigo,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF3F4F6), Color(0xFFE5E7EB)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header with pet image and name
              _buildHeader(),

              const SizedBox(height: 24),

              // Basic Information Section
              _buildBasicInformationSection(),

              const SizedBox(height: 24),

              // Health and Prevention Section
              _buildHealthSection(),

              const SizedBox(height: 24),

              // Medical History Section
              _buildMedicalHistorySection(),

              const SizedBox(height: 24),

              // Exams Section
              _buildExamsSection(),

              const SizedBox(height: 32),

              // Action Buttons
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pet.name.isNotEmpty ? pet.name : 'Sin Nombre',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  pet.breed.isNotEmpty ? pet.breed : 'Raza no especificada',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.indigo[300]!, width: 4),
            ),
            child: ClipOval(
              child: pet.petImage.startsWith('data:')
                  ? Image.memory(
                      base64Decode(pet.petImage.split(',')[1]),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[100],
                          child: Icon(Icons.pets,
                              size: 60, color: Colors.grey[400]),
                        );
                      },
                    )
                  : Image.asset(
                      pet.petImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[100],
                          child: Icon(Icons.pets,
                              size: 60, color: Colors.grey[400]),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInformationSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Información Básica',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.indigo[700],
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Tipo:', _getTypeText(pet.type)),
          _buildInfoRow('Sexo:', _getGenderText(pet.gender)),
          _buildInfoRow(
              'Nacimiento:', pet.birthday.isNotEmpty ? pet.birthday : 'N/A'),
          _buildInfoRow(
              'Peso:', pet.weight.isNotEmpty ? '${pet.weight} kg' : 'N/A'),
          _buildInfoRow('Microchip:', _getMicrochipText(pet.microchip)),
        ],
      ),
    );
  }

  Widget _buildHealthSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Salud y Prevención',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.indigo[700],
            ),
          ),
          const SizedBox(height: 16),
          // Vacunación
          _buildVaccinationInfo(),
          const SizedBox(height: 24),
          // Desparasitación
          _buildDewormingInfo(),
        ],
      ),
    );
  }

  Widget _buildVaccinationInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.vaccines, color: Colors.green[600], size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Vacunación',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo[700],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildInfoRow('Última:',
            pet.lastVaccineDate.isNotEmpty ? pet.lastVaccineDate : 'N/A'),
        _buildInfoRow('Próxima:',
            pet.nextVaccineDate.isNotEmpty ? pet.nextVaccineDate : 'N/A'),
        _buildInfoRow(
            'Tipo:', pet.vaccineType.isNotEmpty ? pet.vaccineType : 'N/A'),
        if (pet.vaccineCardImage != null) ...[
          const SizedBox(height: 12),
          Text(
            'Carnet:',
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]),
          ),
          const SizedBox(height: 8),
          Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: pet.vaccineCardImage!.startsWith('data:')
                  ? Image.memory(
                      base64Decode(pet.vaccineCardImage!.split(',')[1]),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[100],
                          child: const Icon(Icons.image, color: Colors.grey),
                        );
                      },
                    )
                  : Image.network(
                      pet.vaccineCardImage!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[100],
                          child: const Icon(Icons.image, color: Colors.grey),
                        );
                      },
                    ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDewormingInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.bug_report, color: Colors.orange[600], size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Desparasitación',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo[700],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildInfoRow('Última:',
            pet.lastDewormingDate.isNotEmpty ? pet.lastDewormingDate : 'N/A'),
        _buildInfoRow('Próxima:',
            pet.nextDewormingDate.isNotEmpty ? pet.nextDewormingDate : 'N/A'),
        _buildInfoRow('Producto:',
            pet.dewormingProduct.isNotEmpty ? pet.dewormingProduct : 'N/A'),
      ],
    );
  }

  Widget _buildMedicalHistorySection() {
    return Consumer<PetProvider>(
      builder: (context, petProvider, child) {
        final currentPet = petProvider.pets.firstWhere((p) => p.id == pet.id);

        if (currentPet.medicalHistory.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(minHeight: 200),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Historial Médico',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo[700],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: currentPet.medicalHistory
                        .map((entry) => Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border(
                                  left: BorderSide(
                                      color: Colors.indigo, width: 4),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    entry.date,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(entry.text),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExamsSection() {
    return Consumer<PetProvider>(
      builder: (context, petProvider, child) {
        final currentPet = petProvider.pets.firstWhere((p) => p.id == pet.id);

        if (currentPet.examFiles.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Exámenes Médicos',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo[700],
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: currentPet.examFiles.length,
                itemBuilder: (context, index) {
                  final exam = currentPet.examFiles[index];
                  final isPdf = exam.type.toLowerCase() == 'pdf';

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!isPdf && exam.data.startsWith('data:')) ...[
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              margin: const EdgeInsets.all(8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.memory(
                                  base64Decode(exam.data.split(',')[1]),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.image,
                                      color: Colors.grey[400],
                                      size: 32,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ] else ...[
                          Icon(
                            isPdf ? Icons.picture_as_pdf : Icons.image,
                            color: isPdf ? Colors.red : Colors.blue,
                            size: 32,
                          ),
                        ],
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            exam.name,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (_isImageFile(exam.type)) ...[
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => _analyzeExam(context, exam),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo[600],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              minimumSize: const Size(0, 24),
                            ),
                            child: const Text(
                              'Analizar',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildActionButton(
                'Analizar Historial',
                Icons.auto_awesome,
                () => _analyzeHistory(context),
              ),
              _buildActionButton(
                'Guía de Cuidado',
                Icons.book,
                () => _generateCareGuide(context),
              ),
              _buildActionButton(
                'Analizar Síntomas',
                Icons.medical_services,
                () => _symptomChecker(context),
              ),
              _buildActionButton(
                '¿Puede comer esto?',
                Icons.restaurant,
                () => _foodChecker(context),
              ),
              _buildActionButton(
                'Editar Ficha',
                Icons.edit,
                () => _editPet(context),
                isSecondary: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, IconData icon, VoidCallback onPressed,
      {bool isSecondary = false}) {
    return Container(
      decoration: BoxDecoration(
        gradient: isSecondary
            ? const LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF818CF8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: 16),
        label: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  String _getTypeText(String type) {
    switch (type) {
      case 'dog':
        return 'Perro';
      case 'cat':
        return 'Gato';
      default:
        return 'N/A';
    }
  }

  String _getGenderText(String gender) {
    switch (gender) {
      case 'male':
        return 'Macho';
      case 'female':
        return 'Hembra';
      default:
        return 'N/A';
    }
  }

  String _getMicrochipText(String microchip) {
    switch (microchip) {
      case 'yes':
        return 'Sí';
      case 'no':
        return 'No';
      default:
        return 'N/A';
    }
  }

  void _analyzeHistory(BuildContext context) {
    if (pet.medicalHistory.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay historial médico para analizar')),
      );
      return;
    }

    final historyData = pet.medicalHistory
        .map((e) => {
              'date': e.date,
              'text': e.text,
            })
        .toList();

    showDialog(
      context: context,
      builder: (context) => AIModal(
        title: 'Análisis del Historial Médico',
        onAnalyze: (input) async {
          return await AIService.analyzeMedicalHistory(historyData);
        },
      ),
    );
  }

  void _generateCareGuide(BuildContext context) {
    final age = _calculateAge(pet.birthday);

    showDialog(
      context: context,
      builder: (context) => AIModal(
        title: 'Guía de Cuidado Personalizada',
        onAnalyze: (input) async {
          return await AIService.generateCareGuide(
            name: pet.name.isNotEmpty ? pet.name : 'Sin Nombre',
            type: _getTypeText(pet.type),
            breed: pet.breed.isNotEmpty ? pet.breed : 'Raza no especificada',
            age: age,
            weight: pet.weight.isNotEmpty ? pet.weight : 'no especificado',
          );
        },
      ),
    );
  }

  void _symptomChecker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AIModal(
        title: 'Analizador de Síntomas',
        showInput: true,
        inputLabel: 'Describe los síntomas de tu mascota:',
        isTextArea: true,
        onAnalyze: (symptoms) async {
          final age = _calculateAge(pet.birthday);
          return await AIService.analyzeSymptoms(
            symptoms: symptoms,
            name: pet.name.isNotEmpty ? pet.name : 'Sin Nombre',
            type: _getTypeText(pet.type),
            breed: pet.breed.isNotEmpty ? pet.breed : 'Raza no especificada',
            age: age,
            weight: pet.weight.isNotEmpty ? pet.weight : 'no especificado',
          );
        },
      ),
    );
  }

  void _foodChecker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AIModal(
        title: 'Verificador de Alimentos',
        showInput: true,
        inputLabel: 'Ingresa un alimento o ingrediente:',
        isTextArea: false,
        onAnalyze: (food) async {
          return await AIService.checkFood(
            food: food,
            type: _getTypeText(pet.type),
          );
        },
      ),
    );
  }

  bool _isImageFile(String fileType) {
    final imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
    return imageExtensions.contains(fileType.toLowerCase());
  }

  void _analyzeExam(BuildContext context, ExamFile exam) {
    if (!_isImageFile(exam.type)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Solo se pueden analizar archivos de imagen (JPG, PNG, etc.)')),
      );
      return;
    }

    try {
      final imageData = base64Decode(exam.data.split(',')[1]);

      showDialog(
        context: context,
        builder: (context) => AIModal(
          title: 'Análisis de Examen: ${exam.name}',
          onAnalyze: (input) async {
            return await AIService.analyzeExam(
              examName: exam.name,
              imageData: imageData,
            );
          },
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al procesar la imagen: $error')),
      );
    }
  }

  String _calculateAge(String birthday) {
    if (birthday.isEmpty) return 'no especificada';

    try {
      final birthDate = DateTime.parse(birthday);
      final now = DateTime.now();
      final age = now.year - birthDate.year;
      return '$age años';
    } catch (error) {
      return 'no especificada';
    }
  }

  void _editPet(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPetScreen(pet: pet),
      ),
    );
  }
}
