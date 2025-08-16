import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:zonix/providers/pet_provider.dart';

class StorageService {
  static const String _petsKey = 'allPetsData';
  static const String _onboardingKey = 'onboardingComplete';

  // Guardar todas las mascotas
  static Future<void> savePets(List<Pet> pets) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final petsJson = pets.map((pet) => _petToJson(pet)).toList();
      await prefs.setString(_petsKey, jsonEncode(petsJson));
    } catch (error) {
      // Error al guardar mascotas: $error
    }
  }

  // Cargar todas las mascotas
  static Future<List<Pet>> loadPets() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final petsString = prefs.getString(_petsKey);

      if (petsString != null) {
        final petsJson = jsonDecode(petsString) as List;
        return petsJson.map((json) => _petFromJson(json)).toList();
      }
    } catch (error) {
      // Error al cargar mascotas: $error
    }

    return [];
  }

  // Marcar onboarding como completado
  static Future<void> setOnboardingComplete() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingKey, true);
    } catch (error) {
      // Error al guardar estado de onboarding: $error
    }
  }

  // Verificar si el onboarding está completado
  static Future<bool> isOnboardingComplete() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_onboardingKey) ?? false;
    } catch (error) {
      // Error al verificar onboarding: $error
      return false;
    }
  }

  // Convertir Pet a JSON
  static Map<String, dynamic> _petToJson(Pet pet) {
    return {
      'id': pet.id,
      'name': pet.name,
      'type': pet.type,
      'gender': pet.gender,
      'birthday': pet.birthday,
      'weight': pet.weight,
      'breed': pet.breed,
      'microchip': pet.microchip,
      'lastVaccineDate': pet.lastVaccineDate,
      'nextVaccineDate': pet.nextVaccineDate,
      'vaccineType': pet.vaccineType,
      'vaccineCardImage': pet.vaccineCardImage,
      'lastDewormingDate': pet.lastDewormingDate,
      'nextDewormingDate': pet.nextDewormingDate,
      'dewormingProduct': pet.dewormingProduct,
      'medicalHistory': pet.medicalHistory
          .map((entry) => {
                'date': entry.date,
                'text': entry.text,
              })
          .toList(),
      'petImage': pet.petImage,
      'examFiles': pet.examFiles
          .map((exam) => {
                'name': exam.name,
                'type': exam.type,
                'data': exam.data,
              })
          .toList(),
    };
  }

  // Convertir JSON a Pet
  static Pet _petFromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      gender: json['gender'] ?? '',
      birthday: json['birthday'] ?? '',
      weight: json['weight'] ?? '',
      breed: json['breed'] ?? '',
      microchip: json['microchip'] ?? '',
      lastVaccineDate: json['lastVaccineDate'] ?? '',
      nextVaccineDate: json['nextVaccineDate'] ?? '',
      vaccineType: json['vaccineType'] ?? '',
      vaccineCardImage: json['vaccineCardImage'],
      lastDewormingDate: json['lastDewormingDate'] ?? '',
      nextDewormingDate: json['nextDewormingDate'] ?? '',
      dewormingProduct: json['dewormingProduct'] ?? '',
      medicalHistory: (json['medicalHistory'] as List?)
              ?.map((entry) => MedicalHistoryEntry(
                    date: entry['date'] ?? '',
                    text: entry['text'] ?? '',
                  ))
              .toList() ??
          [],
      petImage: json['petImage'] ?? 'assets/images/1.png',
      examFiles: (json['examFiles'] as List?)
              ?.map((exam) => ExamFile(
                    name: exam['name'] ?? '',
                    type: exam['type'] ?? '',
                    data: exam['data'] ?? '',
                  ))
              .toList() ??
          [],
    );
  }
}
