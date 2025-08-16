import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:zonix/providers/pet_provider.dart';
import 'package:zonix/screens/view_pet_screen.dart';
import 'package:zonix/services/ai_service.dart';
import 'package:zonix/widgets/ai_modal.dart';

class EditPetScreen extends StatefulWidget {
  final Pet pet;

  const EditPetScreen({super.key, required this.pet});

  @override
  State<EditPetScreen> createState() => _EditPetScreenState();
}

class _EditPetScreenState extends State<EditPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _weightController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _lastVaccineDateController = TextEditingController();
  final _nextVaccineDateController = TextEditingController();
  final _vaccineTypeController = TextEditingController();
  final _lastDewormingDateController = TextEditingController();
  final _nextDewormingDateController = TextEditingController();
  final _dewormingProductController = TextEditingController();
  final _medicalHistoryController = TextEditingController();

  String _selectedType = '';
  String _selectedGender = '';
  String _selectedMicrochip = '';
  String _petImage = '';
  String? _vaccineCardImage;
  List<ExamFile> _examFiles = [];

  @override
  void initState() {
    super.initState();
    _loadPetData();
  }

  void _loadPetData() {
    final pet = widget.pet;
    _nameController.text = pet.name;
    _breedController.text = pet.breed;
    _weightController.text = pet.weight;
    _birthdayController.text = pet.birthday;
    _lastVaccineDateController.text = pet.lastVaccineDate;
    _nextVaccineDateController.text = pet.nextVaccineDate;
    _vaccineTypeController.text = pet.vaccineType;
    _lastDewormingDateController.text = pet.lastDewormingDate;
    _nextDewormingDateController.text = pet.nextDewormingDate;
    _dewormingProductController.text = pet.dewormingProduct;

    _selectedType = pet.type;
    _selectedGender = pet.gender;
    _selectedMicrochip = pet.microchip;
    _petImage = pet.petImage;
    _vaccineCardImage = pet.vaccineCardImage;
    _examFiles = List.from(pet.examFiles);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _weightController.dispose();
    _birthdayController.dispose();
    _lastVaccineDateController.dispose();
    _nextVaccineDateController.dispose();
    _vaccineTypeController.dispose();
    _lastDewormingDateController.dispose();
    _nextDewormingDateController.dispose();
    _dewormingProductController.dispose();
    _medicalHistoryController.dispose();
    super.dispose();
  }

  void _savePet() {
    if (!_formKey.currentState!.validate()) return;
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El nombre de la mascota no puede estar vacío.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final petProvider = Provider.of<PetProvider>(context, listen: false);
    final updatedPet = widget.pet.copyWith(
      name: _nameController.text.trim(),
      type: _selectedType,
      gender: _selectedGender,
      birthday: _birthdayController.text,
      weight: _weightController.text,
      breed: _breedController.text,
      microchip: _selectedMicrochip,
      lastVaccineDate: _lastVaccineDateController.text,
      nextVaccineDate: _nextVaccineDateController.text,
      vaccineType: _vaccineTypeController.text,
      vaccineCardImage: _vaccineCardImage,
      examFiles: _examFiles,
      lastDewormingDate: _lastDewormingDateController.text,
      nextDewormingDate: _nextDewormingDateController.text,
      dewormingProduct: _dewormingProductController.text,
      petImage: _petImage,
    );

    petProvider.updatePet(updatedPet);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mascota guardada exitosamente'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ViewPetScreen(pet: updatedPet),
      ),
    );
  }

  void _addMedicalHistoryEntry() {
    final text = _medicalHistoryController.text.trim();
    if (text.isEmpty) return;

    final petProvider = Provider.of<PetProvider>(context, listen: false);
    final entry = MedicalHistoryEntry(
      date: DateTime.now().toString().substring(0, 19),
      text: text,
    );

    petProvider.addMedicalHistoryEntry(widget.pet.id, entry);
    _medicalHistoryController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Entrada agregada al historial'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _pickPetImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _petImage = 'data:image/png;base64,${base64Encode(bytes)}';
      });
    }
  }

  Future<void> _pickVaccineCard() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _vaccineCardImage = 'data:image/png;base64,${base64Encode(bytes)}';
      });
    }
  }

  Future<void> _pickExamFiles() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      allowMultiple: true,
    );

    if (result != null) {
      final files = List<PlatformFile>.from(result.files);
      for (final file in files) {
        if (file.path != null) {
          final bytes = await File(file.path!).readAsBytes();
          final examFile = ExamFile(
            name: file.name,
            type: file.extension ?? 'unknown',
            data: 'data:${file.extension};base64,${base64Encode(bytes)}',
          );
          setState(() {
            _examFiles.add(examFile);
          });
        }
      }
    }
  }

  void _removeExamFile(String fileName) {
    setState(() {
      _examFiles.removeWhere((exam) => exam.name == fileName);
    });
  }

  bool _isImageFile(String fileType) {
    final imageExtensions = <String>[
      'jpg',
      'jpeg',
      'png',
      'gif',
      'bmp',
      'webp'
    ];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Editar Mascota',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.indigo,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF3F4F6), Color(0xFFE5E7EB)],
          ),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Pet Image and Name Section
                _buildImageAndNameSection(),

                const SizedBox(height: 24),

                // Basic Information Section
                _buildBasicInformationSection(),

                const SizedBox(height: 24),

                // Health Sections
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildVaccinationSection()),
                    const SizedBox(width: 16),
                    Expanded(child: _buildDewormingSection()),
                  ],
                ),

                const SizedBox(height: 24),

                // Medical History Section
                _buildMedicalHistorySection(),

                const SizedBox(height: 24),

                // Exams Section
                _buildExamsSection(),

                const SizedBox(height: 32),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _savePet,
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text(
                      'Guardar y Ver Ficha',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageAndNameSection() {
    return Container(
      padding: const EdgeInsets.all(24),
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
          // Pet Image
          GestureDetector(
            onTap: _pickPetImage,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.amber, width: 4),
                image: DecorationImage(
                  image: _petImage.startsWith('data:')
                      ? MemoryImage(base64Decode(_petImage.split(',')[1]))
                      : AssetImage(_petImage) as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withValues(alpha: 0.4),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Pet Name
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nombre de tu mascota',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.pets),
            ),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
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
            color: Colors.black.withValues(alpha: 0.1),
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
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),

          // Type Selection
          Text('Tipo',
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.grey[700])),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildSelectionButton(
                  'Perro',
                  Icons.pets,
                  _selectedType == 'dog',
                  () => setState(() => _selectedType = 'dog'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSelectionButton(
                  'Gato',
                  Icons.pets,
                  _selectedType == 'cat',
                  () => setState(() => _selectedType = 'cat'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Gender Selection
          Text('Sexo',
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.grey[700])),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildSelectionButton(
                  'Macho',
                  Icons.male,
                  _selectedGender == 'male',
                  () => setState(() => _selectedGender = 'male'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSelectionButton(
                  'Hembra',
                  Icons.female,
                  _selectedGender == 'female',
                  () => setState(() => _selectedGender = 'female'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Other fields
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _birthdayController,
                  decoration: const InputDecoration(
                    labelText: 'Nacimiento',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.cake),
                  ),
                  readOnly: true,
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      _birthdayController.text =
                          date.toIso8601String().split('T')[0];
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _weightController,
                  decoration: const InputDecoration(
                    labelText: 'Peso (kg)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.monitor_weight),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: _breedController,
            decoration: const InputDecoration(
              labelText: 'Raza',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.pets),
            ),
          ),

          const SizedBox(height: 16),

          Text('¿Tiene Microchip?',
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.grey[700])),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildSelectionButton(
                  'Sí',
                  Icons.check,
                  _selectedMicrochip == 'yes',
                  () => setState(() => _selectedMicrochip = 'yes'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSelectionButton(
                  'No',
                  Icons.close,
                  _selectedMicrochip == 'no',
                  () => setState(() => _selectedMicrochip = 'no'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVaccinationSection() {
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.vaccines, color: Colors.green[600]),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Vacunación',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _lastVaccineDateController,
            decoration: const InputDecoration(
              labelText: 'Fecha de última vacuna',
              border: OutlineInputBorder(),
            ),
            readOnly: true,
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (date != null) {
                _lastVaccineDateController.text =
                    date.toIso8601String().split('T')[0];
                // Calculate next vaccine date (1 year later)
                final nextDate = DateTime(date.year + 1, date.month, date.day);
                _nextVaccineDateController.text =
                    nextDate.toIso8601String().split('T')[0];
              }
            },
          ),

          const SizedBox(height: 12),

          TextFormField(
            controller: _nextVaccineDateController,
            decoration: InputDecoration(
              labelText: 'Próxima vacuna',
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            readOnly: true,
          ),

          const SizedBox(height: 12),

          TextFormField(
            controller: _vaccineTypeController,
            decoration: const InputDecoration(
              labelText: 'Tipo de vacuna',
              border: OutlineInputBorder(),
              hintText: 'Ej. Rabia, Triple felina',
            ),
          ),

          const SizedBox(height: 12),

          // Vaccine card upload
          GestureDetector(
            onTap: _pickVaccineCard,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.grey[300]!, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[50],
              ),
              child: _vaccineCardImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        base64Decode(_vaccineCardImage!.split(',')[1]),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.file_upload,
                            color: Colors.grey[400], size: 32),
                        const SizedBox(height: 4),
                        Text(
                          'Subir carnet',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDewormingSection() {
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bug_report, color: Colors.orange[600]),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Desparasitación',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _lastDewormingDateController,
            decoration: const InputDecoration(
              labelText: 'Última desparasitación',
              border: OutlineInputBorder(),
            ),
            readOnly: true,
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (date != null) {
                _lastDewormingDateController.text =
                    date.toIso8601String().split('T')[0];
                // Calculate next deworming date (6 months later)
                final nextDate = DateTime(date.year, date.month + 6, date.day);
                _nextDewormingDateController.text =
                    nextDate.toIso8601String().split('T')[0];
              }
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _nextDewormingDateController,
            decoration: InputDecoration(
              labelText: 'Próxima (en 6 meses)',
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            readOnly: true,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _dewormingProductController,
            decoration: const InputDecoration(
              labelText: 'Producto utilizado',
              border: OutlineInputBorder(),
              hintText: 'Nombre del desparasitante',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalHistorySection() {
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.medical_services, color: Colors.red[600]),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Historial Médico',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _medicalHistoryController,
            decoration: const InputDecoration(
              labelText: 'Añadir nueva entrada',
              border: OutlineInputBorder(),
              hintText: 'Escribe aquí la entrada del historial...',
            ),
            maxLines: 3,
          ),

          const SizedBox(height: 8),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _addMedicalHistoryEntry,
              icon: const Icon(Icons.add, color: Colors.white),
              label:
                  const Text('Añadir', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo[600],
                foregroundColor: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Recuerda pulsar "Añadir" para guardar cada entrada en el historial.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Medical history entries
          Consumer<PetProvider>(
            builder: (context, petProvider, child) {
              final pet =
                  petProvider.pets.firstWhere((p) => p.id == widget.pet.id);
              if (pet.medicalHistory.isEmpty) {
                return const SizedBox.shrink();
              }

              return Column(
                children: pet.medicalHistory.asMap().entries.map((entry) {
                  final index = entry.key;
                  final historyEntry = entry.value;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: const Border(
                        left: BorderSide(color: Colors.indigo, width: 4),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                historyEntry.date,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(historyEntry.text),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            petProvider.removeMedicalHistoryEntry(
                                widget.pet.id, index);
                          },
                          icon: const Icon(Icons.delete, color: Colors.red),
                          iconSize: 20,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildExamsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.file_copy, color: Colors.blue[600]),
              const SizedBox(width: 8),
              Text(
                'Exámenes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          GestureDetector(
            onTap: _pickExamFiles,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.grey[300]!, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[50],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.file_upload, color: Colors.grey[400], size: 32),
                  const SizedBox(height: 4),
                  Text(
                    'Subir resultados',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Exam files preview
          if (_examFiles.isNotEmpty)
            Column(
              children: _examFiles.map((exam) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        exam.type.toLowerCase() == 'pdf'
                            ? Icons.picture_as_pdf
                            : Icons.image,
                        color: exam.type.toLowerCase() == 'pdf'
                            ? Colors.red
                            : Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          exam.name,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      if (_isImageFile(exam.type))
                        IconButton(
                          onPressed: () => _analyzeExam(context, exam),
                          icon: const Icon(Icons.auto_awesome,
                              color: Colors.purple),
                          iconSize: 20,
                        ),
                      IconButton(
                        onPressed: () => _removeExamFile(exam.name),
                        icon: const Icon(Icons.delete, color: Colors.red),
                        iconSize: 20,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildSelectionButton(
      String text, IconData icon, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.indigo : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[800],
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[800],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
