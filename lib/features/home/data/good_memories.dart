// for exemple 3ns

// final data = {
//   "modules": [
//     {
//       "id": 1,
//       "title": 'الرياضيات',
//       "gradiantColorStart": '0xffC397EE',
//       "gradiantColorEnd": '0xff8549BA',
//       "iconPath": 'assets/icons/1.png',
//       "isActive": true,
//     },
//     {
//       "id": 2,
//       "title": 'اللغة العربية',
//       "gradiantColorStart": '0xff0C87C1',
//       "gradiantColorEnd": '0xff2ECCF4',
//       "iconPath": 'assets/icons/2.png',
//       "isActive": false,
//     },
//     {
//       "id": 3,
//       "title": 'اللغة الفرنسية',
//       "gradiantColorStart": '0xffCB2487',
//       "gradiantColorEnd": '0xffFD67C0',
//       "iconPath": 'assets/icons/3.png',
//       "isActive": false,
//     },
//     {
//       "id": 4,
//       "title": 'تاريخ وجغرافيا',
//       "gradiantColorStart": '0xffFFD54F',
//       "gradiantColorEnd": '0xffFFD54F',
//       "iconPath": 'assets/icons/4.png',
//       "isActive": false,
//     },
//   ],
//   "units": [
//     {"id": 1, "title": 'الجمع', "moduleId": 1},
//     {"id": 2, "title": 'الطرح', "moduleId": 1},
//     {"id": 3, "title": 'الضرب', "moduleId": 1},
//     {"id": 4, "title": 'القسمة', "moduleId": 1},
//     {"id": 5, "title": 'الحرب الباردة', "moduleId": 4},
//     {"id": 6, "title": 'الحرب العالمية الثانية', "moduleId": 4},
//     {"id": 7, "title": 'الحرب العالمية الأولى', "moduleId": 4},
//     {"id": 8, "title": 'الحرب الثلاثينية', "moduleId": 4},
//   ],
//   "exercises": [
//     {
//       "id": 1,
//       "question": "ما هو الناتج من جمع 2 + 2",
//       "options": ["4", "5", "6", "7"],
//       "correctOption": "4",
//       "unitId": 1,
//       "type": "selectRightOption",
//     },
//     {
//       "id": 2,
//       "question": "ما هو الناتج من جمع 3 + 3",
//       "options": ["4", "5", "6", "7"],
//       "correctOption": "6",
//       "unitId": 1,
//       "type": "selectRightOption",
//     },
//     {
//       "id": 3,
//       "question": "ما هو الناتج من جمع 4 + 4",
//       "options": ["4", "5", "6", "8"],
//       "correctOption": "8",
//       "unitId": 1,
//       "type": "selectRightOption",
//     },
//     {
//       "id": 4,
//       "question": "ما هو الناتج من جمع 5 + 5",
//       "options": ["4", "5", "6", "10"],
//       "correctOption": "10",
//       "unitId": 1,
//       "type": "selectRightOption",
//     },
//     {
//       "id": 7,
//       // "question": "ما هو السبب الرئيسي للحرب الباردة",
//       // "options": ["الديمقراطية", "الشيوعية", "الرأسمالية", "الاشتراكية"],
//       // "correctOption": "الشيوعية",
//       "hint": [
//         "الشيوعية هي النظام الذي يؤمن بالمساواة بين الجميع ",
//         "الشيوعية تعتبر الرأسمالية من الأعداء"
//       ],
//       "explanationVideo":
//           "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4",
//       "image": null,
//       "question":
//           'أي من هذه العبارات يعتبر معيار تاريخي وسياسي من معايير تشكل العالم بعد ح ع 2  ؟',
//       "options": [
//         'انتشار النظام الاشتراكي في أوروبا الشرقية',
//         'انتشار الآفات الاجتماعية ومظاهر البؤس نتيجة ح.ع.2',
//         'زوال الانظمة الدكتاتورية',
//         'خروج الولايات المتحدة الأمريكية كأكبر مستفيد من الحرب .'
//       ],
//       "correctOption": 'زوال الانظمة الدكتاتورية',
//       "remark": ["الاتحاد السوفيتي كان يعتبر الدولة الراعية للشيوعية"],
//       "unitId": 5,
//       "type": "selectRightOption",
//     },
//     {
//       "id": 9,
//       // "question": "هل الحرب الباردة حرب حقيقية",
//       // "correctAnswer": true,
//       "explanationVideo":
//           "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4",
//       "image": null,
//       "unitId": 5,
//       // "type": "trueFalse",
//       "question":
//           'هل انتشار النظام الاشتراكي في أوروبا الشرقية يعتبر معيار تاريخي وسياسي من معايير تشكل العالم بعد ح ع 2  ؟',
//       "hint": [
//         "النظام الاشتراكي هو نظام يؤمن بالمساواة بين الجميع",
//       ],
//       "remark": [
//         "النظام الاشتراكي هو نظام يؤمن بالمساواة بين الجميع",
//       ],
//       "correctAnswer": true,
//       "type": 'trueFalse',
//     },
//     {
//       "id": 10,
//       "question": "اختر الكلمة التي لا تنتمي لنفس المجموعة",
//       "words": [
//         "الحرب",
//         "السلام",
//         "الحب",
//         "الكراهية",
//         "الصداقة",
//         "العداوة",
//         "الفرح",
//         "الحزن",
//         "النجاح",
//         "الفشل",
//         "الأمل",
//         "اليأس"
//       ],
//       "correctAnomalies": ["الحب", "الكراهية"],
//       "remark": [
//         "الحب و الكراهية هما الكلمتين اللتان لا تنتميان لنفس المجموعة"
//       ],
//       "hint": ["الحب و الكراهية هما الكلمتين اللتان لا تنتميان لنفس المجموعة"],
//       "image": null,
//       "explanationVideo":
//           "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4",
//       "unitId": 5,
//       "type": "anomalyWord",
//     },
//     {
//       "id": 11,
//       // "sentence": "الشمس تشرق من _____ و تغرب في _____",
//       // "blanks": [
//       // {"position": 3, "correctWord": "الشرق"},
//       // {"position": 7, "correctWord": "الغرب"}
//       // ],
//       // "remark": ["الشمس تشرق من الشرق وتغرب في الغرب"],
//       // "hint": [
//       // "الشرق هو الجهة التي تشرق منها الشمس",
//       // "الغرب هو الجهة التي تغرب فيها الشمس"
//       // ],
//       // "image": null,
//       "explanationVideo":
//           "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4",
//       // "suggestions": ["الشرق", "الغرب", "الشمال", "الجنوب"],
//       "unitId": 5,
//       "type": "fillInTheBlank",
//       // question: 'تعريف شخصية هاري ترومان : ___',
//       "sentence":
//           'هو رئيس _____ صاحب تفجير القنبلة الذرية ضد _____ مؤيد الهجرة اليهودية لفلسطين و صاحب مشروع _____ على اسمه',
//       "blanks": [
//         {"position": 2, "correctWord": 'الو.م.أ'},
//         {"position": 8, "correctWord": 'اليابان'},
//         {"position": 17, "correctWord": 'ترومان'},
//       ],
//       "remark": [
//         'هو من اهم شخصيات الحرب الباردة يجب حفظه',
//       ],
//       "image":
//           "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTqXCiIrhd1CEHDEdCD8Pdr0j6JVufnw4PD9g&s",
//       "suggestions": [
//         'مارشال',
//         'ترومان',
//         'الو.م.أ',
//         'اليابان',
//         'ياسو',
//         'فرنسا',
//         'السوفيات',
//         'الألمان',
//       ],
//       "hint": [
//         'شخصيات الفصل الأول',
//       ],
//     },
//     // {
//     //   "id": 12,
//     //   "sentence":
//     //       "السماء زرقاء في _____ و النجوم تظهر في _____ و الطيور تغرد في _____ و القمر يظهر في ",
//     //   "blanks": [
//     //     {"position": 3, "correctWord": "النهار"},
//     //     {"position": 7, "correctWord": "الليل"},
//     //     {"position": 11, "correctWord": "الصباح"},
//     //     {"position": 15, "correctWord": "المساء"}
//     //   ],
//     //   "remark": [
//     //     "السماء زرقاء في النهار و النجوم تظهر في الليل و الطيور تغرد في الصباح و القمر يظهر في المساء"
//     //   ],
//     //   "hint": [
//     //     "النهار هو الوقت الذي تكون فيه الشمس مشرقة",
//     //     "الليل هو الوقت الذي تظهر فيه النجوم",
//     //     "الصباح هو بداية النهار",
//     //     "المساء هو نهاية النهار"
//     //   ],
//     //   "image": null,
//     //   "explanationVideo":
//     //       "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4",
//     //   "suggestions": [
//     //     "النهار",
//     //     "الليل",
//     //     "الصباح",
//     //     "المساء",
//     //     "الشرق",
//     //     "الغرب",
//     //     "الشمال",
//     //     "الجنوب",
//     //     "الفجر",
//     //     "الغسق"
//     //   ],
//     //   "unitId": 5,
//     //   "type": "fillInTheBlank",
//     // },
//     {
//       "id": 11,
//       "firstColumn": [
//         '09 نوفمبر 1989',
//         '3 أكتوبر 1990',
//         '8 ماي 1945',
//         '1-6 سبتمبر 1961',
//         '16 فيفري 1947'
//       ],
//       "secondColumn": [
//         'مجازر 8 ماي',
//         'تأسيس المنظمة الخاصة',
//         'تأسيس حركة عدم الإنحياز',
//         'تحطيم جدار برلين',
//         'توحيد الألمانيتين'
//       ],

//       "correctAnswers": [
//         {"first": '09 نوفمبر 1989', "second": 'تحطيم جدار برلين'},
//         {"first": '3 أكتوبر 1990', "second": 'توحيد الألمانيتين'},
//         {"first": '8 ماي 1945', "second": 'مجازر 8 ماي'},
//         {"first": '1-6 سبتمبر 1961', "second": 'تأسيس حركة عدم الإنحياز'},
//         {"first": '16 فيفري 1947', "second": 'تأسيس المنظمة الخاصة'},
//       ],
//       // "firstColumn": ["ريال مدريد", "اياكس", "بورتو", "بايرن ميونخ"],
//       // "secondColumn": ["هولندا", "المانيا", "البرتغال", "اسبانيا"],
//       // "correctAnswers": [
//       // {"first": "ريال مدريد", "second": "اسبانيا"},
//       // {"first": "اياكس", "second": "هولندا"},
//       // {"first": "بورتو", "second": "البرتغال"},
//       // {"first": "بايرن ميونخ", "second": "المانيا"}
//       // ],
//       "unitId": 5,
//       "hint": [],
//       "remark": [],
//       "explanationVideo":
//           "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4",
//       "image": null,
//       "type": "pairTwoWords",
//     },
//   ]
// };
