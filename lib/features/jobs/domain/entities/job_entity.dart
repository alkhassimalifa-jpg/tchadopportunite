import 'package:equatable/equatable.dart';

class JobEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String companyName;
  final String? companyLogo;
  final String location;
  final String? salary;
  final String type; // CDI, CDD, Freelance, Stage
  final String category;
  final String status; // OPEN, CLOSED
  final bool isSponsored;
  final int applicationsCount;
  final String authorId;
  final DateTime createdAt;
  final DateTime? expiresAt;

  const JobEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.companyName,
    this.companyLogo,
    required this.location,
    this.salary,
    required this.type,
    required this.category,
    required this.status,
    this.isSponsored = false,
    this.applicationsCount = 0,
    required this.authorId,
    required this.createdAt,
    this.expiresAt,
  });

  factory JobEntity.fromJson(Map<String, dynamic> json) {
    return JobEntity(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      companyName: json['companyName'] ?? '',
      companyLogo: json['companyLogo'],
      location: json['location'] ?? '',
      salary: json['salary'],
      type: json['type'] ?? 'CDI',
      category: json['category'] ?? '',
      status: json['status'] ?? 'OPEN',
      isSponsored: json['isSponsored'] ?? false,
      applicationsCount: json['applicationsCount'] ?? 0,
      authorId: json['authorId'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'])
          : null,
    );
  }

  @override
  List<Object?> get props => [id, title, companyName, location, type, status];
}

// ─── Sample Data ──────────────────────────────────────────────

final sampleJobs = [
  JobEntity(
    id: '1',
    title: 'Développeur Flutter',
    description: 'Nous recherchons un développeur Flutter expérimenté pour rejoindre notre équipe. Vous serez responsable du développement d\'applications mobiles modernes pour nos clients.\n\nResponsabilités :\n• Développer des applications Flutter pour Android et iOS\n• Collaborer avec l\'équipe backend\n• Participer aux revues de code\n\nExigences :\n• 2+ ans d\'expérience Flutter\n• Maîtrise de Dart\n• Connaissance de Firebase',
    companyName: 'TechChad SARL',
    location: 'N\'Djamena',
    salary: '300 000 FCFA',
    type: 'CDI',
    category: 'Informatique',
    status: 'OPEN',
    isSponsored: true,
    applicationsCount: 12,
    authorId: 'company1',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
  JobEntity(
    id: '2',
    title: 'Comptable Senior',
    description: 'La Banque Sahel recherche un comptable senior pour gérer les opérations financières.\n\nResponsabilités :\n• Gestion de la comptabilité générale\n• Préparation des bilans\n• Audit interne\n\nExigences :\n• Diplôme en comptabilité\n• 5+ ans d\'expérience\n• Maîtrise des logiciels comptables',
    companyName: 'Banque Sahel',
    location: 'N\'Djamena',
    salary: '250 000 FCFA',
    type: 'CDI',
    category: 'Finance',
    status: 'OPEN',
    applicationsCount: 8,
    authorId: 'company2',
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
  ),
  JobEntity(
    id: '3',
    title: 'Électricien',
    description: 'Particulier recherche électricien qualifié pour travaux de rénovation.\n\nTravaux à effectuer :\n• Installation électrique complète\n• Mise aux normes\n• Dépannage\n\nExigences :\n• CAP électricité\n• Expérience en rénovation\n• Disponible immédiatement',
    companyName: 'Particulier',
    location: 'Moundou',
    salary: '15 000 FCFA/j',
    type: 'Freelance',
    category: 'Artisanat',
    status: 'OPEN',
    applicationsCount: 3,
    authorId: 'user1',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
  JobEntity(
    id: '4',
    title: 'Enseignant de Mathématiques',
    description: 'École privée recherche enseignant de mathématiques pour classes de lycée.\n\nResponsabilités :\n• Enseigner les mathématiques niveau terminale\n• Préparer les cours\n• Suivre les élèves\n\nExigences :\n• Licence en mathématiques\n• Expérience en enseignement\n• Pédagogie',
    companyName: 'Lycée Excellence',
    location: 'N\'Djamena',
    salary: '180 000 FCFA',
    type: 'CDI',
    category: 'Éducation',
    status: 'OPEN',
    applicationsCount: 15,
    authorId: 'company3',
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
  ),
  JobEntity(
    id: '5',
    title: 'Chauffeur Livreur',
    description: 'Société de livraison recherche chauffeur livreur motivé.\n\nResponsabilités :\n• Livraisons quotidiennes\n• Gestion des colis\n• Relation client\n\nExigences :\n• Permis B valide\n• Connaissance de N\'Djamena\n• Ponctuel et sérieux',
    companyName: 'FastDelivery Chad',
    location: 'N\'Djamena',
    salary: '120 000 FCFA',
    type: 'CDD',
    category: 'Transport',
    status: 'OPEN',
    applicationsCount: 20,
    authorId: 'company4',
    createdAt: DateTime.now().subtract(const Duration(days: 7)),
  ),
  JobEntity(
    id: '6',
    title: 'Infirmier(e)',
    description: 'Clinique moderne recherche infirmier(e) diplômé(e).\n\nResponsabilités :\n• Soins aux patients\n• Gestion des dossiers médicaux\n• Collaboration avec les médecins\n\nExigences :\n• Diplôme d\'État infirmier\n• 2+ ans d\'expérience\n• Empathie et rigueur',
    companyName: 'Clinique Al-Wafaa',
    location: 'N\'Djamena',
    salary: '200 000 FCFA',
    type: 'CDI',
    category: 'Santé',
    status: 'OPEN',
    applicationsCount: 6,
    authorId: 'company5',
    createdAt: DateTime.now().subtract(const Duration(days: 4)),
  ),
];
