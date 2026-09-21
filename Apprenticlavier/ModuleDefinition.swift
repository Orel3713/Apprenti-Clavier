//
//  ModuleDefinition.swift
//  Apprenti Clavier
//
//  Définition des modules de formation.
//

import Foundation

struct ModuleDefinition: Identifiable {

    let id: Int
    let titre: String
    let description: String
    let lecons: [LessonDefinition]
}

extension ModuleDefinition {

    static let module1 = ModuleDefinition(
        id: 1,
        titre: "Module 1 : Découverte du clavier",
        description:
            "Apprenez toutes les touches de la rangée de repos, "
            + "puis consolidez vos acquis.",
        lecons: [
            .chapitre1,
            .chapitre2,
            .chapitre3,
            .chapitre4,
            .chapitre5,
            .chapitre6
        ]
    )

    static let module2 = ModuleDefinition(
        id: 2,
        titre: "Module 2 : Barre d’espace et rangée supérieure",
        description:
            "Commencez par apprendre la barre d’espace avec les pouces, "
            + "puis découvrez progressivement les touches de la rangée supérieure.",
        lecons: [
            .preparationModule2,
            .module2Lecon1,
            .module2Lecon2,
            .module2Lecon3,
            .module2Lecon4,
            .module2Lecon5,
            .module2Lecon6
        ]
    )

    static let module3 = ModuleDefinition(
        id: 3,
        titre: "Module 3 : Rangée inférieure",
        description:
            "Découvrez progressivement les lettres de la rangée inférieure, "
            + "puis consolidez vos acquis.",
        lecons: [
            .module3Lecon1,
            .module3Lecon2,
            .module3Lecon3,
            .module3Lecon4
        ]
    )

    static let module4 = ModuleDefinition(
        id: 4,
        titre: "Module 4 : Consolidation des trois rangées",
        description:
            "Révisez les trois rangées du clavier, "
            + "puis entraînez-vous à passer progressivement de l’une à l’autre.",
        lecons: [
            .module4Lecon1,
            .module4Lecon2,
            .module4Lecon3,
            .module4Lecon4,
            .module4Lecon5,
            .module4Lecon6
        ]
    )

    static let module5 = ModuleDefinition(
        id: 5,
        titre: "Module 5 : Les mots courts",
        description:
            "Commencez à former des mots courts à partir des lettres déjà apprises, "
            + "avec un seul mot par exercice et des leçons organisées par thèmes.",
        lecons: [
            .module5Lecon1,
            .module5Lecon2,
            .module5Lecon3,
            .module5Lecon4,
            .module5Lecon5,
            .module5Lecon6
        ]
    )

    static let module6 = ModuleDefinition(
        id: 6,
        titre: "Module 6 : Les mots longs",
        description:
            "Travaillez des mots progressivement plus longs tout en conservant la précision, "
            + "les repères tactiles et un seul mot par exercice.",
        lecons: [
            .module6Lecon1,
            .module6Lecon2,
            .module6Lecon3,
            .module6Lecon4,
            .module6Lecon5,
            .module6Lecon6
        ]
    )

    static let module7 = ModuleDefinition(
        id: 7,
        titre: "Module 7 : Les mots enchaînés",
        description:
            "Apprenez à saisir plusieurs mots dans un même exercice, "
            + "avec une progression de deux à quatre mots séparés par des espaces.",
        lecons: [
            .module7Lecon1,
            .module7Lecon2,
            .module7Lecon3,
            .module7Lecon4,
            .module7Lecon5,
            .module7Lecon6
        ]
    )

    static let module8 = ModuleDefinition(
        id: 8,
        titre: "Module 8 : Les majuscules",
        description:
            "Apprenez à utiliser les deux touches Majuscule avec la main opposée, "
            + "puis entraînez-vous sur les trois rangées du clavier.",
        lecons: [
            .module8Lecon1,
            .module8Lecon2,
            .module8Lecon3,
            .module8Lecon4,
            .module8Lecon5,
            .module8Lecon6
        ]
    )

    static let module9 = ModuleDefinition(
        id: 9,
        titre: "Module 9 : Les mots avec une majuscule",
        description:
            "Appliquez la technique des majuscules à des mots, des prénoms et des noms propres, "
            + "avec une seule majuscule au début de chaque mot.",
        lecons: [
            .module9Lecon1,
            .module9Lecon2,
            .module9Lecon3,
            .module9Lecon4,
            .module9Lecon5,
            .module9Lecon6
        ]
    )

    static let module10 = ModuleDefinition(
        id: 10,
        titre: "Module 10 : Les mots enchaînés : majuscules et espaces",
        description:
            "Combinez les majuscules et les espaces en saisissant plusieurs mots dans un même exercice.",
        lecons: [
            .module10Lecon1,
            .module10Lecon2,
            .module10Lecon3,
            .module10Lecon4,
            .module10Lecon5,
            .module10Lecon6
        ]
    )

    static let module11 = ModuleDefinition(
        id: 11,
        titre: "Module 11 : Les lettres accentuées",
        description:
            "Apprenez à saisir les lettres accentuées, le C cédille, l’accent circonflexe et le tréma.",
        lecons: [
            .module11Lecon1,
            .module11Lecon2,
            .module11Lecon3,
            .module11Lecon4,
            .module11Lecon5,
            .module11Lecon6
        ]
    )

    static let module12 = ModuleDefinition(
        id: 12,
        titre: "Module 12 : Les mots accentués",
        description:
            "Utilisez les lettres accentuées, le C cédille, l’accent circonflexe et le tréma à l’intérieur de vrais mots.",
        lecons: [
            .module12Lecon1,
            .module12Lecon2,
            .module12Lecon3,
            .module12Lecon4,
            .module12Lecon5,
            .module12Lecon6
        ]
    )

    static let module13 = ModuleDefinition(
        id: 13,
        titre: "Module 13 : La ponctuation",
        description:
            "Apprenez à saisir les principaux signes de ponctuation avant de les utiliser dans des phrases complètes.",
        lecons: [
            .module13Lecon1,
            .module13Lecon2,
            .module13Lecon3,
            .module13Lecon4,
            .module13Lecon5
        ]
    )

    static let module14 = ModuleDefinition(
        id: 14,
        titre: "Module 14 : Les phrases",
        description:
            "Utilisez tout ce que vous avez appris pour saisir des phrases complètes et terminer votre parcours pédagogique.",
        lecons: [
            .module14Lecon1,
            .module14Lecon2,
            .module14Lecon3,
            .module14Lecon4,
            .module14Lecon5,
            .module14Lecon6
        ]
    )

    static let tousLesModules: [ModuleDefinition] = [
        .module1,
        .module2,
        .module3,
        .module4,
        .module5,
        .module6,
        .module7,
        .module8,
        .module9,
        .module10,
        .module11,
        .module12,
        .module13,
        .module14
    ]

    static let toutesLesLecons: [LessonDefinition] =
        tousLesModules.flatMap(\.lecons)
}







