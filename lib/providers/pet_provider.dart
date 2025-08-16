import 'package:flutter/foundation.dart';

import 'package:zonix/services/storage_service.dart';

class Pet {
  final String id;
  String name;
  String type; // 'dog' o 'cat'
  String gender; // 'male' o 'female'
  String birthday;
  String weight;
  String breed;
  String microchip; // 'yes' o 'no'

  // Vacunación
  String lastVaccineDate;
  String nextVaccineDate;
  String vaccineType;
  String? vaccineCardImage;

  // Desparasitación
  String lastDewormingDate;
  String nextDewormingDate;
  String dewormingProduct;

  // Historial médico
  List<MedicalHistoryEntry> medicalHistory;

  // Archivos
  String petImage;
  List<ExamFile> examFiles;

  Pet({
    required this.id,
    this.name = '',
    this.type = '',
    this.gender = '',
    this.birthday = '',
    this.weight = '',
    this.breed = '',
    this.microchip = '',
    this.lastVaccineDate = '',
    this.nextVaccineDate = '',
    this.vaccineType = '',
    this.vaccineCardImage,
    this.lastDewormingDate = '',
    this.nextDewormingDate = '',
    this.dewormingProduct = '',
    this.medicalHistory = const [],
    this.petImage = 'assets/images/1.png',
    this.examFiles = const [],
  });

  Pet copyWith({
    String? id,
    String? name,
    String? type,
    String? gender,
    String? birthday,
    String? weight,
    String? breed,
    String? microchip,
    String? lastVaccineDate,
    String? nextVaccineDate,
    String? vaccineType,
    String? vaccineCardImage,
    String? lastDewormingDate,
    String? nextDewormingDate,
    String? dewormingProduct,
    List<MedicalHistoryEntry>? medicalHistory,
    String? petImage,
    List<ExamFile>? examFiles,
  }) {
    return Pet(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      weight: weight ?? this.weight,
      breed: breed ?? this.breed,
      microchip: microchip ?? this.microchip,
      lastVaccineDate: lastVaccineDate ?? this.lastVaccineDate,
      nextVaccineDate: nextVaccineDate ?? this.nextVaccineDate,
      vaccineType: vaccineType ?? this.vaccineType,
      vaccineCardImage: vaccineCardImage ?? this.vaccineCardImage,
      lastDewormingDate: lastDewormingDate ?? this.lastDewormingDate,
      nextDewormingDate: nextDewormingDate ?? this.nextDewormingDate,
      dewormingProduct: dewormingProduct ?? this.dewormingProduct,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      petImage: petImage ?? this.petImage,
      examFiles: examFiles ?? this.examFiles,
    );
  }
}

class MedicalHistoryEntry {
  final String date;
  final String text;

  MedicalHistoryEntry({
    required this.date,
    required this.text,
  });
}

class ExamFile {
  final String name;
  final String type;
  final String data; // Base64 data

  ExamFile({
    required this.name,
    required this.type,
    required this.data,
  });
}

class PetProvider extends ChangeNotifier {
  List<Pet> _pets = [];

  PetProvider() {
    _loadPets();
  }

  List<Pet> get pets => _pets;

  void addPet(Pet pet) {
    _pets.add(pet);
    notifyListeners();
    _savePets();
  }

  void removePet(String id) {
    _pets.removeWhere((pet) => pet.id == id);
    notifyListeners();
    _savePets();
  }

  void updatePet(Pet updatedPet) {
    final index = _pets.indexWhere((pet) => pet.id == updatedPet.id);
    if (index != -1) {
      _pets[index] = updatedPet;
      notifyListeners();
      _savePets();
    }
  }

  void addMedicalHistoryEntry(String petId, MedicalHistoryEntry entry) {
    final index = _pets.indexWhere((pet) => pet.id == petId);
    if (index != -1) {
      _pets[index].medicalHistory.insert(0, entry);
      notifyListeners();
      _savePets();
    }
  }

  void removeMedicalHistoryEntry(String petId, int entryIndex) {
    final index = _pets.indexWhere((pet) => pet.id == petId);
    if (index != -1 && entryIndex < _pets[index].medicalHistory.length) {
      _pets[index].medicalHistory.removeAt(entryIndex);
      notifyListeners();
      _savePets();
    }
  }

  void addExamFile(String petId, ExamFile examFile) {
    final index = _pets.indexWhere((pet) => pet.id == petId);
    if (index != -1) {
      _pets[index].examFiles.add(examFile);
      notifyListeners();
      _savePets();
    }
  }

  void removeExamFile(String petId, String fileName) {
    final index = _pets.indexWhere((pet) => pet.id == petId);
    if (index != -1) {
      _pets[index].examFiles.removeWhere((exam) => exam.name == fileName);
      notifyListeners();
      _savePets();
    }
  }

  // Cargar mascotas desde almacenamiento
  Future<void> _loadPets() async {
    _pets = await StorageService.loadPets();
    notifyListeners();
  }

  // Guardar mascotas en almacenamiento
  Future<void> _savePets() async {
    await StorageService.savePets(_pets);
  }

  // Actualizar mascota y guardar
  void updatePetAndSave(Pet updatedPet) {
    final index = _pets.indexWhere((pet) => pet.id == updatedPet.id);
    if (index != -1) {
      _pets[index] = updatedPet;
      notifyListeners();
      _savePets();
    }
  }
}
