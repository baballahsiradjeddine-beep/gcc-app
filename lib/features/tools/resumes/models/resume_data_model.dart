import 'package:equatable/equatable.dart';
import 'package:tayssir/features/tools/resumes/models/resume_material_model.dart';
import 'package:tayssir/features/tools/resumes/models/resume_unit_model.dart';

class ResumeDataModel extends Equatable {
  final List<ResumeMaterialModel> materials;
  final List<ResumeUnitModel> units;

  const ResumeDataModel({
    required this.materials,
    required this.units,
  });

  factory ResumeDataModel.fromJson(Map<String, dynamic> json) {
    return ResumeDataModel(
      materials: (json['materials'] as List<dynamic>?)
              ?.map((e) =>
                  ResumeMaterialModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      units: (json['units'] as List<dynamic>?)
              ?.map((e) => ResumeUnitModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'materials': materials.map((e) => e.toJson()).toList(),
      'units': units.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [materials, units];
}

// // Mock data provider for ResumeDataModel
// final resumeDataProvider = Provider<ResumeDataModel>((ref) {
//   return const ResumeDataModel(
//     materials: [
//       ResumeMaterialModel(
//         id: 3,
//         name: "التاريخ",
//         colors: [Color(0xFFEC407A), Color(0xFFC62828)],
//       ),
//       ResumeMaterialModel(
//         id: 4,
//         name: "الجغرافيا",
//         colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
//       ),
//       ResumeMaterialModel(
//         id: 5,
//         name: "اللغة الإنجليزية",
//         colors: [Color(0xFFFF9800), Color(0xFFE65100)],
//       ),
//       ResumeMaterialModel(
//         id: 6,
//         name: "الشريعة الإسلامية",
//         colors: [Color(0xFF9C27B0), Color(0xFF6A1B9A)],
//       ),
//     ],
//     units: [
//       // التاريخ
//       ResumeUnitModel(
//         id: 1,
//         name: "مصطلحات تاريخ الوحدة 1",
//         materialId: 3,
//         pdf: "https://arxiv.org/pdf/2403.13382", // Placeholder PDF
//       ),
//       ResumeUnitModel(
//         id: 2,
//         name: "شخصيات تاريخ الوحدة 1",
//         materialId: 3,
//         pdf: "https://arxiv.org/pdf/2403.13382",
//       ),
//       ResumeUnitModel(
//         id: 3,
//         name: "أحداث تاريخ الوحدة 1",
//         materialId: 3,
//         pdf: "https://arxiv.org/pdf/2403.13382",
//       ),
//       ResumeUnitModel(
//         id: 4,
//         name: "مصطلحات تاريخ الوحدة 2",
//         materialId: 3,
//         pdf: "https://arxiv.org/pdf/2403.13382",
//       ),
//       // الجغرافيا
//       ResumeUnitModel(
//         id: 7,
//         name: "مصطلحات جغرافيا الوحدة 1",
//         materialId: 4,
//         pdf: "https://arxiv.org/pdf/2403.13382",
//       ),
//       ResumeUnitModel(
//         id: 8,
//         name: "مصطلحات جغرافيا الوحدة 2",
//         materialId: 4,
//         pdf: "https://arxiv.org/pdf/2403.13382",
//       ),
//       // اللغة الإنجليزية
//       ResumeUnitModel(
//         id: 9,
//         name: "مصطلحات إنجليزية: Ethics",
//         materialId: 5,
//         pdf: "https://arxiv.org/pdf/2403.13382",
//       ),
//       ResumeUnitModel(
//         id: 10,
//         name: "مصطلحات إنجليزية: Food & Ad",
//         materialId: 5,
//         pdf: "https://arxiv.org/pdf/2403.13382",
//       ),
//       ResumeUnitModel(
//         id: 11,
//         name: "مصطلحات إنجليزية: Astronomy",
//         materialId: 5,
//         pdf: "https://arxiv.org/pdf/2403.13382",
//       ),
//       // الشريعة الإسلامية
//       ResumeUnitModel(
//         id: 12,
//         name: "الوحدة 1: مقاصد الشريعة",
//         materialId: 6,
//         pdf: "https://arxiv.org/pdf/2403.13382",
//       ),
//       ResumeUnitModel(
//         id: 13,
//         name: "الوحدة 4: مصادر التشريع",
//         materialId: 6,
//         pdf: "https://arxiv.org/pdf/2403.13382",
//       ),
//       ResumeUnitModel(
//         id: 14,
//         name: "الوحدة 5: آثار التوحيد",
//         materialId: 6,
//         pdf: "https://arxiv.org/pdf/2403.13382",
//       ),
//     ],
//   );
// });
