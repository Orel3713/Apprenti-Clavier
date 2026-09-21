//
//  LessonDefinition.swift
//  Apprenti Clavier
//
//  Modèle réutilisable pour les leçons interactives.
//

import Foundation

struct LessonStepDefinition: Identifiable {

    let id: Int
    let titre: String
    let texte: String
}

struct TypingExerciseDefinition: Identifiable {

    let id: Int
    let texteAttendu: String
    let instruction: String
    let modeLecture: ExerciseReadingMode
}

enum ExerciseReadingMode {

    case epeler
    case lireNaturellement
}

struct LessonDefinition: Identifiable {

    let id: Int
    let titre: String
    let sousTitre: String
    let introduction: String
    let etapes: [LessonStepDefinition]
    let exercices: [TypingExerciseDefinition]
    let resumeFinal: String
    var identifiantLeconPersonnalisee: UUID? = nil
    var nomFormateurSource: String? = nil
    var objectifPedagogique: ObjectifPedagogique? = nil
}

extension LessonDefinition {

    static let chapitre1 = LessonDefinition(
        id: 1,
        titre: "Leçon 1",
        sousTitre: "Les touches F et J",
        introduction:
            "Bienvenue dans la leçon 1. "
            + "Aujourd’hui, nous allons découvrir les touches F et J, "
            + "les deux principaux repères tactiles de la rangée de repos.",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "La position de repos",
                texte:
                    "Posez vos mains sur la rangée centrale du clavier. "
                    + "Vos index vont se placer sur les touches F et J."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "La touche F",
                texte:
                    "Placez votre index gauche sur la touche F. "
                    + "Vous pouvez sentir un petit relief sous votre doigt."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "Le repère tactile de F",
                texte:
                    "Le relief de la touche F vous permet de retrouver "
                    + "la position de repos sans regarder le clavier."
            ),
            LessonStepDefinition(
                id: 4,
                titre: "La touche J",
                texte:
                    "Placez votre index droit sur la touche J. "
                    + "Cette touche possède également un petit relief."
            ),
            LessonStepDefinition(
                id: 5,
                titre: "Le repère tactile de J",
                texte:
                    "Le relief de la touche J permet à votre main droite "
                    + "de retrouver sa position de repos."
            ),
            LessonStepDefinition(
                id: 6,
                titre: "Les deux index",
                texte:
                    "Gardez maintenant votre index gauche sur F "
                    + "et votre index droit sur J."
            ),
            LessonStepDefinition(
                id: 7,
                titre: "Prêt pour les exercices",
                texte:
                    "Vous allez maintenant vous entraîner à utiliser F et J "
                    + "avec le bon index, sans déplacer vos mains."
            )
        ],
        exercices: [
            TypingExerciseDefinition(
                id: 1,
                texteAttendu: "f",
                instruction:
                    "Placez votre index gauche sur la touche F, repérable grâce à son petit relief, "
                    + "puis appuyez une fois sur F sans déplacer votre main.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 2,
                texteAttendu: "j",
                instruction:
                    "Placez votre index droit sur la touche J, repérable grâce à son petit relief, "
                    + "puis appuyez une fois sur J sans déplacer votre main.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 3,
                texteAttendu: "fj",
                instruction:
                    "Tapez F avec l’index gauche, puis J avec l’index droit.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 4,
                texteAttendu: "fjfj",
                instruction:
                    "Alternez F et J en gardant les deux index en position.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 5,
                texteAttendu: "ffjjfj",
                instruction:
                    "Tapez deux fois F, deux fois J, puis F et J.",
                modeLecture: .epeler
            )
        ],
        resumeFinal:
            "Bravo. Vous avez découvert les touches F et J. "
            + "Vous savez placer l’index gauche sur F et l’index droit sur J, "
            + "et utiliser leurs reliefs pour retrouver la position de repos."
    )

    static let chapitre2 = LessonDefinition(
        id: 2,
        titre: "Leçon 2",
        sousTitre: "Les touches D et K",
        introduction:
            "Bienvenue dans la leçon 2. "
            + "Vous allez apprendre les touches D et K, "
            + "tout en conservant F et J comme repères de repos.",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Retrouver la position de repos",
                texte:
                    "Placez votre index gauche sur F et votre index droit sur J. "
                    + "Gardez vos mains détendues sur la rangée centrale."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "La touche D",
                texte:
                    "Placez le majeur gauche sur la touche D. "
                    + "Elle se trouve immédiatement à gauche de F."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "Déplacement vers D",
                texte:
                    "Depuis F, laissez l’index gauche en place et utilisez "
                    + "le majeur gauche pour appuyer sur D."
            ),
            LessonStepDefinition(
                id: 4,
                titre: "Retour sur la position de repos",
                texte:
                    "Après avoir appuyé sur D, gardez le majeur gauche sur D "
                    + "et vérifiez que l’index gauche repose toujours sur F."
            ),
            LessonStepDefinition(
                id: 5,
                titre: "La touche K",
                texte:
                    "Placez le majeur droit sur la touche K. "
                    + "Elle se trouve immédiatement à droite de J."
            ),
            LessonStepDefinition(
                id: 6,
                titre: "Déplacement vers K",
                texte:
                    "Depuis J, laissez l’index droit en place et utilisez "
                    + "le majeur droit pour appuyer sur K."
            ),
            LessonStepDefinition(
                id: 7,
                titre: "Les quatre doigts",
                texte:
                    "Gardez maintenant le majeur gauche sur D, l’index gauche sur F, "
                    + "l’index droit sur J et le majeur droit sur K."
            ),
            LessonStepDefinition(
                id: 8,
                titre: "Prêt pour les exercices",
                texte:
                    "Vous allez vous entraîner avec D, F, J et K, "
                    + "sans déplacer vos mains de la rangée de repos."
            )
        ],
        exercices: [
            TypingExerciseDefinition(
                id: 1,
                texteAttendu: "d",
                instruction:
                    "Gardez votre index gauche sur F et placez votre majeur gauche sur D, "
                    + "immédiatement à gauche de F. Appuyez une fois sur D.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 2,
                texteAttendu: "k",
                instruction:
                    "Gardez votre index droit sur J et placez votre majeur droit sur K, "
                    + "immédiatement à droite de J. Appuyez une fois sur K.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 3,
                texteAttendu: "dk",
                instruction:
                    "Tapez D avec le majeur gauche, puis K avec le majeur droit.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 4,
                texteAttendu: "fdkj",
                instruction:
                    "Tapez F, D, K et J en utilisant le doigt associé à chaque touche.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 5,
                texteAttendu: "dfkjdk",
                instruction:
                    "Mélangez D, F, J et K en gardant vos mains sur la rangée de repos.",
                modeLecture: .epeler
            )
        ],
        resumeFinal:
            "Bravo. Vous avez appris D avec le majeur gauche "
            + "et K avec le majeur droit. "
            + "Vous savez maintenant utiliser D, F, J et K "
            + "sans quitter la position de repos."
    )


    static let chapitre3 = LessonDefinition(
        id: 3,
        titre: "Leçon 3",
        sousTitre: "Les touches S et L",
        introduction:
            "Bienvenue dans la leçon 3. "
            + "Vous allez apprendre les touches S et L, "
            + "tout en révisant D, F, J et K.",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Retrouver la position de repos",
                texte:
                    "Placez l’index gauche sur F et l’index droit sur J. "
                    + "Posez ensuite les majeurs sur D et K."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "La touche S",
                texte:
                    "Placez l’annulaire gauche sur la touche S. "
                    + "Elle se trouve immédiatement à gauche de D."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "Déplacement vers S",
                texte:
                    "Gardez l’index gauche sur F et le majeur gauche sur D. "
                    + "Utilisez l’annulaire gauche pour appuyer sur S."
            ),
            LessonStepDefinition(
                id: 4,
                titre: "Retour sur la position de repos",
                texte:
                    "Après avoir appuyé sur S, laissez l’annulaire gauche sur S "
                    + "et vérifiez que les autres doigts n’ont pas bougé."
            ),
            LessonStepDefinition(
                id: 5,
                titre: "La touche L",
                texte:
                    "Placez l’annulaire droit sur la touche L. "
                    + "Elle se trouve immédiatement à droite de K."
            ),
            LessonStepDefinition(
                id: 6,
                titre: "Déplacement vers L",
                texte:
                    "Gardez l’index droit sur J et le majeur droit sur K. "
                    + "Utilisez l’annulaire droit pour appuyer sur L."
            ),
            LessonStepDefinition(
                id: 7,
                titre: "Les six doigts",
                texte:
                    "Votre main gauche repose maintenant sur la lettre F, la lettre D et la lettre S. "
                    + "Votre main droite repose sur J, K et L."
            ),
            LessonStepDefinition(
                id: 8,
                titre: "Prêt pour les exercices",
                texte:
                    "Vous allez vous entraîner avec S, D, F, J, K et L, "
                    + "en gardant vos doigts sur la rangée de repos."
            )
        ],
        exercices: [
            TypingExerciseDefinition(
                id: 1,
                texteAttendu: "s",
                instruction:
                    "Gardez votre majeur gauche sur D et placez votre annulaire gauche sur S, "
                    + "immédiatement à gauche de D. Appuyez une fois sur S.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 2,
                texteAttendu: "l",
                instruction:
                    "Gardez votre majeur droit sur K et placez votre annulaire droit sur L, "
                    + "immédiatement à droite de K. Appuyez une fois sur L.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 3,
                texteAttendu: "sl",
                instruction:
                    "Tapez S avec l’annulaire gauche, puis L avec l’annulaire droit.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 4,
                texteAttendu: "fdsjkl",
                instruction:
                    "Tapez F, D, S, puis J, K et L avec le doigt associé à chaque touche.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 5,
                texteAttendu: "sdflkj",
                instruction:
                    "Tapez S, D, F, puis L, K et J en conservant la position de repos.",
                modeLecture: .epeler
            )
        ],
        resumeFinal:
            "Bravo. Vous avez appris S avec l’annulaire gauche "
            + "et L avec l’annulaire droit. "
            + "Vous savez maintenant utiliser S, D, F, J, K et L "
            + "sans déplacer vos mains de la rangée de repos."
    )


    static let chapitre4 = LessonDefinition(
        id: 4,
        titre: "Leçon 4",
        sousTitre: "Les touches Q et aime",
        introduction:
            "Bienvenue dans la leçon 4. "
            + "Vous allez apprendre les touches Q et aime, "
            + "et compléter la position de repos de vos deux mains.",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Retrouver la position de repos",
                texte:
                    "Placez d’abord votre main gauche. "
                    + "Pour la main gauche, l’index repose sur la lettre F. Le majeur repose sur la lettre D. L’annulaire repose sur la lettre S. "
                    + "Placez ensuite votre main droite. "
                    + "Pour la main droite, l’index repose sur la touche J. Le majeur repose sur la touche K. L’annulaire repose sur la touche elle."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "La touche Q",
                texte:
                    "Placez l’auriculaire gauche sur la touche Q. "
                    + "Elle se trouve immédiatement à gauche de S."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "Déplacement vers Q",
                texte:
                    "Gardez l’index gauche sur la lettre F, le majeur sur la lettre D et l’annulaire sur la lettre S. "
                    + "Utilisez l’auriculaire gauche pour appuyer sur Q."
            ),
            LessonStepDefinition(
                id: 4,
                titre: "Retour sur la position de repos",
                texte:
                    "Après avoir appuyé sur Q, laissez l’auriculaire gauche sur Q "
                    + "et vérifiez que les autres doigts sont toujours sur la lettre F, la lettre D et la lettre S."
            ),
            LessonStepDefinition(
                id: 5,
                titre: "La touche aime",
                texte:
                    "Placez l’auriculaire droit sur la touche aime du clavier. "
                    + "Sur un clavier AZERTY français, elle se trouve immédiatement à droite de la touche elle."
            ),
            LessonStepDefinition(
                id: 6,
                titre: "Déplacement vers la touche aime",
                texte:
                    "Gardez l’index droit sur la touche J. Gardez le majeur droit sur la touche K. Gardez l’annulaire droit sur la touche elle. "
                    + "Utilisez l’auriculaire droit pour appuyer sur la touche aime du clavier."
            ),
            LessonStepDefinition(
                id: 7,
                titre: "La rangée de repos complète",
                texte:
                    "Vos doigts sont maintenant en position de repos. "
                    + "Pour la main gauche, ils reposent sur la lettre F, la lettre D, la lettre S et la lettre Q. "
                    + "Pour la main droite, l’index repose sur la touche J, le majeur sur la touche K, l’annulaire sur la touche elle et l’auriculaire sur la touche aime."
            ),
            LessonStepDefinition(
                id: 8,
                titre: "Prêt pour les exercices",
                texte:
                    "Vous allez maintenant vous entraîner avec toute la rangée de repos. "
                    + "La main gauche utilisera la lettre F, la lettre D, la lettre S et la lettre Q. "
                    + "La main droite utilisera la touche J, la touche K, la touche elle et la touche aime."
            )
        ],
        exercices: [
            TypingExerciseDefinition(
                id: 1,
                texteAttendu: "q",
                instruction:
                    "Gardez votre annulaire gauche sur S et placez votre auriculaire gauche sur Q, "
                    + "immédiatement à gauche de S. Appuyez une fois sur Q.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 2,
                texteAttendu: "m",
                instruction:
                    "Gardez votre annulaire droit sur la touche elle et placez votre auriculaire droit "
                    + "sur la touche aime, immédiatement à droite de la touche elle. "
                    + "Appuyez une fois sur la touche aime.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 3,
                texteAttendu: "qm",
                instruction:
                    "Tapez Q avec l’auriculaire gauche, puis la touche aime avec l’auriculaire droit.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 4,
                texteAttendu: "qsdfjklm",
                instruction:
                    "Tapez toute la rangée de repos de gauche à droite. "
                    + "Commencez avec la main gauche sur la touche Q, la touche S, la touche D et la touche F. "
                    + "Continuez avec la main droite sur la touche J, la touche K, la touche elle et la touche aime.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 5,
                texteAttendu: "fdsqjklm",
                instruction:
                    "Tapez successivement les touches F, D, S, puis la touche Q. "
                    + "Continuez directement avec la touche J, puis la touche K, "
                    + "puis la touche elle et enfin la touche aime.",
                modeLecture: .epeler
            )
        ],
        resumeFinal:
            "Bravo. Vous avez appris Q avec l’auriculaire gauche "
            + "et la touche aime avec l’auriculaire droit. "
            + "Vous savez maintenant placer correctement vos deux mains sur la rangée de repos."
    )

    static let chapitre5 = LessonDefinition(
        id: 5,
        titre: "Leçon 5",
        sousTitre: "Les touches G et H",
        introduction:
            "Bienvenue dans la leçon 5. "
            + "Aujourd’hui, nous allons apprendre les touches G et H.",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "La touche G",
                texte:
                    "Placez votre index gauche sur la touche F."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Déplacement vers G",
                texte:
                    "Déplacez légèrement votre index gauche vers la droite "
                    + "jusqu’à la touche G."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "Retour sur F",
                texte:
                    "Après avoir appuyé sur G, revenez immédiatement "
                    + "sur la touche F."
            ),
            LessonStepDefinition(
                id: 4,
                titre: "La touche H",
                texte:
                    "Placez votre index droit sur la touche J."
            ),
            LessonStepDefinition(
                id: 5,
                titre: "Déplacement vers H",
                texte:
                    "Déplacez légèrement votre index droit vers la gauche "
                    + "jusqu’à la touche H."
            ),
            LessonStepDefinition(
                id: 6,
                titre: "Retour sur J",
                texte:
                    "Après avoir appuyé sur H, revenez immédiatement "
                    + "sur la touche J."
            ),
            LessonStepDefinition(
                id: 7,
                titre: "Prêt pour les exercices",
                texte:
                    "Vous allez maintenant vous entraîner avec F, G, H et J."
            )
        ],
        exercices: [
            TypingExerciseDefinition(
                id: 1,
                texteAttendu: "gg",
                instruction:
                    "Placez votre index gauche sur F, puis déplacez-le légèrement vers la droite "
                    + "pour atteindre G. Tapez deux fois G, puis revenez immédiatement sur F.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 2,
                texteAttendu: "hh",
                instruction:
                    "Placez votre index droit sur J, puis déplacez-le légèrement vers la gauche "
                    + "pour atteindre H. Tapez deux fois H, puis revenez immédiatement sur J.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 3,
                texteAttendu: "ghgh",
                instruction:
                    "Alternez G et H avec les deux index.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 4,
                texteAttendu: "fghj",
                instruction:
                    "Partez de F et J, puis utilisez G et H.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 5,
                texteAttendu: "ghfjhg",
                instruction:
                    "Mélangez F, G, H et J avec régularité.",
                modeLecture: .epeler
            )
        ],
        resumeFinal:
            "Bravo. Aujourd’hui, vous avez appris G avec l’index gauche "
            + "et H avec l’index droit. "
            + "Vous savez également revenir sur F et J après chaque frappe."
    )

    static let chapitre6 = LessonDefinition(
        id: 6,
        titre: "Leçon 6",
        sousTitre: "Consolidation de la rangée de repos",
        introduction:
            "Bravo. Vous connaissez maintenant toutes les touches de la rangée de repos. "
            + "Cette leçon va consolider vos acquis avant le passage au module suivant.",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Retrouver les repères tactiles",
                texte:
                    "Placez votre index gauche sur la touche F et votre index droit sur la touche J. "
                    + "Utilisez les reliefs de ces deux touches pour retrouver la position de repos."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "La main gauche",
                texte:
                    "Pour la main gauche, l’auriculaire repose sur la touche Q. "
                    + "L’annulaire repose sur la touche S. "
                    + "Le majeur repose sur la touche D. "
                    + "L’index repose sur la touche F."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "La main droite",
                texte:
                    "Pour la main droite, l’index repose sur la touche J. "
                    + "Le majeur repose sur la touche K. "
                    + "L’annulaire repose sur la touche elle. "
                    + "L’auriculaire repose sur la touche aime."
            ),
            LessonStepDefinition(
                id: 4,
                titre: "Les touches centrales",
                texte:
                    "Pour atteindre G, déplacez l’index gauche depuis F vers la droite, puis revenez sur F. "
                    + "Pour atteindre H, déplacez l’index droit depuis J vers la gauche, puis revenez sur J."
            ),
            LessonStepDefinition(
                id: 5,
                titre: "Objectif de consolidation",
                texte:
                    "Vous allez maintenant mélanger toutes les touches apprises. "
                    + "Privilégiez la précision et gardez vos mains détendues."
            )
        ],
        exercices: [
            TypingExerciseDefinition(
                id: 1,
                texteAttendu: "qsdf",
                instruction:
                    "Tapez les touches de la main gauche, de l’auriculaire vers l’index.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 2,
                texteAttendu: "jklm",
                instruction:
                    "Tapez les touches de la main droite, de l’index vers l’auriculaire.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 3,
                texteAttendu: "qsdfjklm",
                instruction:
                    "Tapez les touches de la main gauche, puis continuez directement "
                    + "avec les touches de la main droite.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 4,
                texteAttendu: "fjdkslqmgh",
                instruction:
                    "Tapez successivement les cinq paires de touches apprises : "
                    + "F et J, D et K, S et elle, Q et aime, puis G et H.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 5,
                texteAttendu: "qsdfghjklm",
                instruction:
                    "Tapez Q, S et D, puis continuez avec F, G et H. "
                    + "Terminez avec J, K, la touche elle et la touche aime.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 6,
                texteAttendu: "fdsqjklmgh",
                instruction:
                    "Exercice final de précision. Tapez successivement : F, D, S. Q. J, K, la touche elle et la touche aime. G et H.",
                modeLecture: .epeler
            )
        ],
        resumeFinal:
            "Félicitations. Vous avez terminé le module 1. "
            + "Vous connaissez maintenant toutes les touches de la rangée de repos du clavier AZERTY. "
            + "Vous savez placer correctement vos deux mains, utiliser les touches apprises "
            + "et déplacer vos index vers G et H avant de retrouver vos repères sur F et J. "
            + "Vous êtes prêt à découvrir la rangée supérieure."
    )


    static let preparationModule2 = LessonDefinition(
        id: 7,
        titre: "Préparation au module 2",
        sousTitre: "La barre d’espace",
        introduction:
            "Bienvenue dans la préparation au module 2. "
            + "Avant de découvrir la rangée supérieure, "
            + "vous allez apprendre à utiliser la barre d’espace avec les pouces.",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Le rôle de la barre d’espace",
                texte:
                    "La barre d’espace est la longue touche située tout en bas du clavier. "
                    + "Elle permet de séparer les lettres, les groupes de lettres et les mots."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Les pouces",
                texte:
                    "La barre d’espace se frappe avec un pouce. "
                    + "Vous pouvez utiliser le pouce droit ou le pouce gauche, "
                    + "selon celui qui vous semble le plus naturel."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "Garder les doigts en position",
                texte:
                    "Pendant que le pouce appuie sur la barre d’espace, "
                    + "les autres doigts restent posés sur la rangée de repos."
            ),
            LessonStepDefinition(
                id: 4,
                titre: "Un geste léger",
                texte:
                    "Appuyez brièvement sur la barre d’espace, puis relâchez-la. "
                    + "Le pouce revient ensuite dans une position détendue sous le clavier."
            ),
            LessonStepDefinition(
                id: 5,
                titre: "Séparer deux lettres",
                texte:
                    "Pour taper deux lettres séparées, tapez la première lettre, "
                    + "appuyez une fois sur la barre d’espace avec un pouce, "
                    + "puis tapez la deuxième lettre."
            ),
            LessonStepDefinition(
                id: 6,
                titre: "Prêt pour les exercices",
                texte:
                    "Vous allez maintenant utiliser les touches de la rangée de repos "
                    + "et insérer un espace entre plusieurs lettres."
            )
        ],
        exercices: [
            TypingExerciseDefinition(
                id: 1,
                texteAttendu: "f j",
                instruction:
                    "Tapez F, appuyez une fois sur la barre d’espace, puis tapez J.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 2,
                texteAttendu: "d k",
                instruction:
                    "Tapez D, insérez un espace, puis tapez K.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 3,
                texteAttendu: "s l",
                instruction:
                    "Tapez S, insérez un espace, puis tapez la touche elle.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 4,
                texteAttendu: "q m",
                instruction:
                    "Tapez Q, insérez un espace, puis tapez la touche aime.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 5,
                texteAttendu: "f j d k",
                instruction:
                    "Tapez quatre lettres séparées par un espace : "
                    + "F, J, D et K.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 6,
                texteAttendu: "qs df gh jk lm",
                instruction:
                    "Tapez cinq groupes de deux lettres séparés par un espace : "
                    + "Q S, D F, G H, J K, puis les touches elle et aime.",
                modeLecture: .epeler
            )
        ],
        resumeFinal:
            "Bravo. Vous savez maintenant utiliser la barre d’espace avec un pouce "
            + "tout en gardant les autres doigts sur la rangée de repos. "
            + "Vous êtes prêt à commencer les leçons du module 2 "
            + "et à découvrir la rangée supérieure."
    )


    static let module2Lecon1 = LessonDefinition(
        id: 8,
        titre: "Leçon 1",
        sousTitre: "Les touches R et U",
        introduction:
            "Bienvenue dans la leçon 1 du module 2. "
            + "Vous allez découvrir les touches R et U de la rangée supérieure, "
            + "tout en utilisant F et J comme repères de la position de repos.",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Retrouver la position de repos",
                texte:
                    "Placez votre index gauche sur F et votre index droit sur J. "
                    + "Gardez les autres doigts posés naturellement sur la rangée de repos."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "La touche R",
                texte:
                    "La touche R se frappe avec l’index gauche. "
                    + "Depuis F, déplacez légèrement votre index gauche vers le haut et vers la gauche pour atteindre R."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "Retour sur F",
                texte:
                    "Après avoir appuyé sur R, ramenez immédiatement votre index gauche sur F. "
                    + "Utilisez le relief de F pour vérifier votre position."
            ),
            LessonStepDefinition(
                id: 4,
                titre: "La lettre U",
                texte:
                    "La touche U se frappe avec l’index droit. "
                    + "Depuis J, déplacez légèrement votre index droit vers le haut et vers la gauche pour atteindre U."
            ),
            LessonStepDefinition(
                id: 5,
                titre: "Retour sur J",
                texte:
                    "Après avoir appuyé sur U, ramenez immédiatement votre index droit sur J. "
                    + "Utilisez le relief de J pour retrouver votre position de repos."
            ),
            LessonStepDefinition(
                id: 6,
                titre: "Les deux index",
                texte:
                    "Pour R, partez de F avec l’index gauche et revenez sur F. "
                    + "Pour U, partez de J avec l’index droit et revenez sur J."
            ),
            LessonStepDefinition(
                id: 7,
                titre: "Prêt pour les exercices",
                texte:
                    "Vous allez maintenant vous entraîner avec R et U, "
                    + "puis les associer progressivement aux touches déjà apprises."
            )
        ],
        exercices: [
            TypingExerciseDefinition(
                id: 1,
                texteAttendu: "r",
                instruction:
                    "Tapez une fois R, située au-dessus et légèrement à gauche de F, avec l’index gauche, puis revenez sur F.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 2,
                texteAttendu: "u",
                instruction:
                    "Tapez la lettre U, située au-dessus et légèrement à gauche de J, avec l’index droit, puis revenez sur J.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 3,
                texteAttendu: "ru",
                instruction:
                    "Tapez R avec l’index gauche, puis U avec l’index droit.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 4,
                texteAttendu: "ruru",
                instruction:
                    "Alternez R et U en revenant sur F et J après chaque frappe.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 5,
                texteAttendu: "uru",
                instruction:
                    "Tapez U, puis R, puis U, en revenant sur la lettre J et la lettre F après chaque frappe.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 6,
                texteAttendu: "ruurur",
                instruction:
                    "Tapez R, U, U, R, U, puis R, en revenant sur les touches de repos après chaque frappe.",
                modeLecture: .epeler
            )
        ],
        resumeFinal:
            "Bravo. Vous avez appris R avec l’index gauche et U avec l’index droit. "
            + "Vous savez quitter temporairement la rangée de repos pour atteindre ces deux touches, "
            + "puis revenir sur F et J. "
            + "Vous avez également commencé à associer la rangée supérieure aux touches déjà apprises."
    )


    static let module2Lecon2 = LessonDefinition(
        id: 9,
        titre: "Leçon 2",
        sousTitre: "Les touches E et I",
        introduction:
            "Bienvenue dans la leçon 2 du module 2. "
            + "Vous allez découvrir les touches E et I de la rangée supérieure, "
            + "en partant de D et K sur la rangée de repos.",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Retrouver la position de repos",
                texte:
                    "Placez votre index gauche sur F et votre index droit sur J. "
                    + "Votre majeur gauche repose sur D et votre majeur droit sur K."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "La touche E",
                texte:
                    "La touche E se frappe avec le majeur gauche. "
                    + "Depuis D, déplacez votre majeur gauche vers le haut pour atteindre E."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "Retour sur D",
                texte:
                    "Après avoir appuyé sur E, ramenez immédiatement votre majeur gauche sur D. "
                    + "Gardez votre index gauche sur F pour conserver votre repère."
            ),
            LessonStepDefinition(
                id: 4,
                titre: "La touche I",
                texte:
                    "La touche I se frappe avec le majeur droit. "
                    + "Depuis K, déplacez votre majeur droit vers le haut pour atteindre I."
            ),
            LessonStepDefinition(
                id: 5,
                titre: "Retour sur K",
                texte:
                    "Après avoir appuyé sur I, ramenez immédiatement votre majeur droit sur K. "
                    + "Gardez votre index droit sur J pour conserver votre repère."
            ),
            LessonStepDefinition(
                id: 6,
                titre: "Les deux majeurs",
                texte:
                    "Pour E, partez de D avec le majeur gauche et revenez sur D. "
                    + "Pour I, partez de K avec le majeur droit et revenez sur K."
            ),
            LessonStepDefinition(
                id: 7,
                titre: "Prêt pour les exercices",
                texte:
                    "Vous allez maintenant vous entraîner avec E et I, "
                    + "puis les associer progressivement à R et U déjà appris."
            )
        ],
        exercices: [
            TypingExerciseDefinition(
                id: 1,
                texteAttendu: "e",
                instruction:
                    "Tapez la lettre E, située au-dessus de D, avec le majeur gauche, puis revenez sur D.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 2,
                texteAttendu: "i",
                instruction:
                    "Tapez la lettre I, située au-dessus de K, avec le majeur droit, puis revenez sur K.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 3,
                texteAttendu: "ei",
                instruction:
                    "Tapez E avec le majeur gauche, puis I avec le majeur droit.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 4,
                texteAttendu: "eiei",
                instruction:
                    "Alternez E et I en revenant sur D et K après chaque frappe.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 5,
                texteAttendu: "erui",
                instruction:
                    "Tapez E, R, U, puis I, en revenant sur les touches de repos après chaque frappe.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 6,
                texteAttendu: "reiuir",
                instruction:
                    "Tapez R, E, I, U, I, puis R, en revenant sur les touches de repos après chaque frappe.",
                modeLecture: .epeler
            )
        ],
        resumeFinal:
            "Très bien. Vous avez appris E avec le majeur gauche et I avec le majeur droit. "
            + "Vous savez partir de D et K pour atteindre ces deux touches de la rangée supérieure, "
            + "puis revenir sur la rangée de repos. "
            + "Vous avez également commencé à les associer à R et U."
    )


    static let module2Lecon3 = LessonDefinition(
        id: 10,
        titre: "Leçon 3",
        sousTitre: "Les touches Z et O",
        introduction:
            "Bienvenue dans la leçon 3 du module 2. "
            + "Vous allez découvrir les touches Z et O de la rangée supérieure, "
            + "en partant de S et L sur la rangée de repos.",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Retrouver la position de repos",
                texte:
                    "Placez vos mains sur la rangée de repos. "
                    + "Votre annulaire gauche repose sur S et votre annulaire droit sur L."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "La touche Z",
                texte:
                    "La touche Z se frappe avec l’annulaire gauche. "
                    + "Depuis S, déplacez votre annulaire gauche vers le haut pour atteindre Z."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "Retour sur S",
                texte:
                    "Après avoir appuyé sur Z, ramenez immédiatement votre annulaire gauche sur S."
            ),
            LessonStepDefinition(
                id: 4,
                titre: "La touche O",
                texte:
                    "La touche O se frappe avec l’annulaire droit. "
                    + "Depuis L, déplacez votre annulaire droit vers le haut pour atteindre O."
            ),
            LessonStepDefinition(
                id: 5,
                titre: "Retour sur L",
                texte:
                    "Après avoir appuyé sur O, ramenez immédiatement votre annulaire droit sur L."
            ),
            LessonStepDefinition(
                id: 6,
                titre: "Les deux annulaires",
                texte:
                    "Pour Z, partez de S avec l’annulaire gauche et revenez sur S. "
                    + "Pour O, partez de L avec l’annulaire droit et revenez sur L."
            ),
            LessonStepDefinition(
                id: 7,
                titre: "Prêt pour les exercices",
                texte:
                    "Vous allez maintenant vous entraîner avec Z et O, "
                    + "puis les associer progressivement aux touches déjà apprises dans ce module."
            )
        ],
        exercices: [
            TypingExerciseDefinition(
                id: 1,
                texteAttendu: "z",
                instruction:
                    "Tapez la lettre Z, située au-dessus de S, avec l’annulaire gauche, puis revenez sur S.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 2,
                texteAttendu: "o",
                instruction:
                    "Tapez la lettre O, située au-dessus de L, avec l’annulaire droit, puis revenez sur L.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 3,
                texteAttendu: "zo",
                instruction:
                    "Tapez Z avec l’annulaire gauche, puis O avec l’annulaire droit.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 4,
                texteAttendu: "zozo",
                instruction:
                    "Alternez Z et O en revenant sur S et L après chaque frappe.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 5,
                texteAttendu: "zeio",
                instruction:
                    "Tapez Z, E, I, puis O, en revenant sur les touches de repos après chaque frappe.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 6,
                texteAttendu: "rzeoiu",
                instruction:
                    "Tapez R, Z, E, O, I, puis U, en utilisant les touches de la rangée supérieure déjà apprises.",
                modeLecture: .epeler
            )
        ],
        resumeFinal:
            "Beau travail. Vous avez appris Z avec l’annulaire gauche et O avec l’annulaire droit. "
            + "Vous savez partir de S et L pour atteindre ces deux touches de la rangée supérieure, "
            + "puis revenir sur la rangée de repos. "
            + "Vous les avez également associées aux touches déjà apprises dans le module 2."
    )


    static let module2Lecon4 = LessonDefinition(
        id: 11,
        titre: "Leçon 4",
        sousTitre: "Les touches A et P",
        introduction:
            "Bienvenue dans la leçon 4 du module 2. "
            + "Vous allez découvrir les touches A et P de la rangée supérieure, "
            + "en partant de Q et de la touche aime sur la rangée de repos.",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Retrouver la position de repos",
                texte:
                    "Placez vos mains sur la rangée de repos. "
                    + "Votre auriculaire gauche repose sur Q et votre auriculaire droit sur la touche aime."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "La touche A",
                texte:
                    "La touche A se frappe avec l’auriculaire gauche. "
                    + "Depuis Q, déplacez votre auriculaire gauche vers le haut pour atteindre A."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "Retour sur Q",
                texte:
                    "Après avoir appuyé sur A, ramenez immédiatement votre auriculaire gauche sur Q."
            ),
            LessonStepDefinition(
                id: 4,
                titre: "La touche P",
                texte:
                    "La touche P se frappe avec l’auriculaire droit. "
                    + "Gardez l’index droit en contact avec J pour conserver votre repère. "
                    + "Étendez l’auriculaire droit vers la rangée située au-dessus de la touche aime pour atteindre P."
            ),
            LessonStepDefinition(
                id: 5,
                titre: "Retour sur la touche aime",
                texte:
                    "Après avoir appuyé sur P, ramenez l’auriculaire droit sur la touche aime "
                    + "en conservant votre repère sur J."
            ),
            LessonStepDefinition(
                id: 6,
                titre: "Les deux auriculaires",
                texte:
                    "Pour A, partez de Q avec l’auriculaire gauche et revenez sur Q. "
                    + "Pour P, gardez J comme repère avec l’index droit, "
                    + "étendez l’auriculaire droit vers la rangée située au-dessus de la touche aime, "
                    + "puis revenez sur la touche aime."
            ),
            LessonStepDefinition(
                id: 7,
                titre: "Prêt pour les exercices",
                texte:
                    "Vous allez maintenant vous entraîner avec A et P, "
                    + "puis les associer progressivement aux touches déjà apprises dans ce module."
            )
        ],
        exercices: [
            TypingExerciseDefinition(
                id: 1,
                texteAttendu: "a",
                instruction:
                    "Tapez la lettre A, située au-dessus de Q, avec l’auriculaire gauche, puis revenez sur Q.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 2,
                texteAttendu: "p",
                instruction:
                    "Gardez l’index droit en contact avec J pour conserver votre repère. "
                    + "Étendez l’auriculaire droit vers la rangée située au-dessus de la touche aime pour atteindre P. "
                    + "Appuyez sur P, puis ramenez l’auriculaire sur la touche aime en conservant votre repère sur J.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 3,
                texteAttendu: "ap",
                instruction:
                    "Tapez A avec l’auriculaire gauche, puis P avec l’auriculaire droit.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 4,
                texteAttendu: "apap",
                instruction:
                    "Alternez A et P en revenant sur Q et la touche aime après chaque frappe.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 5,
                texteAttendu: "azeop",
                instruction:
                    "Tapez A, Z, E, O, puis P, en revenant sur les touches de repos après chaque frappe.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 6,
                texteAttendu: "rapeziuop",
                instruction:
                    "Tapez R, A, P, E, Z, I, U, O, puis P, en utilisant les touches de la rangée supérieure déjà apprises.",
                modeLecture: .epeler
            )
        ],
        resumeFinal:
            "Très bien. Vous avez appris A avec l’auriculaire gauche et P avec l’auriculaire droit. "
            + "Vous savez partir de Q et la touche aime pour atteindre ces deux touches de la rangée supérieure, "
            + "puis revenir sur la rangée de repos. "
            + "Vous les avez également associées aux touches déjà apprises dans le module 2."
    )


    static let module2Lecon5 = LessonDefinition(
        id: 12,
        titre: "Leçon 5",
        sousTitre: "Les touches T et Y",
        introduction:
            "Bienvenue dans la leçon 5 du module 2. "
            + "Vous allez découvrir les touches T et Y de la rangée supérieure. "
            + "Ces deux touches se frappent avec les index.",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Retrouver la position de repos",
                texte:
                    "Placez votre index gauche sur F et votre index droit sur J. "
                    + "Ces deux touches servent de repères pour apprendre T et Y."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "La touche T",
                texte:
                    "La touche T se frappe avec l’index gauche. "
                    + "Depuis F, déplacez votre index gauche vers le haut et légèrement vers la droite pour atteindre T."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "Retour sur F",
                texte:
                    "Après avoir appuyé sur T, ramenez immédiatement votre index gauche sur F."
            ),
            LessonStepDefinition(
                id: 4,
                titre: "La touche Y",
                texte:
                    "La touche Y se frappe avec l’index droit. "
                    + "Depuis J, déplacez votre index droit vers le haut et vers la gauche, "
                    + "en dépassant la position de la touche U déjà apprise, "
                    + "pour atteindre Y, située immédiatement à gauche de U."
            ),
            LessonStepDefinition(
                id: 5,
                titre: "Retour sur J",
                texte:
                    "Après avoir appuyé sur Y, ramenez immédiatement votre index droit sur J."
            ),
            LessonStepDefinition(
                id: 6,
                titre: "Les deux index",
                texte:
                    "Pour T, partez de F avec l’index gauche, vers le haut et légèrement vers la droite, puis revenez sur F. "
                    + "Pour Y, partez de J avec l’index droit, allez vers le haut et vers la gauche en dépassant U, puis revenez sur J."
            ),
            LessonStepDefinition(
                id: 7,
                titre: "Prêt pour les exercices",
                texte:
                    "Vous allez maintenant vous entraîner avec T et Y, "
                    + "puis les associer progressivement aux autres touches de la rangée supérieure déjà apprises."
            )
        ],
        exercices: [
            TypingExerciseDefinition(
                id: 1,
                texteAttendu: "t",
                instruction:
                    "Placez votre index gauche sur F. Déplacez-le vers le haut et légèrement vers la droite pour atteindre T. "
                    + "Appuyez sur T, puis ramenez votre index gauche sur F.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 2,
                texteAttendu: "y",
                instruction:
                    "Placez votre index droit sur J. Déplacez-le vers le haut et vers la gauche, "
                    + "en dépassant la position de la touche U déjà apprise, pour atteindre Y, située immédiatement à gauche de U. "
                    + "Appuyez sur Y, puis ramenez votre index droit sur J.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 3,
                texteAttendu: "ty",
                instruction:
                    "Tapez T avec l’index gauche, puis Y avec l’index droit.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 4,
                texteAttendu: "tyty",
                instruction:
                    "Alternez T et Y en revenant sur F et J après chaque frappe.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 5,
                texteAttendu: "truy",
                instruction:
                    "Tapez T, R, U, puis Y, en revenant sur les touches de repos après chaque frappe.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 6,
                texteAttendu: "tazeruiopy",
                instruction:
                    "Tapez T, A, Z, E, R, U, I, O, P, puis Y, "
                    + "en utilisant toutes les touches de la rangée supérieure apprises jusqu’ici.",
                modeLecture: .epeler
            )
        ],
        resumeFinal:
            "Félicitations. Vous avez appris T avec l’index gauche et Y avec l’index droit. "
            + "Vous savez atteindre T depuis F et Y depuis J, puis revenir sur la rangée de repos. "
            + "Vous avez maintenant découvert toutes les touches alphabétiques de la rangée supérieure."
    )


    static let module2Lecon6 = LessonDefinition(
        id: 13,
        titre: "Leçon 6",
        sousTitre: "Consolidation de la rangée supérieure",
        introduction:
            "Bienvenue dans la leçon 6 du module 2. "
            + "Cette leçon de consolidation va vous permettre de réviser toutes les lettres "
            + "de la rangée supérieure apprises dans ce module : A, Z, E, R, T, Y, la lettre U, I, O et P.",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Retrouver la rangée de repos",
                texte:
                    "Avant de commencer, replacez vos mains sur la rangée de repos. "
                    + "Utilisez F et J comme repères tactiles pour retrouver la position correcte de vos mains."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Main gauche",
                texte:
                    "Avec la main gauche, vous avez appris A, Z, E, R, et la lettre T. "
                    + "Revenez sur la rangée de repos après chaque déplacement."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "Main droite",
                texte:
                    "Avec la main droite, vous avez appris Y, la lettre U, I, O et P. "
                    + "Revenez sur la rangée de repos après chaque déplacement."
            ),
            LessonStepDefinition(
                id: 4,
                titre: "Objectif de la consolidation",
                texte:
                    "Les exercices vont maintenant mélanger progressivement toutes les lettres de la rangée supérieure. "
                    + "Prenez votre temps et privilégiez la précision plutôt que la vitesse."
            )
        ],
        exercices: [
            TypingExerciseDefinition(
                id: 1,
                texteAttendu: "azert",
                instruction:
                    "Tapez la touche A, puis Z, E, R, et la lettre T avec la main gauche.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 2,
                texteAttendu: "yuiop",
                instruction:
                    "Tapez la touche Y, puis la lettre U, puis la lettre I, puis la lettre O, et enfin la lettre P avec la main droite.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 3,
                texteAttendu: "azerty",
                instruction:
                    "Tapez la touche A, puis Z, E, R, T, puis la touche Y.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 4,
                texteAttendu: "ytreza",
                instruction:
                    "Tapez la touche Y, puis T, R, E, Z, puis A.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 5,
                texteAttendu: "aeiouy",
                instruction:
                    "Tapez la touche A, puis E, I, O, la lettre U, puis la touche Y.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 6,
                texteAttendu: "azertyuiop",
                instruction:
                    "Pour terminer, tapez toutes les lettres de la rangée supérieure dans l’ordre : "
                    + "A, Z, E, R, T, Y, la lettre U, I, O, puis P.",
                modeLecture: .epeler
            )
        ],
        resumeFinal:
            "Bravo. Vous avez terminé la consolidation de la rangée supérieure. "
            + "Vous avez révisé A, Z, E, R, T, Y, la lettre U, I, O et P avec les doigts correspondants. "
            + "Vous êtes maintenant prêt à découvrir la rangée inférieure dans le prochain module."
    )


    static let module3Lecon1 = LessonDefinition(
        id: 14,
        titre: "Leçon 1",
        sousTitre: "Les touches C et V",
        introduction:
            "Bienvenue dans la leçon 1 du module 3. "
            + "Vous allez commencer l’apprentissage de la rangée inférieure avec les touches C et V. "
            + "Ces deux touches se frappent avec l’index gauche en partant de F.",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Retrouver la position de repos",
                texte:
                    "Placez votre index gauche sur F, repérable grâce à son petit relief. "
                    + "Cette touche servira de point de départ et de retour pour C et V."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "La touche C",
                texte:
                    "La touche C se frappe avec l’index gauche. "
                    + "Depuis F, descendez votre index vers le bas et légèrement vers la gauche pour atteindre C."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "Retour sur F après C",
                texte:
                    "Après avoir appuyé sur C, ramenez immédiatement votre index gauche sur F "
                    + "afin de retrouver votre repère sur la rangée de repos."
            ),
            LessonStepDefinition(
                id: 4,
                titre: "La touche V",
                texte:
                    "La touche V se frappe également avec l’index gauche. "
                    + "Depuis F, descendez votre index vers le bas et légèrement vers la droite pour atteindre V."
            ),
            LessonStepDefinition(
                id: 5,
                titre: "Retour sur F après V",
                texte:
                    "Après avoir appuyé sur V, ramenez immédiatement votre index gauche sur F."
            ),
            LessonStepDefinition(
                id: 6,
                titre: "Deux directions depuis F",
                texte:
                    "Pour C, partez de F vers le bas et légèrement vers la gauche. "
                    + "Pour V, partez de F vers le bas et légèrement vers la droite. "
                    + "Revenez sur F après chaque frappe."
            ),
            LessonStepDefinition(
                id: 7,
                titre: "Prêt pour les exercices",
                texte:
                    "Vous allez maintenant vous entraîner avec C et V, "
                    + "puis les associer progressivement à des lettres déjà apprises."
            )
        ],
        exercices: [
            TypingExerciseDefinition(
                id: 1,
                texteAttendu: "c",
                instruction:
                    "Placez votre index gauche sur F. Descendez-le vers le bas et légèrement vers la gauche pour atteindre C. "
                    + "Appuyez sur C, puis ramenez votre index sur F.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 2,
                texteAttendu: "v",
                instruction:
                    "Placez votre index gauche sur F. Descendez-le vers le bas et légèrement vers la droite pour atteindre V. "
                    + "Appuyez sur V, puis ramenez votre index sur F.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 3,
                texteAttendu: "cv",
                instruction:
                    "Tapez C, revenez sur F, puis tapez V et revenez sur F.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 4,
                texteAttendu: "cvcv",
                instruction:
                    "Alternez C et V en revenant sur F après chaque frappe.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 5,
                texteAttendu: "cfvf",
                instruction:
                    "Tapez C, F, V, puis F.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 6,
                texteAttendu: "rcvufj",
                instruction:
                    "Tapez R, C, V, la lettre U, F, puis J en utilisant les touches déjà apprises.",
                modeLecture: .epeler
            )
        ],
        resumeFinal:
            "Bravo. Vous avez appris C et V avec l’index gauche. "
            + "Vous savez partir de F vers le bas et légèrement vers la gauche pour atteindre C, "
            + "et vers le bas et légèrement vers la droite pour atteindre V, "
            + "puis revenir sur F après chaque frappe."
    )


    static let module3Lecon2 = LessonDefinition(
        id: 15,
        titre: "Leçon 2",
        sousTitre: "Les touches W et X",
        introduction:
            "Bienvenue dans la leçon 2 du module 3. "
            + "Vous allez découvrir les touches W et X de la rangée inférieure. "
            + "La touche W se frappe avec l’annulaire gauche et la touche X avec le majeur gauche.",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Retrouver la position de repos",
                texte:
                    "Placez votre annulaire gauche sur S et votre majeur gauche sur D. "
                    + "Ces deux touches serviront de points de départ et de retour pour W et X."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "La touche W",
                texte:
                    "La touche W se frappe avec l’annulaire gauche. "
                    + "Depuis S, descendez votre annulaire vers le bas et légèrement vers la gauche pour atteindre W."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "Retour sur S",
                texte:
                    "Après avoir appuyé sur W, ramenez immédiatement votre annulaire gauche sur S."
            ),
            LessonStepDefinition(
                id: 4,
                titre: "La touche X",
                texte:
                    "La touche X se frappe avec le majeur gauche. "
                    + "Depuis D, descendez votre majeur vers le bas et légèrement vers la gauche pour atteindre X."
            ),
            LessonStepDefinition(
                id: 5,
                titre: "Retour sur D",
                texte:
                    "Après avoir appuyé sur X, ramenez immédiatement votre majeur gauche sur D."
            ),
            LessonStepDefinition(
                id: 6,
                titre: "Deux déplacements vers la gauche",
                texte:
                    "Pour W, partez de S avec l’annulaire gauche et descendez vers le bas et légèrement vers la gauche. "
                    + "Pour X, partez de D avec le majeur gauche et effectuez le même type de déplacement. "
                    + "Revenez sur S ou D après chaque frappe."
            ),
            LessonStepDefinition(
                id: 7,
                titre: "Prêt pour les exercices",
                texte:
                    "Vous allez maintenant vous entraîner avec W et X, "
                    + "puis les associer progressivement à C et V et à des lettres déjà apprises."
            )
        ],
        exercices: [
            TypingExerciseDefinition(
                id: 1,
                texteAttendu: "w",
                instruction:
                    "Placez votre annulaire gauche sur S. Descendez-le vers le bas et légèrement vers la gauche pour atteindre W. "
                    + "Appuyez sur W, puis ramenez votre annulaire sur S.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 2,
                texteAttendu: "x",
                instruction:
                    "Placez votre majeur gauche sur D. Descendez-le vers le bas et légèrement vers la gauche pour atteindre X. "
                    + "Appuyez sur X, puis ramenez votre majeur sur D.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 3,
                texteAttendu: "wx",
                instruction:
                    "Tapez W avec l’annulaire gauche, revenez sur S, puis tapez X avec le majeur gauche et revenez sur D.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 4,
                texteAttendu: "wxwx",
                instruction:
                    "Alternez W et X en revenant sur la rangée de repos après chaque frappe.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 5,
                texteAttendu: "wxcv",
                instruction:
                    "Tapez W, X, C, puis V en utilisant les doigts appris dans les deux premières leçons du module.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 6,
                texteAttendu: "wsxdcfv",
                instruction:
                    "Tapez W, S, X, D, C, F, puis la lettre vé en revenant régulièrement sur les touches de repos.",
                modeLecture: .epeler
            )
        ],
        resumeFinal:
            "Très bien. Vous avez appris W avec l’annulaire gauche et X avec le majeur gauche. "
            + "Vous savez descendre depuis S ou D vers le bas et légèrement vers la gauche, "
            + "puis revenir sur la rangée de repos après chaque frappe."
    )


    static let module3Lecon3 = LessonDefinition(
        id: 16,
        titre: "Leçon 3",
        sousTitre: "Les touches B et N",
        introduction:
            "Bienvenue dans la leçon 3 du module 3. "
            + "Vous allez découvrir les touches B et N de la rangée inférieure. "
            + "La touche B se frappe avec l’index gauche et la touche N avec l’index droit.",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Retrouver les repères",
                texte:
                    "Placez votre index gauche sur F et votre index droit sur J. "
                    + "Ces deux touches serviront de points de départ et de retour pour B et N."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "La touche B",
                texte:
                    "La touche B se frappe avec l’index gauche. "
                    + "Depuis F, descendez votre index vers le bas et vers la droite, "
                    + "en dépassant la position de la touche V déjà apprise, "
                    + "pour atteindre B, située immédiatement à droite de V."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "Retour sur F",
                texte:
                    "Après avoir appuyé sur B, ramenez immédiatement votre index gauche sur F."
            ),
            LessonStepDefinition(
                id: 4,
                titre: "La touche N",
                texte:
                    "La touche N se frappe avec l’index droit. "
                    + "Depuis J, descendez votre index vers le bas et légèrement vers la gauche pour atteindre N."
            ),
            LessonStepDefinition(
                id: 5,
                titre: "Retour sur J",
                texte:
                    "Après avoir appuyé sur N, ramenez immédiatement votre index droit sur J."
            ),
            LessonStepDefinition(
                id: 6,
                titre: "Les deux index",
                texte:
                    "Pour B, partez de F vers le bas et vers la droite en dépassant la position de V, puis revenez sur F. "
                    + "Pour N, partez de J vers le bas et légèrement vers la gauche, puis revenez sur J."
            ),
            LessonStepDefinition(
                id: 7,
                titre: "Prêt pour les exercices",
                texte:
                    "Vous allez maintenant vous entraîner avec B et N, "
                    + "puis les associer progressivement aux autres lettres de la rangée inférieure déjà apprises."
            )
        ],
        exercices: [
            TypingExerciseDefinition(
                id: 1,
                texteAttendu: "b",
                instruction:
                    "Placez votre index gauche sur F. Descendez-le vers le bas et vers la droite, "
                    + "en dépassant la position de la touche V déjà apprise, pour atteindre B, située immédiatement à droite de V. "
                    + "Appuyez sur B, puis ramenez votre index gauche sur F.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 2,
                texteAttendu: "n",
                instruction:
                    "Placez votre index droit sur J. Descendez-le vers le bas et légèrement vers la gauche pour atteindre N. "
                    + "Appuyez sur N, puis ramenez votre index droit sur J.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 3,
                texteAttendu: "bn",
                instruction:
                    "Tapez B avec l’index gauche, revenez sur F, puis tapez N avec l’index droit et revenez sur J.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 4,
                texteAttendu: "bnbn",
                instruction:
                    "Alternez B et N en revenant sur F ou J après chaque frappe.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 5,
                texteAttendu: "cvbn",
                instruction:
                    "Tapez C, V, B, puis N en utilisant les index gauche et droit.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 6,
                texteAttendu: "wxcvbn",
                instruction:
                    "Tapez W, X, C, V, B, puis N en utilisant toutes les lettres de la rangée inférieure apprises dans ce module.",
                modeLecture: .epeler
            )
        ],
        resumeFinal:
            "Beau travail. Vous avez appris B avec l’index gauche et N avec l’index droit. "
            + "Vous savez atteindre B depuis F en dépassant la position de V, "
            + "et N depuis J en descendant vers le bas et légèrement vers la gauche. "
            + "Vous connaissez maintenant toutes les lettres de la rangée inférieure."
    )

    static let module3Lecon4 = LessonDefinition(
        id: 17,
        titre: "Leçon 4",
        sousTitre: "Consolidation de la rangée inférieure",
        introduction:
            "Bienvenue dans la leçon 4 du module 3. "
            + "Cette leçon de consolidation va vous permettre de réviser toutes les lettres "
            + "de la rangée inférieure apprises dans ce module : W, X, C, V, B et N.",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Retrouver la rangée de repos",
                texte:
                    "Avant de commencer, replacez vos mains sur la rangée de repos. "
                    + "Utilisez F et J comme repères tactiles pour retrouver la position correcte de vos mains."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Les lettres apprises",
                texte:
                    "Vous avez appris W avec l’annulaire gauche, X avec le majeur gauche, "
                    + "C, V et B avec l’index gauche, puis N avec l’index droit."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "Revenir sur la rangée de repos",
                texte:
                    "Après chaque frappe sur la rangée inférieure, revenez sur la touche de repos correspondante. "
                    + "Prenez le temps de retrouver vos repères avant de poursuivre."
            ),
            LessonStepDefinition(
                id: 4,
                titre: "Objectif de la consolidation",
                texte:
                    "Les exercices vont maintenant mélanger progressivement W, X, C, V, B et N. "
                    + "Privilégiez la précision et la bonne position des doigts plutôt que la vitesse."
            )
        ],
        exercices: [
            TypingExerciseDefinition(
                id: 1,
                texteAttendu: "wxc",
                instruction:
                    "Tapez W avec l’annulaire gauche, X avec le majeur gauche, puis C avec l’index gauche.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 2,
                texteAttendu: "vbn",
                instruction:
                    "Tapez la lettre vé avec l’index gauche, puis B avec l’index gauche et N avec l’index droit.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 3,
                texteAttendu: "wxcvbn",
                instruction:
                    "Tapez W, X, C, la lettre vé, B, puis N dans l’ordre de la rangée inférieure.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 4,
                texteAttendu: "nbvcxw",
                instruction:
                    "Tapez N, B, la lettre vé, C, X, puis W dans l’ordre inverse.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 5,
                texteAttendu: "cwbxnv",
                instruction:
                    "Tapez C, W, B, X, N, puis la lettre vé.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 6,
                texteAttendu: "wxcvbnnbvcxw",
                instruction:
                    "Pour terminer, tapez W, X, C, la lettre vé, B, N, puis N, B, la lettre vé, C, X et W.",
                modeLecture: .epeler
            )
        ],
        resumeFinal:
            "Bravo. Vous avez terminé la consolidation de la rangée inférieure. "
            + "Vous avez révisé W, X, C, V, B et N avec les doigts correspondants. "
            + "Vous connaissez maintenant les lettres des trois rangées du clavier. "
            + "Dans le prochain module, vous allez consolider vos acquis en révisant et en mélangeant ces trois rangées."
    )

    static let module4Lecon1 = LessonDefinition(
        id: 18,
        titre: "Leçon 1",
        sousTitre: "Révision de la rangée de repos",
        introduction:
            "Bienvenue dans le module 4, consacré à la consolidation des trois rangées du clavier. "
            + "Dans cette première leçon, vous allez réviser toutes les lettres de la rangée de repos : "
            + "Q, S, D, F, G, H, J, K, L et M.",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Retrouver les repères",
                texte:
                    "Placez votre index gauche sur F et votre index droit sur J. "
                    + "Utilisez les petits reliefs de ces deux touches pour retrouver la position de vos mains."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Main gauche",
                texte:
                    "Avec la main gauche, retrouvez d’abord la lettre F, puis la lettre D, la lettre S, la lettre Q et enfin la lettre G. "
                    + "Gardez les doigts posés sur la rangée de repos et déplacez uniquement le doigt nécessaire."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "Main droite",
                texte:
                    "Avec la main droite, retrouvez H, J, K, la touche elle et la touche aime. "
                    + "Gardez vos repères sur la rangée de repos."
            ),
            LessonStepDefinition(
                id: 4,
                titre: "Objectif de la révision",
                texte:
                    "Les deux premiers exercices rappellent les repères et la position des doigts. "
                    + "À partir du troisième exercice, les consignes deviennent plus courtes "
                    + "afin de vous laisser travailler de mémoire. "
                    + "Privilégiez la précision plutôt que la vitesse."
            )
        ],
        exercices: [
            TypingExerciseDefinition(
                id: 1,
                texteAttendu: "qsdfg",
                instruction:
                    "Tapez Q, S, D, F, puis G avec la main gauche.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 2,
                texteAttendu: "hjklm",
                instruction:
                    "Tapez H, J, K, la touche elle, puis la touche aime avec la main droite.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 3,
                texteAttendu: "qsdfghjklm",
                instruction:
                    "Tapez Q, S, D, F, G, H, J, K, la touche elle, puis la touche aime.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 4,
                texteAttendu: "mlkjhgfdsq",
                instruction:
                    "Tapez la touche aime, la touche elle, K, J, H, G, F, D, S, puis Q.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 5,
                texteAttendu: "fdjkgshl",
                instruction:
                    "Tapez F, D, J, K, G, S, H, puis la touche elle.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 6,
                texteAttendu: "qmfjskdhlg",
                instruction:
                    "Pour terminer, tapez Q, la touche aime, F, J, S, K, D, H, la touche elle, puis G.",
                modeLecture: .epeler
            )
        ],
        resumeFinal:
            "Bravo. Vous avez révisé toutes les lettres de la rangée de repos. "
            + "Vous avez retrouvé vos repères sur F et J et renforcé la position des deux mains. "
            + "La prochaine leçon révisera la rangée supérieure."
    )


    static let module4Lecon2 = LessonDefinition(
        id: 19,
        titre: "Leçon 2",
        sousTitre: "Révision de la rangée supérieure",
        introduction:
            "Dans cette deuxième leçon du module 4, vous allez réviser toutes les lettres "
            + "de la rangée supérieure : A, Z, E, R, T, Y, la lettre U, I, O et P.",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Retrouver les repères",
                texte:
                    "Replacez vos mains sur la rangée de repos avec les index sur F et J.\n"
                    + "Vous allez utiliser ces repères pour retrouver les touches de la rangée supérieure."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Main gauche",
                texte:
                    "Avec la main gauche, retrouvez la touche A, la touche Z, la touche E, la touche R et la touche T.\n"
                    + "La touche A se frappe avec l’auriculaire, la touche Z avec l’annulaire, la touche E avec le majeur, "
                    + "et les touches R et T avec l’index gauche."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "Main droite",
                texte:
                    "Avec la main droite, retrouvez la touche Y, la lettre U, la touche I, la touche O et la touche P.\n"
                    + "La touche Y et la lettre U se frappent avec l’index droit, la touche I avec le majeur, "
                    + "la touche O avec l’annulaire et la touche P avec l’auriculaire droit."
            ),
            LessonStepDefinition(
                id: 4,
                titre: "Objectif de la révision",
                texte:
                    "Les deux premiers exercices rappellent les doigts utilisés pour chaque partie de la rangée.\n"
                    + "À partir du troisième exercice, les consignes deviennent plus courtes "
                    + "afin de vous laisser travailler de mémoire.\n"
                    + "Privilégiez la précision plutôt que la vitesse."
            )
        ],
        exercices: [
            TypingExerciseDefinition(
                id: 1,
                texteAttendu: "azert",
                instruction:
                    "Tapez A avec l’auriculaire gauche, Z avec l’annulaire gauche, E avec le majeur gauche, "
                    + "puis R et T avec l’index gauche.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 2,
                texteAttendu: "yuiop",
                instruction:
                    "Tapez la touche Y puis la lettre U avec l’index droit, I avec le majeur droit, "
                    + "O avec l’annulaire droit et P avec l’auriculaire droit.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 3,
                texteAttendu: "azertyuiop",
                instruction:
                    "Tapez A, Z, E, R, T, la touche Y, la lettre U, I, O, puis P.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 4,
                texteAttendu: "poiuytreza",
                instruction:
                    "Tapez P, O, I, la lettre U, la touche Y, T, R, E, Z, puis A.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 5,
                texteAttendu: "raietouypz",
                instruction:
                    "Tapez R, A, I, E, T, O, la lettre U, la touche Y, P, puis Z.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 6,
                texteAttendu: "tyraopuzei",
                instruction:
                    "Pour terminer, tapez T, la touche Y, R, A, O, P, la lettre U, Z, E, puis I.",
                modeLecture: .epeler
            )
        ],
        resumeFinal:
            "Très bien. Vous avez révisé toutes les lettres de la rangée supérieure. "
            + "Vous avez retrouvé les doigts correspondants et renforcé vos repères sur l’ensemble de ces touches. "
            + "La prochaine leçon révisera la rangée inférieure."
    )


    static let module4Lecon3 = LessonDefinition(
        id: 20,
        titre: "Leçon 3",
        sousTitre: "Révision de la rangée inférieure",
        introduction:
            "Dans cette troisième leçon du module 4, vous allez réviser toutes les lettres "
            + "de la rangée inférieure : W, X, C, V, B et N.",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Retrouver les repères",
                texte:
                    "Replacez vos mains sur la rangée de repos avec les index sur F et J.\n"
                    + "Vous allez partir de ces repères pour retrouver les touches de la rangée inférieure."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "W et X",
                texte:
                    "Retrouvez la touche W avec l’annulaire gauche et la touche X avec le majeur gauche.\n"
                    + "Pour chacune de ces touches, descendez le doigt vers le bas et légèrement vers la gauche."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "C et V",
                texte:
                    "Retrouvez la touche C puis la touche V avec l’index gauche.\n"
                    + "Pour C, descendez légèrement vers la gauche. "
                    + "Pour V, descendez légèrement vers la droite."
            ),
            LessonStepDefinition(
                id: 4,
                titre: "B et N",
                texte:
                    "Retrouvez la touche B avec l’index gauche et la touche N avec l’index droit.\n"
                    + "Pour B, descendez vers le bas et légèrement vers la droite, au-delà de V. "
                    + "Pour N, descendez l’index droit vers le bas et légèrement vers la gauche."
            ),
            LessonStepDefinition(
                id: 5,
                titre: "Objectif de la révision",
                texte:
                    "Les deux premiers exercices rappellent les doigts et les déplacements.\n"
                    + "À partir du troisième exercice, les consignes deviennent plus courtes "
                    + "afin de vous laisser retrouver les touches de mémoire."
            )
        ],
        exercices: [
            TypingExerciseDefinition(
                id: 1,
                texteAttendu: "wx",
                instruction:
                    "Tapez la touche W avec l’annulaire gauche, puis la touche X avec le majeur gauche. "
                    + "Pour les deux touches, descendez vers le bas et légèrement vers la gauche.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 2,
                texteAttendu: "cvbn",
                instruction:
                    "Tapez C puis V avec l’index gauche. "
                    + "Continuez avec B avec l’index gauche, puis N avec l’index droit.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 3,
                texteAttendu: "wxcvbn",
                instruction:
                    "Tapez W, X, C, V, B, puis N.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 4,
                texteAttendu: "nbvcxw",
                instruction:
                    "Tapez N, B, V, C, X, puis W.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 5,
                texteAttendu: "cvxnbw",
                instruction:
                    "Tapez C, V, X, N, B, puis W.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 6,
                texteAttendu: "bnwvcx",
                instruction:
                    "Pour terminer, tapez B, N, W, V, C, puis X.",
                modeLecture: .epeler
            )
        ],
        resumeFinal:
            "Beau travail. Vous avez révisé toutes les lettres de la rangée inférieure. "
            + "Vous avez retrouvé les doigts et les déplacements correspondants sur l’ensemble de ces touches. "
            + "La prochaine leçon commencera à mélanger la rangée de repos et la rangée supérieure."
    )


    static let module4Lecon4 = LessonDefinition(
        id: 21,
        titre: "Leçon 4",
        sousTitre: "Mélanger la rangée de repos et la rangée supérieure",
        introduction:
            "Dans cette quatrième leçon du module 4, vous allez commencer à mélanger "
            + "les lettres de la rangée de repos et celles de la rangée supérieure. "
            + "L’objectif est de passer d’une rangée à l’autre tout en retrouvant vos repères sur F et J.",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Retrouver les repères",
                texte:
                    "Placez vos index sur F et J afin de retrouver la position de repos.\n"
                    + "À chaque déplacement vers la rangée supérieure, revenez ensuite sur la rangée de repos."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Main gauche",
                texte:
                    "Avec la main gauche, vous allez alterner les touches de repos en partant de la lettre F, puis D, S, Q et G, "
                    + "avec les touches supérieures A, Z, E, R et T.\n"
                    + "Gardez F comme repère principal pour retrouver rapidement la position de votre main."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "Main droite",
                texte:
                    "Avec la main droite, vous allez alterner les touches de repos H, J, K, la touche elle et la touche aime "
                    + "avec les touches supérieures Y, la lettre U, I, O et P.\n"
                    + "Gardez J comme repère principal pour retrouver rapidement la position de votre main."
            ),
            LessonStepDefinition(
                id: 4,
                titre: "Objectif de la leçon",
                texte:
                    "Les deux premiers exercices vous guident pour alterner entre les deux rangées.\n"
                    + "À partir du troisième exercice, les consignes deviennent plus courtes "
                    + "afin de laisser vos automatismes prendre le relais."
            )
        ],
        exercices: [
            TypingExerciseDefinition(
                id: 1,
                texteAttendu: "fa",
                instruction:
                    "Tapez F sur la rangée de repos, puis la touche A sur la rangée supérieure. "
                    + "Revenez ensuite sur F.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 2,
                texteAttendu: "jy",
                instruction:
                    "Tapez J sur la rangée de repos, puis la touche Y sur la rangée supérieure. "
                    + "Revenez ensuite sur J.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 3,
                texteAttendu: "qazsde",
                instruction:
                    "Tapez Q, A, Z, S, D, puis E.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 4,
                texteAttendu: "dertfg",
                instruction:
                    "Tapez D, E, R, T, F, puis G.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 5,
                texteAttendu: "juiokl",
                instruction:
                    "Tapez J, la lettre U, I, O, K, puis la touche elle.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 6,
                texteAttendu: "aqszedrfthjyukilomp",
                instruction:
                    "Pour terminer, tapez A, Q, S, Z, E, D, R, F, T, H, J, la touche Y, "
                    + "la lettre U, K, I, la touche elle, O, la touche aime, puis P.",
                modeLecture: .epeler
            )
        ],
        resumeFinal:
            "Très bien. Vous avez commencé à alterner entre la rangée de repos et la rangée supérieure. "
            + "Vous avez renforcé vos repères sur F et J et appris à revenir rapidement à la position de repos. "
            + "La prochaine leçon mélangera la rangée de repos et la rangée inférieure."
    )


    static let module4Lecon5 = LessonDefinition(
        id: 22,
        titre: "Leçon 5",
        sousTitre: "Mélanger la rangée de repos et la rangée inférieure",
        introduction:
            "Dans cette cinquième leçon du module 4, vous allez mélanger "
            + "les lettres de la rangée de repos et celles de la rangée inférieure. "
            + "L’objectif est de descendre vers les touches inférieures puis de retrouver rapidement vos repères sur F et J.",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Retrouver les repères",
                texte:
                    "Placez vos index sur F et J afin de retrouver la position de repos.\n"
                    + "Après chaque déplacement vers la rangée inférieure, revenez naturellement vers vos repères."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Main gauche",
                texte:
                    "Avec la main gauche, vous allez alterner les touches de repos en partant de la lettre F, puis D, S, Q et G, "
                    + "avec les touches inférieures W, X, C, V et B.\n"
                    + "Gardez F comme repère principal pour retrouver rapidement la position de votre main."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "Main droite",
                texte:
                    "Avec la main droite, vous allez utiliser les touches de repos H, J, K, la touche elle et la touche aime "
                    + "et descendre vers la touche N avec l’index droit.\n"
                    + "Gardez J comme repère principal pour retrouver rapidement la position de votre main."
            ),
            LessonStepDefinition(
                id: 4,
                titre: "Objectif de la leçon",
                texte:
                    "Les deux premiers exercices vous guident pour alterner entre les deux rangées.\n"
                    + "À partir du troisième exercice, les consignes deviennent plus courtes "
                    + "afin de laisser vos automatismes prendre le relais."
            )
        ],
        exercices: [
            TypingExerciseDefinition(
                id: 1,
                texteAttendu: "fw",
                instruction:
                    "Tapez F sur la rangée de repos, puis la touche W sur la rangée inférieure. "
                    + "Revenez ensuite sur F.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 2,
                texteAttendu: "jn",
                instruction:
                    "Tapez J sur la rangée de repos, puis la touche N avec l’index droit. "
                    + "Revenez ensuite sur J.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 3,
                texteAttendu: "qwsxdc",
                instruction:
                    "Tapez Q, W, S, X, D, puis C.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 4,
                texteAttendu: "fvgbhn",
                instruction:
                    "Tapez F, V, G, B, H, puis N.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 5,
                texteAttendu: "njbmhk",
                instruction:
                    "Tapez N, J, B, la touche aime, H, puis K.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 6,
                texteAttendu: "qwsxdcfvgbhnjklm",
                instruction:
                    "Pour terminer, tapez Q, W, S, X, D, C, F, V, G, B, H, N, J, K, "
                    + "la touche elle, puis la touche aime.",
                modeLecture: .epeler
            )
        ],
        resumeFinal:
            "Félicitations. Vous avez appris à alterner entre la rangée de repos et la rangée inférieure. "
            + "Vous avez renforcé vos repères sur F et J tout en retrouvant les touches situées plus bas. "
            + "La prochaine leçon réunira les trois rangées du clavier."
    )


    static let module4Lecon6 = LessonDefinition(
        id: 23,
        titre: "Leçon 6",
        sousTitre: "Consolidation générale des trois rangées",
        introduction:
            "Vous voici dans la dernière leçon du module 4. "
            + "Vous allez maintenant utiliser ensemble toutes les lettres apprises sur les trois rangées du clavier. "
            + "L’objectif est de passer naturellement d’une rangée à l’autre tout en conservant vos repères sur F et J.",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Vos repères",
                texte:
                    "Placez vos index sur F et J avant de commencer.\n"
                    + "Ces deux touches restent vos principaux repères lorsque vos doigts se déplacent vers le haut ou vers le bas."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Les trois rangées",
                texte:
                    "Vous allez alterner entre la rangée supérieure, la rangée de repos et la rangée inférieure.\n"
                    + "Prenez le temps de retrouver chaque touche avec le bon doigt avant de valider votre saisie."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "Objectif final",
                texte:
                    "Les deux premiers exercices vous accompagnent encore dans le passage entre les trois rangées.\n"
                    + "À partir du troisième exercice, les consignes deviennent plus courtes et les lettres sont davantage mélangées.\n"
                    + "La précision reste plus importante que la vitesse."
            )
        ],
        exercices: [
            TypingExerciseDefinition(
                id: 1,
                texteAttendu: "ftrv",
                instruction:
                    "Depuis votre repère F, tapez F, puis T sur la rangée supérieure, R sur la rangée supérieure, "
                    + "et V sur la rangée inférieure. Revenez ensuite sur F.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 2,
                texteAttendu: "juin",
                instruction:
                    "Depuis votre repère J, tapez J, puis la lettre U sur la rangée supérieure, "
                    + "I sur la rangée supérieure et N sur la rangée inférieure. Revenez ensuite sur J.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 3,
                texteAttendu: "azqwsx",
                instruction:
                    "Tapez A, Z, Q, W, S, puis X.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 4,
                texteAttendu: "edcrfvtg",
                instruction:
                    "Tapez E, D, C, R, F, V, T, puis G.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 5,
                texteAttendu: "yhjnuikm",
                instruction:
                    "Tapez la touche Y, H, J, N, la lettre U, I, K, puis la touche aime.",
                modeLecture: .epeler
            ),
            TypingExerciseDefinition(
                id: 6,
                texteAttendu: "azqwsxedcrfvtgbyhnjuiklopm",
                instruction:
                    "Pour terminer, tapez A, Z, Q, W, S, X, E, D, C, R, F, V, T, G, B, "
                    + "la touche Y, H, N, J, la lettre U, I, K, la touche elle, O, P, puis la touche aime.",
                modeLecture: .epeler
            )
        ],
        resumeFinal:
            "Bravo. Vous avez terminé la consolidation générale des trois rangées du clavier. "
            + "Vous avez révisé toutes les lettres apprises et renforcé votre capacité à passer d’une rangée à l’autre. "
            + "Vous êtes maintenant prêt à mettre ces acquis en pratique. "
            + "Dans le prochain module, vous commencerez à taper des mots courts en utilisant les lettres que vous avez apprises."
    )


    // MARK: - Module 5 : Les mots courts

    static let module5Lecon1 = LessonDefinition(
        id: 24,
        titre: "Leçon 1",
        sousTitre: "Les animaux",
        introduction:
            "Bienvenue dans le module 5. "
            + "Vous allez maintenant utiliser les lettres apprises dans les modules précédents "
            + "pour taper vos premiers mots courts. "
            + "Dans cette première leçon, les mots appartiennent au thème des animaux.",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Former un mot",
                texte:
                    "Jusqu’à présent, vous avez surtout travaillé avec des lettres et des suites de lettres.\n"
                    + "Vous allez maintenant les enchaîner pour former un mot complet."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Conserver vos repères",
                texte:
                    "Gardez F et J comme repères tactiles et utilisez le doigt associé à chaque lettre.\n"
                    + "Après chaque déplacement, laissez vos mains retrouver naturellement la position de repos."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "Un mot par exercice",
                texte:
                    "Chaque exercice contient un seul mot.\n"
                    + "Prenez le temps de le taper correctement avant de valider votre réponse."
            ),
            LessonStepDefinition(
                id: 4,
                titre: "Objectif de la leçon",
                texte:
                    "Vous allez taper six mots courts sur le thème des animaux.\n"
                    + "La précision reste plus importante que la vitesse."
            )
        ],
        exercices: [
            TypingExerciseDefinition(
                id: 1,
                texteAttendu: "rat",
                instruction:
                    "Tapez le mot rat.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 2,
                texteAttendu: "coq",
                instruction:
                    "Tapez le mot coq.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 3,
                texteAttendu: "chat",
                instruction:
                    "Tapez le mot chat.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 4,
                texteAttendu: "lion",
                instruction:
                    "Tapez le mot lion.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 5,
                texteAttendu: "ours",
                instruction:
                    "Tapez le mot ours.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 6,
                texteAttendu: "tigre",
                instruction:
                    "Tapez le mot tigre.",
                modeLecture: .lireNaturellement
            )
        ],
        resumeFinal:
            "Bravo. Vous avez tapé vos premiers mots courts sur le thème des animaux. "
            + "Vous avez commencé à enchaîner les lettres pour former des mots complets "
            + "tout en conservant vos repères sur le clavier."
    )

    static let module5Lecon2 = LessonDefinition(
        id: 25,
        titre: "Leçon 2",
        sousTitre: "Les transports",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Les transports",
                texte:
                    "Place maintenant aux mots courts sur le thème des transports."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Objectif de la leçon",
                texte:
                    "Vous allez taper six mots courts sur le thème des transports.\n"
                    + "Conservez vos repères et validez chaque mot seulement lorsqu’il est complet."
            )
        ],
        exercices: [
            TypingExerciseDefinition(
                id: 1,
                texteAttendu: "bus",
                instruction:
                    "Tapez le mot bus.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 2,
                texteAttendu: "car",
                instruction:
                    "Tapez le mot car.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 3,
                texteAttendu: "taxi",
                instruction:
                    "Tapez le mot taxi.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 4,
                texteAttendu: "moto",
                instruction:
                    "Tapez le mot moto.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 5,
                texteAttendu: "train",
                instruction:
                    "Tapez le mot train.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 6,
                texteAttendu: "avion",
                instruction:
                    "Tapez le mot avion.",
                modeLecture: .lireNaturellement
            )
        ],
        resumeFinal:
            "Très bien. Vous avez tapé six mots courts sur le thème des transports. "
            + "Vous avez continué à enchaîner les lettres tout en passant d’une rangée du clavier à l’autre."
    )

    static let module5Lecon3 = LessonDefinition(
        id: 26,
        titre: "Leçon 3",
        sousTitre: "Les aliments",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Les aliments",
                texte:
                    "Cette fois-ci, tapons des mots courts sur le thème des aliments."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Objectif de la leçon",
                texte:
                    "Vous allez taper six mots courts sur le thème des aliments.\n"
                    + "Votre objectif reste de former chaque mot avec précision."
            )
        ],
        exercices: [
            TypingExerciseDefinition(
                id: 1,
                texteAttendu: "riz",
                instruction:
                    "Tapez le mot riz.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 2,
                texteAttendu: "pain",
                instruction:
                    "Tapez le mot pain.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 3,
                texteAttendu: "lait",
                instruction:
                    "Tapez le mot lait.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 4,
                texteAttendu: "kiwi",
                instruction:
                    "Tapez le mot kiwi.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 5,
                texteAttendu: "melon",
                instruction:
                    "Tapez le mot melon.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 6,
                texteAttendu: "soupe",
                instruction:
                    "Tapez le mot soupe.",
                modeLecture: .lireNaturellement
            )
        ],
        resumeFinal:
            "Beau travail. Vous avez tapé six mots courts sur le thème des aliments. "
            + "Vous avez renforcé votre capacité à former un mot complet avec des lettres réparties sur plusieurs rangées."
    )

    static let module5Lecon4 = LessonDefinition(
        id: 27,
        titre: "Leçon 4",
        sousTitre: "La maison et les objets",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "La maison et les objets",
                texte:
                    "Découvrons maintenant des mots courts liés à la maison et aux objets du quotidien."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Objectif de la leçon",
                texte:
                    "Vous allez taper six mots courts liés à la maison et aux objets.\n"
                    + "Restez précis et gardez les mains détendues."
            )
        ],
        exercices: [
            TypingExerciseDefinition(
                id: 1,
                texteAttendu: "lit",
                instruction:
                    "Tapez le mot lit.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 2,
                texteAttendu: "bol",
                instruction:
                    "Tapez le mot bol.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 3,
                texteAttendu: "sac",
                instruction:
                    "Tapez le mot sac.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 4,
                texteAttendu: "vase",
                instruction:
                    "Tapez le mot vase.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 5,
                texteAttendu: "porte",
                instruction:
                    "Tapez le mot porte.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 6,
                texteAttendu: "tapis",
                instruction:
                    "Tapez le mot tapis.",
                modeLecture: .lireNaturellement
            )
        ],
        resumeFinal:
            "Très bien. Vous avez tapé six mots courts liés à la maison et aux objets. "
            + "Vos déplacements entre les rangées deviennent progressivement plus naturels."
    )

    static let module5Lecon5 = LessonDefinition(
        id: 28,
        titre: "Leçon 5",
        sousTitre: "La nature",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "La nature",
                texte:
                    "Au tour de la nature de nous fournir de nouveaux mots courts."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Objectif de la leçon",
                texte:
                    "Vous allez taper six mots courts sur le thème de la nature.\n"
                    + "Formez chaque mot complètement avant de le valider."
            )
        ],
        exercices: [
            TypingExerciseDefinition(
                id: 1,
                texteAttendu: "mer",
                instruction:
                    "Tapez le mot mer.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 2,
                texteAttendu: "lac",
                instruction:
                    "Tapez le mot lac.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 3,
                texteAttendu: "air",
                instruction:
                    "Tapez le mot air.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 4,
                texteAttendu: "bois",
                instruction:
                    "Tapez le mot bois.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 5,
                texteAttendu: "arbre",
                instruction:
                    "Tapez le mot arbre.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 6,
                texteAttendu: "pluie",
                instruction:
                    "Tapez le mot pluie.",
                modeLecture: .lireNaturellement
            )
        ],
        resumeFinal:
            "Félicitations. Vous avez tapé six mots courts sur le thème de la nature. "
            + "Vous savez maintenant former des mots variés tout en conservant vos repères sur les trois rangées."
    )

    static let module5Lecon6 = LessonDefinition(
        id: 29,
        titre: "Leçon 6",
        sousTitre: "Consolidation des mots courts",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Consolidation des mots courts",
                texte:
                    "Terminons ce module en consolidant les mots courts rencontrés dans les différentes leçons."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Conserver vos repères",
                texte:
                    "Retrouvez F et J comme repères tactiles et gardez les mains détendues. "
                    + "Prenez votre temps : la précision reste plus importante que la vitesse."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "Objectif de consolidation",
                texte:
                    "Vous allez retaper six mots courts issus des leçons précédentes.\n"
                    + "Concentrez-vous sur la précision, la régularité et le bon placement des doigts."
            )
        ],
        exercices: [
            TypingExerciseDefinition(
                id: 1,
                texteAttendu: "chat",
                instruction:
                    "Tapez le mot chat.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 2,
                texteAttendu: "train",
                instruction:
                    "Tapez le mot train.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 3,
                texteAttendu: "melon",
                instruction:
                    "Tapez le mot melon.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 4,
                texteAttendu: "porte",
                instruction:
                    "Tapez le mot porte.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 5,
                texteAttendu: "arbre",
                instruction:
                    "Tapez le mot arbre.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 6,
                texteAttendu: "tigre",
                instruction:
                    "Tapez le mot tigre.",
                modeLecture: .lireNaturellement
            )
        ],
        resumeFinal:
            "Bravo. Vous avez terminé le module 5 consacré aux premiers mots courts. "
            + "Vous savez maintenant enchaîner les lettres pour former un mot complet "
            + "tout en conservant vos repères et votre précision. "
            + "Dans le prochain module, vous pourrez progressivement travailler avec des mots plus longs."
    )

    // MARK: - Module 6 : Les mots longs

    static let module6Lecon1 = LessonDefinition(
        id: 30,
        titre: "Leçon 1",
        sousTitre: "Les prénoms",
        introduction:
            "Bienvenue dans le module 6. Vous allez maintenant travailler avec des mots plus longs. Dans cette première leçon, vous allez taper des prénoms.",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Taper des mots plus longs",
                texte:
                    "Chaque exercice contient toujours un seul mot.\n"
                    + "La nouveauté vient de la longueur des mots : vous devez maintenir vos repères pendant davantage de caractères."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Conserver vos repères",
                texte:
                    "Gardez F et J comme repères tactiles et laissez chaque doigt rejoindre la touche qui lui correspond.\n"
                    + "Après un déplacement, retrouvez naturellement la position de repos."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "Précision avant vitesse",
                texte:
                    "Écoutez le mot en entier avant de commencer à le taper.\n"
                    + "Ne cherchez pas à accélérer volontairement : privilégiez une frappe régulière et précise."
            ),
            LessonStepDefinition(
                id: 4,
                titre: "Objectif de la leçon",
                texte:
                    "Vous allez taper six prénoms de six à sept lettres. Ils sont volontairement écrits en minuscules, car les majuscules seront étudiées plus tard."
            )
        ],
        exercices: [
            TypingExerciseDefinition(
                id: 1,
                texteAttendu: "julien",
                instruction:
                    "Tapez le mot julien.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 2,
                texteAttendu: "marion",
                instruction:
                    "Tapez le mot marion.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 3,
                texteAttendu: "romain",
                instruction:
                    "Tapez le mot romain.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 4,
                texteAttendu: "sophie",
                instruction:
                    "Tapez le mot sophie.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 5,
                texteAttendu: "thomas",
                instruction:
                    "Tapez le mot thomas.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 6,
                texteAttendu: "nicolas",
                instruction:
                    "Tapez le mot nicolas.",
                modeLecture: .lireNaturellement
            )
        ],
        resumeFinal:
            "Bravo. Vous avez terminé la leçon des prénoms et commencé à maintenir une frappe précise sur des mots plus longs."
    )

    static let module6Lecon2 = LessonDefinition(
        id: 31,
        titre: "Leçon 2",
        sousTitre: "Les métiers",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Les métiers",
                texte:
                    "Place maintenant aux mots longs sur le thème des métiers."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Objectif de la leçon",
                texte:
                    "Vous allez taper six noms de métiers, jusqu’au mot journaliste. Gardez un geste régulier lorsque la longueur du mot augmente."
            )
        ],
        exercices: [
            TypingExerciseDefinition(
                id: 1,
                texteAttendu: "pilote",
                instruction:
                    "Tapez le mot pilote.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 2,
                texteAttendu: "artiste",
                instruction:
                    "Tapez le mot artiste.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 3,
                texteAttendu: "facteur",
                instruction:
                    "Tapez le mot facteur.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 4,
                texteAttendu: "pompier",
                instruction:
                    "Tapez le mot pompier.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 5,
                texteAttendu: "plombier",
                instruction:
                    "Tapez le mot plombier.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 6,
                texteAttendu: "journaliste",
                instruction:
                    "Tapez le mot journaliste.",
                modeLecture: .lireNaturellement
            )
        ],
        resumeFinal:
            "Très bien. Vous avez tapé six noms de métiers de longueurs variées et poursuivi votre travail sur les mots plus longs."
    )

    static let module6Lecon3 = LessonDefinition(
        id: 32,
        titre: "Leçon 3",
        sousTitre: "Dans la maison",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Dans la maison",
                texte:
                    "Les objets de la maison vont maintenant servir à travailler des mots plus longs."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Objectif de la leçon",
                texte:
                    "Vous allez taper six mots liés à la maison, de chaise à couverture. La précision reste plus importante que la vitesse."
            )
        ],
        exercices: [
            TypingExerciseDefinition(
                id: 1,
                texteAttendu: "chaise",
                instruction:
                    "Tapez le mot chaise.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 2,
                texteAttendu: "spatule",
                instruction:
                    "Tapez le mot spatule.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 3,
                texteAttendu: "coussin",
                instruction:
                    "Tapez le mot coussin.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 4,
                texteAttendu: "cartable",
                instruction:
                    "Tapez le mot cartable.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 5,
                texteAttendu: "bouteille",
                instruction:
                    "Tapez le mot bouteille.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 6,
                texteAttendu: "couverture",
                instruction:
                    "Tapez le mot couverture.",
                modeLecture: .lireNaturellement
            )
        ],
        resumeFinal:
            "Beau travail. Vous avez tapé six mots liés à la maison, avec une longueur allant progressivement jusqu’à dix lettres."
    )

    static let module6Lecon4 = LessonDefinition(
        id: 33,
        titre: "Leçon 4",
        sousTitre: "La nature et les paysages",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "La nature et les paysages",
                texte:
                    "Direction la nature et les paysages pour de nouveaux mots longs."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Objectif de la leçon",
                texte:
                    "Vous allez taper six mots liés à la nature et aux paysages. Conservez vos repères sur les trois rangées."
            )
        ],
        exercices: [
            TypingExerciseDefinition(
                id: 1,
                texteAttendu: "jardin",
                instruction:
                    "Tapez le mot jardin.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 2,
                texteAttendu: "soleil",
                instruction:
                    "Tapez le mot soleil.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 3,
                texteAttendu: "rivage",
                instruction:
                    "Tapez le mot rivage.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 4,
                texteAttendu: "prairie",
                instruction:
                    "Tapez le mot prairie.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 5,
                texteAttendu: "cascade",
                instruction:
                    "Tapez le mot cascade.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 6,
                texteAttendu: "falaise",
                instruction:
                    "Tapez le mot falaise.",
                modeLecture: .lireNaturellement
            )
        ],
        resumeFinal:
            "Très bien. Vous avez tapé six mots liés à la nature et aux paysages tout en maintenant vos repères et votre précision."
    )

    static let module6Lecon5 = LessonDefinition(
        id: 34,
        titre: "Leçon 5",
        sousTitre: "La technologie",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "La technologie",
                texte:
                    "La technologie prend maintenant le relais avec une nouvelle série de mots longs."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Objectif de la leçon",
                texte:
                    "Vous allez taper six mots liés à la technologie, jusqu’à application. Prenez votre temps sur les séquences les plus longues."
            )
        ],
        exercices: [
            TypingExerciseDefinition(
                id: 1,
                texteAttendu: "clavier",
                instruction:
                    "Tapez le mot clavier.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 2,
                texteAttendu: "internet",
                instruction:
                    "Tapez le mot internet.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 3,
                texteAttendu: "tablette",
                instruction:
                    "Tapez le mot tablette.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 4,
                texteAttendu: "logiciel",
                instruction:
                    "Tapez le mot logiciel.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 5,
                texteAttendu: "smartphone",
                instruction:
                    "Tapez le mot smartphone.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 6,
                texteAttendu: "application",
                instruction:
                    "Tapez le mot application.",
                modeLecture: .lireNaturellement
            )
        ],
        resumeFinal:
            "Félicitations. Vous avez tapé six mots liés à la technologie, dont smartphone et application. Vous savez maintenant maintenir votre frappe sur des mots nettement plus longs."
    )

    static let module6Lecon6 = LessonDefinition(
        id: 35,
        titre: "Leçon 6",
        sousTitre: "Consolidation des mots longs",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Consolidation des mots longs",
                texte:
                    "Terminons ce module en consolidant les mots longs avec des mots connus et des mots nouveaux."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Conserver vos repères",
                texte:
                    "Retrouvez F et J comme repères tactiles et gardez les mains détendues. "
                    + "Prenez votre temps : la précision reste plus importante que la vitesse."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "Objectif de la leçon",
                texte:
                    "Vous allez taper six mots longs provenant de plusieurs thèmes. Certains sont connus et d’autres sont nouveaux afin de vérifier que vous savez transférer vos acquis."
            )
        ],
        exercices: [
            TypingExerciseDefinition(
                id: 1,
                texteAttendu: "nicolas",
                instruction:
                    "Tapez le mot nicolas.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 2,
                texteAttendu: "pompier",
                instruction:
                    "Tapez le mot pompier.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 3,
                texteAttendu: "village",
                instruction:
                    "Tapez le mot village.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 4,
                texteAttendu: "cartable",
                instruction:
                    "Tapez le mot cartable.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 5,
                texteAttendu: "ordinateur",
                instruction:
                    "Tapez le mot ordinateur.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 6,
                texteAttendu: "application",
                instruction:
                    "Tapez le mot application.",
                modeLecture: .lireNaturellement
            )
        ],
        resumeFinal:
            "Bravo. Vous avez terminé le module 6 consacré aux mots plus longs. Vous avez travaillé des mots connus et nouveaux tout en maintenant votre précision sur des séquences plus longues. Dans le prochain module, vous apprendrez à enchaîner plusieurs mots dans un même exercice, tout en conservant votre précision et vos repères sur le clavier."
    )

    // MARK: - Module 7 : Les mots enchaînés

    static let module7Lecon1 = LessonDefinition(
        id: 36,
        titre: "Leçon 1",
        sousTitre: "Les loisirs",
        introduction:
            "Bienvenue dans le module 7, Les mots enchaînés.",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "",
                texte:
                    "Pour commencer, nous allons apprendre à enchaîner plusieurs mots sur le thème des loisirs, en les séparant par un espace."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "La barre d’espace",
                texte:
                    "Petit rappel : pour séparer deux mots, appuyez une fois sur la barre d’espace avec le pouce. "
                    + "Ne l’utilisez pas au début ni à la fin de votre réponse."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "Garder un rythme régulier",
                texte:
                    "Continuez à utiliser F et J comme repères tactiles et gardez les mains détendues.\n"
                    + "La précision reste plus importante que la vitesse."
            ),
            LessonStepDefinition(
                id: 4,
                titre: "Objectif de la leçon",
                texte:
                    "Vous allez taper six enchaînements de deux mots en saisissant un espace entre les deux mots."
            )
        ],
        exercices: [
            TypingExerciseDefinition(
                id: 1,
                texteAttendu: "yoyo puzzle",
                instruction:
                    "Tapez : yoyo puzzle.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 2,
                texteAttendu: "radio dessin",
                instruction:
                    "Tapez : radio dessin.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 3,
                texteAttendu: "photo domino",
                instruction:
                    "Tapez : photo domino.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 4,
                texteAttendu: "lecture piano",
                instruction:
                    "Tapez : lecture piano.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 5,
                texteAttendu: "danse album",
                instruction:
                    "Tapez : danse album.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 6,
                texteAttendu: "jouet ballon",
                instruction:
                    "Tapez : jouet ballon.",
                modeLecture: .lireNaturellement
            )
        ],
        resumeFinal:
            "Bravo. Vous avez appris à enchaîner deux mots dans un même exercice en utilisant la barre d’espace entre les mots."
    )

    static let module7Lecon2 = LessonDefinition(
        id: 37,
        titre: "Leçon 2",
        sousTitre: "Les vêtements",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Les vêtements",
                texte:
                    "Place maintenant aux enchaînements sur le thème des vêtements."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Objectif de la leçon",
                texte:
                    "Vous allez taper six enchaînements de deux mots sur le thème des vêtements, avec un espace entre les deux mots."
            )
        ],
        exercices: [
            TypingExerciseDefinition(
                id: 1,
                texteAttendu: "polo short",
                instruction:
                    "Tapez : polo short.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 2,
                texteAttendu: "pull pyjama",
                instruction:
                    "Tapez : pull pyjama.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 3,
                texteAttendu: "bonnet pantalon",
                instruction:
                    "Tapez : bonnet pantalon.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 4,
                texteAttendu: "chemise blouson",
                instruction:
                    "Tapez : chemise blouson.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 5,
                texteAttendu: "chausson maillot",
                instruction:
                    "Tapez : chausson maillot.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 6,
                texteAttendu: "sandale costume",
                instruction:
                    "Tapez : sandale costume.",
                modeLecture: .lireNaturellement
            )
        ],
        resumeFinal:
            "Très bien. Vous avez consolidé l’enchaînement de deux mots avec du vocabulaire lié aux vêtements."
    )

    static let module7Lecon3 = LessonDefinition(
        id: 38,
        titre: "Leçon 3",
        sousTitre: "Le sport",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Le sport",
                texte:
                    "Cette fois-ci, enchaînons des mots sur le thème du sport."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Objectif de la leçon",
                texte:
                    "Vous allez taper six enchaînements de trois mots sur le thème du sport, avec un espace entre chaque mot."
            )
        ],
        exercices: [
            TypingExerciseDefinition(
                id: 1,
                texteAttendu: "judo tennis rugby",
                instruction:
                    "Tapez : judo tennis rugby.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 2,
                texteAttendu: "kayak foot golf",
                instruction:
                    "Tapez : kayak foot golf.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 3,
                texteAttendu: "boxe surf basket",
                instruction:
                    "Tapez : boxe surf basket.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 4,
                texteAttendu: "course volley ski",
                instruction:
                    "Tapez : course volley ski.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 5,
                texteAttendu: "hockey ballon sprint",
                instruction:
                    "Tapez : hockey ballon sprint.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 6,
                texteAttendu: "natation fitness bowling",
                instruction:
                    "Tapez : natation fitness bowling.",
                modeLecture: .lireNaturellement
            )
        ],
        resumeFinal:
            "Beau travail. Vous savez maintenant enchaîner trois mots dans un même exercice tout en conservant votre précision."
    )

    static let module7Lecon4 = LessonDefinition(
        id: 39,
        titre: "Leçon 4",
        sousTitre: "Les voyages",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Les voyages",
                texte:
                    "Prenons maintenant la route avec des enchaînements sur le thème des voyages."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Objectif de la leçon",
                texte:
                    "Vous allez taper six enchaînements de trois mots sur le thème des voyages, avec un espace entre chaque mot."
            )
        ],
        exercices: [
            TypingExerciseDefinition(
                id: 1,
                texteAttendu: "wagon taxi avion",
                instruction:
                    "Tapez : wagon taxi avion.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 2,
                texteAttendu: "voyage train bateau",
                instruction:
                    "Tapez : voyage train bateau.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 3,
                texteAttendu: "route valise motel",
                instruction:
                    "Tapez : route valise motel.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 4,
                texteAttendu: "tunnel pilote bus",
                instruction:
                    "Tapez : tunnel pilote bus.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 5,
                texteAttendu: "camping navire port",
                instruction:
                    "Tapez : camping navire port.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 6,
                texteAttendu: "billet voyageur bagage",
                instruction:
                    "Tapez : billet voyageur bagage.",
                modeLecture: .lireNaturellement
            )
        ],
        resumeFinal:
            "Très bien. Vous avez continué à travailler des enchaînements de trois mots avec le thème des voyages."
    )

    static let module7Lecon5 = LessonDefinition(
        id: 40,
        titre: "Leçon 5",
        sousTitre: "L’espace",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "L’espace",
                texte:
                    "Direction l’espace pour de nouveaux enchaînements de mots."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Objectif de la leçon",
                texte:
                    "Vous allez taper des enchaînements sur le thème de l’espace : trois mots au début, puis quatre mots en fin de leçon, avec un espace entre chaque mot."
            )
        ],
        exercices: [
            TypingExerciseDefinition(
                id: 1,
                texteAttendu: "lune mars terre",
                instruction:
                    "Tapez : lune mars terre.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 2,
                texteAttendu: "jupiter saturne uranus",
                instruction:
                    "Tapez : jupiter saturne uranus.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 3,
                texteAttendu: "neptune pluton soleil",
                instruction:
                    "Tapez : neptune pluton soleil.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 4,
                texteAttendu: "espace orbite astronaute",
                instruction:
                    "Tapez : espace orbite astronaute.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 5,
                texteAttendu: "galaxie cosmos univers capsule",
                instruction:
                    "Tapez : galaxie cosmos univers capsule.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 6,
                texteAttendu: "satellite module station spatial",
                instruction:
                    "Tapez : satellite module station spatial.",
                modeLecture: .lireNaturellement
            )
        ],
        resumeFinal:
            "Félicitations. Vous avez réussi des enchaînements de trois puis quatre mots sur le thème de l’espace."
    )

    static let module7Lecon6 = LessonDefinition(
        id: 41,
        titre: "Leçon 6",
        sousTitre: "Consolidation",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Consolidation",
                texte:
                    "Terminons avec la consolidation des enchaînements, en reprenant les différents thèmes du module."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Garder un rythme régulier",
                texte:
                    "Continuez à utiliser F et J comme repères tactiles et gardez les mains détendues.\n"
                    + "La précision reste plus importante que la vitesse."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "Objectif de la leçon",
                texte:
                    "Vous allez consolider l’enchaînement de plusieurs mots avec deux, trois puis quatre mots selon les exercices, avec un espace entre chaque mot."
            )
        ],
        exercices: [
            TypingExerciseDefinition(
                id: 1,
                texteAttendu: "yoyo pyjama",
                instruction:
                    "Tapez : yoyo pyjama.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 2,
                texteAttendu: "rugby wagon clavier",
                instruction:
                    "Tapez : rugby wagon clavier.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 3,
                texteAttendu: "kayak voyage saturne",
                instruction:
                    "Tapez : kayak voyage saturne.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 4,
                texteAttendu: "puzzle pantalon jupiter",
                instruction:
                    "Tapez : puzzle pantalon jupiter.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 5,
                texteAttendu: "smartphone ballon astronaute neptune",
                instruction:
                    "Tapez : smartphone ballon astronaute neptune.",
                modeLecture: .lireNaturellement
            ),
            TypingExerciseDefinition(
                id: 6,
                texteAttendu: "ordinateur chemise cosmos application",
                instruction:
                    "Tapez : ordinateur chemise cosmos application.",
                modeLecture: .lireNaturellement
            )
        ],
        resumeFinal:
            "Bravo. Vous avez terminé le module 7 consacré à l’enchaînement de plusieurs mots. Vous savez maintenant saisir plusieurs mots séparés par des espaces dans un même exercice. Dans le module 8, vous découvrirez les majuscules et apprendrez à utiliser les touches permettant de les saisir."
    )


    // MARK: - Module 8 : Les majuscules

    static let module8Lecon1 = LessonDefinition(
        id: 42,
        titre: "Leçon 1",
        sousTitre: "Découvrir les majuscules",
        introduction:
            "Bienvenue dans le module 8.",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Les majuscules",
                texte:
                    "Dans ce module, vous allez apprendre à taper des lettres majuscules. "
                    + "Pour commencer, nous allons découvrir les deux touches Majuscule et apprendre à les utiliser avec la main opposée à celle qui tape la lettre."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "La touche Majuscule gauche",
                texte:
                    "La touche Majuscule gauche se trouve sous la touche Verrouillage des majuscules, elle-même située à gauche de la lettre Q. "
                    + "Maintenez cette touche avec l’auriculaire gauche lorsque vous tapez une lettre avec la main droite."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "La touche Majuscule droite",
                texte:
                    "Pour trouver la touche Majuscule droite, partez de la lettre M avec l’auriculaire droit, puis descendez en diagonale vers la droite jusqu’à la grande touche Majuscule. "
                    + "Maintenez cette touche lorsque vous tapez une lettre avec la main gauche."
            ),
            LessonStepDefinition(
                id: 4,
                titre: "Le bon geste",
                texte:
                    "Maintenez la touche Majuscule avec l’auriculaire de la main opposée, tapez la lettre avec l’autre main, puis relâchez la touche Majuscule."
            ),
            LessonStepDefinition(
                id: 5,
                titre: "Objectif de la leçon",
                texte:
                    "Vous allez taper six lettres en majuscule. "
                    + "Pour chaque lettre, utilisez la touche Majuscule située du côté opposé à la main qui tape la lettre. "
            )
        ],
        exercices: [
            TypingExerciseDefinition(id: 1, texteAttendu: "J", instruction: "Tapez la lettre J en majuscule.", modeLecture: .epeler),
            TypingExerciseDefinition(id: 2, texteAttendu: "F", instruction: "Tapez la lettre F en majuscule.", modeLecture: .epeler),
            TypingExerciseDefinition(id: 3, texteAttendu: "K", instruction: "Tapez la lettre K en majuscule.", modeLecture: .epeler),
            TypingExerciseDefinition(id: 4, texteAttendu: "D", instruction: "Tapez la lettre D en majuscule.", modeLecture: .epeler),
            TypingExerciseDefinition(id: 5, texteAttendu: "L", instruction: "Tapez la lettre L en majuscule.", modeLecture: .epeler),
            TypingExerciseDefinition(id: 6, texteAttendu: "S", instruction: "Tapez la lettre S en majuscule.", modeLecture: .epeler)
        ],
        resumeFinal:
            "Bravo. Vous avez découvert les deux touches Majuscule et appris à utiliser la main opposée pour taper une lettre majuscule."
    )

    static let module8Lecon2 = LessonDefinition(
        id: 43,
        titre: "Leçon 2",
        sousTitre: "La rangée de repos",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "La rangée de repos",
                texte:
                    "Nous allons maintenant travailler les majuscules sur la rangée de repos."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Choisir la bonne touche",
                texte:
                    "Pour une lettre tapée avec la main droite, maintenez Majuscule gauche. "
                    + "Pour une lettre tapée avec la main gauche, maintenez Majuscule droite."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "Objectif de la leçon",
                texte:
                    "Vous allez taper six lettres majuscules de la rangée de repos en alternant les deux mains. "
            )
        ],
        exercices: [
            TypingExerciseDefinition(id: 1, texteAttendu: "Q", instruction: "Tapez la lettre Q en majuscule.", modeLecture: .epeler),
            TypingExerciseDefinition(id: 2, texteAttendu: "M", instruction: "Tapez la lettre M en majuscule.", modeLecture: .epeler),
            TypingExerciseDefinition(id: 3, texteAttendu: "F", instruction: "Tapez la lettre F en majuscule.", modeLecture: .epeler),
            TypingExerciseDefinition(id: 4, texteAttendu: "J", instruction: "Tapez la lettre J en majuscule.", modeLecture: .epeler),
            TypingExerciseDefinition(id: 5, texteAttendu: "G", instruction: "Tapez la lettre G en majuscule.", modeLecture: .epeler),
            TypingExerciseDefinition(id: 6, texteAttendu: "H", instruction: "Tapez la lettre H en majuscule.", modeLecture: .epeler)
        ],
        resumeFinal:
            "Très bien. Vous savez maintenant utiliser les deux touches Majuscule avec les lettres de la rangée de repos."
    )

    static let module8Lecon3 = LessonDefinition(
        id: 44,
        titre: "Leçon 3",
        sousTitre: "La rangée supérieure",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "La rangée supérieure",
                texte:
                    "Passons maintenant aux lettres majuscules de la rangée supérieure."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Garder le bon geste",
                texte:
                    "Gardez la main qui tape la lettre disponible et maintenez la touche Majuscule avec l’auriculaire de la main opposée."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "Objectif de la leçon",
                texte:
                    "Vous allez taper six lettres majuscules de la rangée supérieure en utilisant alternativement les deux touches Majuscule. "
            )
        ],
        exercices: [
            TypingExerciseDefinition(id: 1, texteAttendu: "A", instruction: "Tapez la lettre A en majuscule.", modeLecture: .epeler),
            TypingExerciseDefinition(id: 2, texteAttendu: "U", instruction: "Tapez la lettre U en majuscule.", modeLecture: .epeler),
            TypingExerciseDefinition(id: 3, texteAttendu: "R", instruction: "Tapez la lettre R en majuscule.", modeLecture: .epeler),
            TypingExerciseDefinition(id: 4, texteAttendu: "I", instruction: "Tapez la lettre I en majuscule.", modeLecture: .epeler),
            TypingExerciseDefinition(id: 5, texteAttendu: "T", instruction: "Tapez la lettre T en majuscule.", modeLecture: .epeler),
            TypingExerciseDefinition(id: 6, texteAttendu: "Y", instruction: "Tapez la lettre Y en majuscule.", modeLecture: .epeler)
        ],
        resumeFinal:
            "Bravo. Vous savez maintenant taper des lettres majuscules sur la rangée supérieure en choisissant la touche Majuscule opposée."
    )

    static let module8Lecon4 = LessonDefinition(
        id: 45,
        titre: "Leçon 4",
        sousTitre: "La rangée inférieure",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "La rangée inférieure",
                texte:
                    "Descendons maintenant sur la rangée inférieure pour travailler les lettres majuscules."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Changer de côté",
                texte:
                    "Avant chaque lettre, repérez la main qui doit la taper, puis utilisez la touche Majuscule de l’autre côté."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "Objectif de la leçon",
                texte:
                    "Vous allez taper six lettres majuscules de la rangée inférieure en utilisant les deux mains. "
            )
        ],
        exercices: [
            TypingExerciseDefinition(id: 1, texteAttendu: "W", instruction: "Tapez la lettre W en majuscule.", modeLecture: .epeler),
            TypingExerciseDefinition(id: 2, texteAttendu: "N", instruction: "Tapez la lettre N en majuscule.", modeLecture: .epeler),
            TypingExerciseDefinition(id: 3, texteAttendu: "X", instruction: "Tapez la lettre X en majuscule.", modeLecture: .epeler),
            TypingExerciseDefinition(id: 4, texteAttendu: "V", instruction: "Tapez la lettre V en majuscule.", modeLecture: .epeler),
            TypingExerciseDefinition(id: 5, texteAttendu: "C", instruction: "Tapez la lettre C en majuscule.", modeLecture: .epeler),
            TypingExerciseDefinition(id: 6, texteAttendu: "B", instruction: "Tapez la lettre B en majuscule.", modeLecture: .epeler)
        ],
        resumeFinal:
            "Très bien. Vous savez maintenant appliquer la technique des majuscules aux lettres de la rangée inférieure."
    )

    static let module8Lecon5 = LessonDefinition(
        id: 46,
        titre: "Leçon 5",
        sousTitre: "Les trois rangées",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Les trois rangées",
                texte:
                    "Mélangeons maintenant des lettres majuscules provenant des trois rangées du clavier."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "À vous de choisir",
                texte:
                    "Pour chaque lettre, déterminez d’abord quelle main doit la taper, puis utilisez la touche Majuscule opposée."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "Objectif de la leçon",
                texte:
                    "Vous allez taper six lettres majuscules choisies dans les trois rangées du clavier. "
            )
        ],
        exercices: [
            TypingExerciseDefinition(id: 1, texteAttendu: "D", instruction: "Tapez la lettre D en majuscule.", modeLecture: .epeler),
            TypingExerciseDefinition(id: 2, texteAttendu: "P", instruction: "Tapez la lettre P en majuscule.", modeLecture: .epeler),
            TypingExerciseDefinition(id: 3, texteAttendu: "C", instruction: "Tapez la lettre C en majuscule.", modeLecture: .epeler),
            TypingExerciseDefinition(id: 4, texteAttendu: "K", instruction: "Tapez la lettre K en majuscule.", modeLecture: .epeler),
            TypingExerciseDefinition(id: 5, texteAttendu: "E", instruction: "Tapez la lettre E en majuscule.", modeLecture: .epeler),
            TypingExerciseDefinition(id: 6, texteAttendu: "N", instruction: "Tapez la lettre N en majuscule.", modeLecture: .epeler)
        ],
        resumeFinal:
            "Bravo. Vous savez maintenant choisir la bonne touche Majuscule avec des lettres provenant des trois rangées."
    )

    static let module8Lecon6 = LessonDefinition(
        id: 47,
        titre: "Leçon 6",
        sousTitre: "Consolidation",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Consolidation",
                texte:
                    "Terminons ce module en mélangeant les lettres des trois rangées."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Conserver vos repères",
                texte:
                    "Gardez les mains détendues et retrouvez F et J comme repères tactiles. "
                    + "Pour chaque majuscule, utilisez la touche Majuscule avec l’auriculaire de la main opposée."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "Objectif de la leçon",
                texte:
                    "Vous allez taper six lettres majuscules provenant de l’ensemble du clavier alphabétique. "
                    + "Choisissez vous-même la touche Majuscule adaptée."
            )
        ],
        exercices: [
            TypingExerciseDefinition(id: 1, texteAttendu: "S", instruction: "Tapez la lettre S en majuscule.", modeLecture: .epeler),
            TypingExerciseDefinition(id: 2, texteAttendu: "O", instruction: "Tapez la lettre O en majuscule.", modeLecture: .epeler),
            TypingExerciseDefinition(id: 3, texteAttendu: "Z", instruction: "Tapez la lettre Z en majuscule.", modeLecture: .epeler),
            TypingExerciseDefinition(id: 4, texteAttendu: "L", instruction: "Tapez la lettre L en majuscule.", modeLecture: .epeler),
            TypingExerciseDefinition(id: 5, texteAttendu: "R", instruction: "Tapez la lettre R en majuscule.", modeLecture: .epeler),
            TypingExerciseDefinition(id: 6, texteAttendu: "V", instruction: "Tapez la lettre V en majuscule.", modeLecture: .epeler)
        ],
        resumeFinal:
            "Bravo. Vous avez terminé le module 8 consacré aux majuscules. "
            + "Vous savez maintenant utiliser les deux touches Majuscule avec les lettres des trois rangées. "
            + "Dans le module 9, vous utiliserez cette technique pour taper des mots dont la première lettre est en majuscule."
    )


    // MARK: - Module 9 : Les mots avec une majuscule

    static let module9Lecon1 = LessonDefinition(
        id: 48,
        titre: "Leçon 1",
        sousTitre: "Premiers mots avec une majuscule",
        introduction:
            "Bienvenue dans le module 9.",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Les mots avec une majuscule",
                texte:
                    "Dans ce module, vous allez apprendre à taper des mots dont la première lettre est en majuscule. "
                    + "Vous utiliserez la technique apprise dans le module précédent, puis vous continuerez le mot en minuscules."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Relâcher la touche Majuscule",
                texte:
                    "Maintenez la touche Majuscule avec la main opposée à celle qui tape la première lettre. "
                    + "Après avoir tapé cette lettre, relâchez la touche Majuscule et poursuivez normalement avec les lettres suivantes."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "Objectif de la leçon",
                texte:
                    "Vous allez taper six mots commençant par une majuscule."
            )
        ],
        exercices: [
            TypingExerciseDefinition(id: 1, texteAttendu: "Chat", instruction: "Tapez le mot Chat.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 2, texteAttendu: "Lune", instruction: "Tapez le mot Lune.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 3, texteAttendu: "Rose", instruction: "Tapez le mot Rose.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 4, texteAttendu: "Moto", instruction: "Tapez le mot Moto.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 5, texteAttendu: "Film", instruction: "Tapez le mot Film.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 6, texteAttendu: "Vache", instruction: "Tapez le mot Vache.", modeLecture: .lireNaturellement)
        ],
        resumeFinal:
            "Bravo. Vous savez maintenant commencer un mot par une majuscule, puis poursuivre sa saisie en minuscules."
    )

    static let module9Lecon2 = LessonDefinition(
        id: 49,
        titre: "Leçon 2",
        sousTitre: "Les prénoms courts",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Les prénoms courts",
                texte:
                    "Place maintenant aux prénoms courts, qui commencent eux aussi par une majuscule."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Objectif de la leçon",
                texte:
                    "Vous allez taper six prénoms courts en utilisant la touche Majuscule adaptée pour leur première lettre."
            )
        ],
        exercices: [
            TypingExerciseDefinition(id: 1, texteAttendu: "Paul", instruction: "Tapez le prénom Paul.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 2, texteAttendu: "Lina", instruction: "Tapez le prénom Lina.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 3, texteAttendu: "Hugo", instruction: "Tapez le prénom Hugo.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 4, texteAttendu: "Emma", instruction: "Tapez le prénom Emma.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 5, texteAttendu: "Noah", instruction: "Tapez le prénom Noah.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 6, texteAttendu: "Lucas", instruction: "Tapez le prénom Lucas.", modeLecture: .lireNaturellement)
        ],
        resumeFinal:
            "Très bien. Vous savez maintenant appliquer la majuscule initiale à des prénoms courts."
    )

    static let module9Lecon3 = LessonDefinition(
        id: 50,
        titre: "Leçon 3",
        sousTitre: "Les prénoms plus longs",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Les prénoms plus longs",
                texte:
                    "Cette fois-ci, entraînez-vous avec des prénoms plus longs."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Objectif de la leçon",
                texte:
                    "Vous allez taper six prénoms plus longs en conservant une majuscule uniquement au début du mot."
            )
        ],
        exercices: [
            TypingExerciseDefinition(id: 1, texteAttendu: "Alexandre", instruction: "Tapez le prénom Alexandre.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 2, texteAttendu: "Dominique", instruction: "Tapez le prénom Dominique.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 3, texteAttendu: "Valentin", instruction: "Tapez le prénom Valentin.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 4, texteAttendu: "Tanguy", instruction: "Tapez le prénom Tanguy.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 5, texteAttendu: "Maxime", instruction: "Tapez le prénom Maxime.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 6, texteAttendu: "Baptiste", instruction: "Tapez le prénom Baptiste.", modeLecture: .lireNaturellement)
        ],
        resumeFinal:
            "Bravo. Vous savez maintenant garder la majuscule initiale tout en poursuivant avec plusieurs lettres minuscules."
    )

    static let module9Lecon4 = LessonDefinition(
        id: 51,
        titre: "Leçon 4",
        sousTitre: "Les villes",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Les villes",
                texte:
                    "Passons maintenant à des noms de villes, qui commencent par une majuscule."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Objectif de la leçon",
                texte:
                    "Vous allez taper six noms de villes avec une majuscule au début."
            )
        ],
        exercices: [
            TypingExerciseDefinition(id: 1, texteAttendu: "Paris", instruction: "Tapez Paris.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 2, texteAttendu: "Nantes", instruction: "Tapez Nantes.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 3, texteAttendu: "Lyon", instruction: "Tapez Lyon.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 4, texteAttendu: "Tours", instruction: "Tapez Tours.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 5, texteAttendu: "Rouen", instruction: "Tapez Rouen.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 6, texteAttendu: "Toulon", instruction: "Tapez Toulon.", modeLecture: .lireNaturellement)
        ],
        resumeFinal:
            "Très bien. Vous savez maintenant utiliser une majuscule au début d’un nom de ville."
    )

    static let module9Lecon5 = LessonDefinition(
        id: 52,
        titre: "Leçon 5",
        sousTitre: "Les noms propres",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Les noms propres",
                texte:
                    "Mélangeons maintenant différents noms propres commençant par une majuscule."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Objectif de la leçon",
                texte:
                    "Vous allez taper six noms propres variés et choisir vous-même la touche Majuscule adaptée."
            )
        ],
        exercices: [
            TypingExerciseDefinition(id: 1, texteAttendu: "France", instruction: "Tapez France.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 2, texteAttendu: "Europe", instruction: "Tapez Europe.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 3, texteAttendu: "Jupiter", instruction: "Tapez Jupiter.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 4, texteAttendu: "Saturne", instruction: "Tapez Saturne.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 5, texteAttendu: "Canada", instruction: "Tapez Canada.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 6, texteAttendu: "Martin", instruction: "Tapez Martin.", modeLecture: .lireNaturellement)
        ],
        resumeFinal:
            "Bravo. Vous savez maintenant appliquer la majuscule initiale à différents noms propres."
    )

    static let module9Lecon6 = LessonDefinition(
        id: 53,
        titre: "Leçon 6",
        sousTitre: "Consolidation",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Consolidation",
                texte:
                    "Terminons ce module avec un mélange de mots courts et plus longs commençant par une majuscule."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Relâcher la touche Majuscule",
                texte:
                    "Utilisez la touche Majuscule opposée à la main qui tape la première lettre, puis relâchez-la pour poursuivre le mot en minuscules."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "Objectif de la leçon",
                texte:
                    "Vous allez taper six mots variés avec une majuscule au début, en choisissant vous-même la touche adaptée."
            )
        ],
        exercices: [
            TypingExerciseDefinition(id: 1, texteAttendu: "Nature", instruction: "Tapez Nature.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 2, texteAttendu: "Julien", instruction: "Tapez Julien.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 3, texteAttendu: "Paris", instruction: "Tapez Paris.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 4, texteAttendu: "Jupiter", instruction: "Tapez Jupiter.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 5, texteAttendu: "Camille", instruction: "Tapez Camille.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 6, texteAttendu: "France", instruction: "Tapez France.", modeLecture: .lireNaturellement)
        ],
        resumeFinal:
            "Bravo. Vous avez terminé le module 9 consacré aux mots avec une majuscule. "
            + "Vous savez maintenant commencer un mot par une majuscule puis poursuivre en minuscules. "
            + "Dans le module 10, vous combinerez cette technique avec plusieurs mots séparés par des espaces."
    )


    // MARK: - Module 10 : Les mots enchaînés avec des majuscules

    static let module10Lecon1 = LessonDefinition(
        id: 54,
        titre: "Leçon 1",
        sousTitre: "Les légumes",
        introduction:
            "Bienvenue dans le module 10, Les mots enchaînés : majuscules et espaces.",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Pour commencer",
                texte:
                    "Dans ce module, chaque mot commencera par une majuscule et les mots seront séparés par un espace. "
                    + "Vous allez ainsi combiner les techniques apprises dans les modules précédents."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Combiner les deux gestes",
                texte:
                    "Après avoir terminé un mot, insérez un espace. "
                    + "Commencez ensuite le mot suivant par une majuscule, puis poursuivez normalement avec les lettres suivantes."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "Objectif de la leçon",
                texte:
                    "Vous allez taper six enchaînements de deux mots sur le thème des légumes. "
                    + "Chaque mot commence par une majuscule et les deux mots sont séparés par un espace."
            )
        ],
        exercices: [
            TypingExerciseDefinition(id: 1, texteAttendu: "Poireau Carotte", instruction: "Tapez : Poireau Carotte.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 2, texteAttendu: "Navet Radis", instruction: "Tapez : Navet Radis.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 3, texteAttendu: "Tomate Courgette", instruction: "Tapez : Tomate Courgette.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 4, texteAttendu: "Potiron Concombre", instruction: "Tapez : Potiron Concombre.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 5, texteAttendu: "Chou Endive", instruction: "Tapez : Chou Endive.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 6, texteAttendu: "Oignon Salade", instruction: "Tapez : Oignon Salade.", modeLecture: .lireNaturellement)
        ],
        resumeFinal:
            "Bravo. Vous savez maintenant enchaîner deux mots commençant par une majuscule et les séparer par un espace."
    )

    static let module10Lecon2 = LessonDefinition(
        id: 55,
        titre: "Leçon 2",
        sousTitre: "Les fruits",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Les fruits",
                texte:
                    "Au tour des fruits de servir de thème à de nouveaux enchaînements."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Objectif de la leçon",
                texte:
                    "Vous allez taper six enchaînements de deux mots. "
                    + "Chaque mot commence par une majuscule et les deux mots sont séparés par un espace."
            )
        ],
        exercices: [
            TypingExerciseDefinition(id: 1, texteAttendu: "Banane Pomme", instruction: "Tapez : Banane Pomme.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 2, texteAttendu: "Citron Ananas", instruction: "Tapez : Citron Ananas.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 3, texteAttendu: "Mangue Prune", instruction: "Tapez : Mangue Prune.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 4, texteAttendu: "Abricot Papaye", instruction: "Tapez : Abricot Papaye.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 5, texteAttendu: "Avocat Figue", instruction: "Tapez : Avocat Figue.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 6, texteAttendu: "Cerise Cassis", instruction: "Tapez : Cerise Cassis.", modeLecture: .lireNaturellement)
        ],
        resumeFinal:
            "Très bien. Vous savez maintenant enchaîner plusieurs mots avec des majuscules sur un nouveau thème."
    )

    static let module10Lecon3 = LessonDefinition(
        id: 56,
        titre: "Leçon 3",
        sousTitre: "Les animaux",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Les animaux",
                texte:
                    "Cette fois-ci, vous allez enchaîner trois mots sur le thème des animaux."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Objectif de la leçon",
                texte:
                    "Vous allez taper six enchaînements de trois mots. "
                    + "Chaque mot commence par une majuscule et les mots sont séparés par un espace."
            )
        ],
        exercices: [
            TypingExerciseDefinition(id: 1, texteAttendu: "Biche Panda Koala", instruction: "Tapez : Biche Panda Koala.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 2, texteAttendu: "Girafe Tortue Dauphin", instruction: "Tapez : Girafe Tortue Dauphin.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 3, texteAttendu: "Castor Bison Lama", instruction: "Tapez : Castor Bison Lama.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 4, texteAttendu: "Gorille Renard Requin", instruction: "Tapez : Gorille Renard Requin.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 5, texteAttendu: "Cochon Taureau Poisson", instruction: "Tapez : Cochon Taureau Poisson.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 6, texteAttendu: "Mouton Lapin Cheval", instruction: "Tapez : Mouton Lapin Cheval.", modeLecture: .lireNaturellement)
        ],
        resumeFinal:
            "Bravo. Vous savez maintenant enchaîner trois mots en conservant les majuscules et les espaces."
    )

    static let module10Lecon4 = LessonDefinition(
        id: 57,
        titre: "Leçon 4",
        sousTitre: "Les couleurs",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Les couleurs",
                texte:
                    "Passons à présent à des enchaînements de trois mots sur le thème des couleurs."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Objectif de la leçon",
                texte:
                    "Vous allez taper six enchaînements de trois couleurs. "
                    + "Chaque mot commence par une majuscule et les mots sont séparés par un espace."
            )
        ],
        exercices: [
            TypingExerciseDefinition(id: 1, texteAttendu: "Rouge Jaune Vert", instruction: "Tapez : Rouge Jaune Vert.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 2, texteAttendu: "Bleu Noir Blanc", instruction: "Tapez : Bleu Noir Blanc.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 3, texteAttendu: "Gris Orange Violet", instruction: "Tapez : Gris Orange Violet.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 4, texteAttendu: "Turquoise Marron Beige", instruction: "Tapez : Turquoise Marron Beige.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 5, texteAttendu: "Pourpre Mauve Kaki", instruction: "Tapez : Pourpre Mauve Kaki.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 6, texteAttendu: "Ocre Saumon Bronze", instruction: "Tapez : Ocre Saumon Bronze.", modeLecture: .lireNaturellement)
        ],
        resumeFinal:
            "Très bien. Vous avez poursuivi les enchaînements avec trois mots et des initiales majuscules."
    )

    static let module10Lecon5 = LessonDefinition(
        id: 58,
        titre: "Leçon 5",
        sousTitre: "Les fournitures",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Les fournitures",
                texte:
                    "Passons maintenant à des enchaînements sur le thème des fournitures."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Objectif de la leçon",
                texte:
                    "Vous allez taper six enchaînements de trois mots. "
                    + "Chaque mot commence par une majuscule et les mots sont séparés par un espace."
            )
        ],
        exercices: [
            TypingExerciseDefinition(id: 1, texteAttendu: "Stylo Gomme Trousse", instruction: "Tapez : Stylo Gomme Trousse.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 2, texteAttendu: "Ciseaux Surligneur Cahier", instruction: "Tapez : Ciseaux Surligneur Cahier.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 3, texteAttendu: "Pinceau Feutre Crayon", instruction: "Tapez : Pinceau Feutre Crayon.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 4, texteAttendu: "Agenda Colle Compas", instruction: "Tapez : Agenda Colle Compas.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 5, texteAttendu: "Ardoise Papier Dossier", instruction: "Tapez : Ardoise Papier Dossier.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 6, texteAttendu: "Pochette Bloc Carton", instruction: "Tapez : Pochette Bloc Carton.", modeLecture: .lireNaturellement)
        ],
        resumeFinal:
            "Bravo. Vous savez maintenant conserver les majuscules et les espaces dans des enchaînements plus longs."
    )

    static let module10Lecon6 = LessonDefinition(
        id: 59,
        titre: "Leçon 6",
        sousTitre: "Consolidation",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Consolidation",
                texte:
                    "Terminons ce module en mélangeant les thèmes précédents et quelques mots nouveaux."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Objectif de la leçon",
                texte:
                    "Vous allez taper des enchaînements de deux à quatre mots en combinant tous les acquis du module."
            )
        ],
        exercices: [
            TypingExerciseDefinition(id: 1, texteAttendu: "Serpent Cercle", instruction: "Tapez : Serpent Cercle.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 2, texteAttendu: "Hexagone Carotte Banane", instruction: "Tapez : Hexagone Carotte Banane.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 3, texteAttendu: "Rectangle Panda Stylo", instruction: "Tapez : Rectangle Panda Stylo.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 4, texteAttendu: "Losange Turquoise Concombre", instruction: "Tapez : Losange Turquoise Concombre.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 5, texteAttendu: "Ovale Abricot Dauphin Ciseaux", instruction: "Tapez : Ovale Abricot Dauphin Ciseaux.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 6, texteAttendu: "Poireau Mangue Violet Pinceau", instruction: "Tapez : Poireau Mangue Violet Pinceau.", modeLecture: .lireNaturellement)
        ],
        resumeFinal:
            "Bravo. Vous avez terminé le module 10 consacré aux mots enchaînés avec des majuscules. "
            + "Vous savez maintenant combiner les majuscules et les espaces dans des groupes de plusieurs mots. "
            + "Dans le module 11, vous découvrirez les accents."
    )


    // MARK: - Module 11 : Les lettres accentuées

    static let module11Lecon1 = LessonDefinition(
        id: 60,
        titre: "Leçon 1",
        sousTitre: "Le E accent aigu et le E accent grave",
        introduction:
            "Bienvenue dans le module 11, Les lettres accentuées.",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Pour commencer",
                texte:
                    "Dans ce module, vous allez apprendre à saisir différentes lettres accentuées ainsi que le C cédille."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Le E accent aigu",
                texte:
                    "Pour trouver le E accent aigu, placez l’auriculaire gauche sur la touche Q. "
                    + "Déplacez légèrement le doigt vers le haut et vers la gauche pour atteindre la lettre A. "
                    + "Depuis la lettre A, poursuivez légèrement vers le haut et vers la droite pour atteindre la touche E accent aigu. Ce mouvement forme un petit demi-cercle."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "Le E accent aigu majuscule",
                texte:
                    "Pour saisir un E accent aigu majuscule, activez d’abord le Verrouillage majuscule, situé à gauche de la lettre Q. "
                    + "Sans VoiceOver, appuyez une fois sur cette touche. Avec VoiceOver, appuyez rapidement deux fois dessus. "
                    + "Appuyez ensuite sur la touche E accent aigu. "
                    + "Lorsque vous avez terminé, désactivez le Verrouillage majuscule de la même manière pour revenir aux minuscules."
            ),
            LessonStepDefinition(
                id: 4,
                titre: "Le E accent grave",
                texte:
                    "Placez l’index droit sur la lettre J. Déplacez-le en diagonale vers le haut et vers la gauche jusqu’à la lettre U, "
                    + "puis continuez dans la même direction pour atteindre la touche E accent grave."
            ),
            LessonStepDefinition(
                id: 5,
                titre: "Objectif de la leçon",
                texte:
                    "Vous allez vous entraîner à saisir le E accent aigu, le E accent aigu majuscule et le E accent grave, seuls puis mélangés."
            )
        ],
        exercices: [
            TypingExerciseDefinition(id: 1, texteAttendu: "é", instruction: "Tapez le E accent aigu. Depuis la touche Q, déplacez légèrement l’auriculaire gauche vers le haut et vers la gauche pour atteindre la lettre A. Depuis la lettre A, poursuivez légèrement vers le haut et vers la droite pour atteindre la touche E accent aigu. Ce mouvement forme un petit demi-cercle.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 2, texteAttendu: "É", instruction: "Tapez le E accent aigu majuscule. Activez le Verrouillage majuscule : appuyez une fois sur cette touche sans VoiceOver, ou rapidement deux fois avec VoiceOver. Appuyez ensuite sur la touche E accent aigu, puis désactivez le Verrouillage majuscule de la même manière pour revenir aux minuscules.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 3, texteAttendu: "è", instruction: "Tapez le E accent grave. Depuis sa position de repos, déplacez l’index droit en diagonale vers le haut et vers la gauche jusqu’à la lettre U, puis continuez dans la même direction pour atteindre la touche E accent grave.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 4, texteAttendu: "é É", instruction: "Tapez le E accent aigu, puis le E accent aigu majuscule.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 5, texteAttendu: "É è", instruction: "Tapez le E accent aigu majuscule, puis le E accent grave.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 6, texteAttendu: "é É è", instruction: "Tapez le E accent aigu, le E accent aigu majuscule, puis le E accent grave.", modeLecture: .lireNaturellement)
        ],
        resumeFinal:
            "Bravo. Vous savez maintenant saisir le E accent aigu en minuscule et en majuscule, ainsi que le E accent grave."
    )

    static let module11Lecon2 = LessonDefinition(
        id: 61,
        titre: "Leçon 2",
        sousTitre: "Le A accent grave et le U accent grave",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Pour commencer",
                texte:
                    "Place maintenant au A accent grave, au A accent grave majuscule et au U accent grave."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Le A accent grave",
                texte:
                    "Depuis sa position de repos, déplacez l’annulaire droit verticalement vers le haut. "
                    + "Passez au-dessus de la rangée supérieure et continuez dans la même direction pour atteindre la touche A accent grave."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "Le A accent grave majuscule",
                texte:
                    "Pour saisir un A accent grave majuscule, activez d’abord le Verrouillage majuscule, situé à gauche de la lettre Q. "
                    + "Sans VoiceOver, appuyez une fois sur cette touche. Avec VoiceOver, appuyez rapidement deux fois dessus. "
                    + "Appuyez ensuite sur la touche A accent grave. "
                    + "Lorsque vous avez terminé, désactivez le Verrouillage majuscule de la même manière pour revenir aux minuscules."
            ),
            LessonStepDefinition(
                id: 4,
                titre: "Le U accent grave",
                texte:
                    "Placez l’auriculaire droit sur la touche M, puis déplacez-le légèrement vers la droite. "
                    + "La touche située juste à côté de M est la touche U accent grave."
            ),
            LessonStepDefinition(
                id: 5,
                titre: "Objectif de la leçon",
                texte:
                    "Vous allez vous entraîner à saisir le A accent grave en minuscule et en majuscule, ainsi que le U accent grave."
            )
        ],
        exercices: [
            TypingExerciseDefinition(id: 1, texteAttendu: "à", instruction: "Tapez le A accent grave. Depuis sa position de repos, déplacez l’annulaire droit verticalement vers le haut, passez au-dessus de la rangée supérieure et continuez dans la même direction jusqu’à la touche A accent grave.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 2, texteAttendu: "À", instruction: "Tapez le A accent grave majuscule. Activez le Verrouillage majuscule : appuyez une fois sur cette touche sans VoiceOver, ou rapidement deux fois avec VoiceOver. Appuyez ensuite sur la touche A accent grave, puis désactivez le Verrouillage majuscule de la même manière pour revenir aux minuscules.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 3, texteAttendu: "ù", instruction: "Tapez le U accent grave. Depuis la touche M, déplacez légèrement l’auriculaire droit vers la droite pour atteindre la touche U accent grave.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 4, texteAttendu: "à À", instruction: "Tapez le A accent grave, puis le A accent grave majuscule.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 5, texteAttendu: "À ù", instruction: "Tapez le A accent grave majuscule, puis le U accent grave.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 6, texteAttendu: "à À ù", instruction: "Tapez le A accent grave, le A accent grave majuscule, puis le U accent grave.", modeLecture: .lireNaturellement)
        ],
        resumeFinal:
            "Très bien. Vous savez maintenant saisir le A accent grave en minuscule et en majuscule, ainsi que le U accent grave."
    )

    static let module11Lecon3 = LessonDefinition(
        id: 62,
        titre: "Leçon 3",
        sousTitre: "Le C cédille",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Pour commencer",
                texte:
                    "Découvrons maintenant comment saisir le C cédille en minuscule et en majuscule."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Le C cédille",
                texte:
                    "Depuis sa position de repos, déplacez le majeur droit verticalement vers le haut. "
                    + "Passez au-dessus de la rangée supérieure et continuez dans la même direction pour atteindre la touche C cédille."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "Le C cédille majuscule",
                texte:
                    "Pour saisir un C cédille majuscule, activez d’abord le Verrouillage majuscule, situé à gauche de la lettre Q. "
                    + "Sans VoiceOver, appuyez une fois sur cette touche. Avec VoiceOver, appuyez rapidement deux fois dessus. "
                    + "Appuyez ensuite sur la touche C cédille. "
                    + "Lorsque vous avez terminé, désactivez le Verrouillage majuscule de la même manière pour revenir aux minuscules."
            ),
            LessonStepDefinition(
                id: 4,
                titre: "Objectif de la leçon",
                texte:
                    "Vous allez vous entraîner à saisir le C cédille en minuscule et en majuscule, puis à le retrouver parmi les lettres accentuées déjà apprises."
            )
        ],
        exercices: [
            TypingExerciseDefinition(id: 1, texteAttendu: "ç", instruction: "Tapez le C cédille. Depuis sa position de repos, déplacez le majeur droit verticalement vers le haut, passez au-dessus de la rangée supérieure et continuez dans la même direction jusqu’à la touche C cédille.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 2, texteAttendu: "Ç", instruction: "Tapez le C cédille majuscule. Activez le Verrouillage majuscule : appuyez une fois sur cette touche sans VoiceOver, ou rapidement deux fois avec VoiceOver. Appuyez ensuite sur la touche C cédille, puis désactivez le Verrouillage majuscule de la même manière pour revenir aux minuscules.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 3, texteAttendu: "ç Ç", instruction: "Tapez le C cédille, puis le C cédille majuscule.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 4, texteAttendu: "é ç", instruction: "Tapez le E accent aigu, puis le C cédille.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 5, texteAttendu: "À Ç ù", instruction: "Tapez le A accent grave majuscule, le C cédille majuscule, puis le U accent grave.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 6, texteAttendu: "é è à À ù ç Ç", instruction: "Tapez le E accent aigu, le E accent grave, le A accent grave, le A accent grave majuscule, le U accent grave, le C cédille, puis le C cédille majuscule.", modeLecture: .lireNaturellement)
        ],
        resumeFinal:
            "Bravo. Vous savez maintenant saisir le C cédille en minuscule et en majuscule et le retrouver parmi les caractères déjà appris."
    )

    static let module11Lecon4 = LessonDefinition(
        id: 63,
        titre: "Leçon 4",
        sousTitre: "L’accent circonflexe",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Pour commencer",
                texte:
                    "Passons à l’accent circonflexe et à son utilisation avec les cinq voyelles."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "La touche accent circonflexe",
                texte:
                    "Depuis sa position de repos, déplacez l’auriculaire droit en diagonale vers le haut et légèrement vers la droite. "
                    + "La touche accent circonflexe se trouve à droite de la lettre P."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "Utiliser l’accent circonflexe",
                texte:
                    "Appuyez une fois sur la touche accent circonflexe, puis relâchez-la. "
                    + "Appuyez ensuite sur la voyelle que vous souhaitez accentuer. "
                    + "Par exemple, pour écrire E accent circonflexe, appuyez une fois sur la touche accent circonflexe, puis sur la lettre E."
            ),
            LessonStepDefinition(
                id: 4,
                titre: "Objectif de la leçon",
                texte:
                    "La même méthode permet d’écrire les cinq voyelles avec un accent circonflexe : A accent circonflexe, E accent circonflexe, I accent circonflexe, O accent circonflexe et U accent circonflexe."
            )
        ],
        exercices: [
            TypingExerciseDefinition(id: 1, texteAttendu: "â", instruction: "Tapez le A accent circonflexe. Déplacez l’auriculaire droit en diagonale vers le haut et légèrement vers la droite, appuyez une fois sur la touche accent circonflexe, relâchez-la, puis tapez la lettre A.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 2, texteAttendu: "ê", instruction: "Tapez le E accent circonflexe. Déplacez l’auriculaire droit en diagonale vers le haut et légèrement vers la droite, appuyez une fois sur la touche accent circonflexe, relâchez-la, puis tapez la lettre E.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 3, texteAttendu: "î", instruction: "Tapez le I accent circonflexe.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 4, texteAttendu: "ô", instruction: "Tapez le O accent circonflexe.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 5, texteAttendu: "û", instruction: "Tapez le U accent circonflexe.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 6, texteAttendu: "É â À ê Ç î ô û", instruction: "Tapez le E accent aigu majuscule, le A accent circonflexe, le A accent grave majuscule, le E accent circonflexe, le C cédille majuscule, le I accent circonflexe, le O accent circonflexe, puis le U accent circonflexe.", modeLecture: .lireNaturellement)
        ],
        resumeFinal:
            "Très bien. Vous savez maintenant utiliser la touche accent circonflexe avec les cinq voyelles."
    )

    static let module11Lecon5 = LessonDefinition(
        id: 64,
        titre: "Leçon 5",
        sousTitre: "Le tréma",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Pour commencer",
                texte:
                    "Au tour du tréma : vous allez apprendre à l’ajouter aux cinq voyelles."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Utiliser le tréma",
                texte:
                    "Maintenez la touche Majuscule enfoncée. "
                    + "Tout en maintenant Majuscule, appuyez une fois sur la touche accent circonflexe. "
                    + "Relâchez ensuite la touche Majuscule, puis appuyez sur la voyelle à laquelle vous souhaitez ajouter le tréma."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "Un exemple",
                texte:
                    "Pour écrire E tréma, maintenez la touche Majuscule enfoncée et appuyez une fois sur la touche accent circonflexe. "
                    + "Relâchez Majuscule, puis appuyez sur la lettre E."
            ),
            LessonStepDefinition(
                id: 4,
                titre: "Objectif de la leçon",
                texte:
                    "La même méthode permet d’écrire les cinq voyelles avec un tréma : A tréma, E tréma, I tréma, O tréma et U tréma."
            )
        ],
        exercices: [
            TypingExerciseDefinition(id: 1, texteAttendu: "ä", instruction: "Tapez le A tréma. Maintenez la touche Majuscule enfoncée, appuyez une fois sur la touche accent circonflexe, relâchez Majuscule, puis tapez la lettre A.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 2, texteAttendu: "ë", instruction: "Tapez le E tréma. Maintenez la touche Majuscule enfoncée, appuyez une fois sur la touche accent circonflexe, relâchez Majuscule, puis tapez la lettre E.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 3, texteAttendu: "ï", instruction: "Tapez le I tréma.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 4, texteAttendu: "ö", instruction: "Tapez le O tréma.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 5, texteAttendu: "ü", instruction: "Tapez le U tréma.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 6, texteAttendu: "É ä À ë Ç ï ö ü", instruction: "Tapez le E accent aigu majuscule, le A tréma, le A accent grave majuscule, le E tréma, le C cédille majuscule, le I tréma, le O tréma, puis le U tréma.", modeLecture: .lireNaturellement)
        ],
        resumeFinal:
            "Bravo. Vous savez maintenant saisir les cinq voyelles avec un tréma."
    )

    static let module11Lecon6 = LessonDefinition(
        id: 65,
        titre: "Leçon 6",
        sousTitre: "Consolidation",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Consolidation",
                texte:
                    "Dans cette dernière leçon, vous allez retrouver toutes les lettres accentuées apprises dans ce module, ainsi que le C cédille."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Objectif de la leçon",
                texte:
                    "Les exercices mélangent maintenant les différents caractères. "
                    + "Prenez le temps de retrouver le bon geste pour chacun d’eux."
            )
        ],
        exercices: [
            TypingExerciseDefinition(id: 1, texteAttendu: "é É è à À ù ç Ç", instruction: "Tapez le E accent aigu, le E accent aigu majuscule, le E accent grave, le A accent grave, le A accent grave majuscule, le U accent grave, le C cédille, puis le C cédille majuscule.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 2, texteAttendu: "â ê î ô û", instruction: "Tapez le A accent circonflexe, le E accent circonflexe, le I accent circonflexe, le O accent circonflexe, puis le U accent circonflexe.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 3, texteAttendu: "ä ë ï ö ü", instruction: "Tapez le A tréma, le E tréma, le I tréma, le O tréma, puis le U tréma.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 4, texteAttendu: "É â è ê À ä", instruction: "Tapez le E accent aigu majuscule, le A accent circonflexe, le E accent grave, le E accent circonflexe, le A accent grave majuscule, puis le A tréma.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 5, texteAttendu: "ù û ü ç Ç ô ö", instruction: "Tapez le U accent grave, le U accent circonflexe, le U tréma, le C cédille, le C cédille majuscule, le O accent circonflexe, puis le O tréma.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 6, texteAttendu: "é É è à À ù ç Ç â ê î ô û ä ë ï ö ü", instruction: "Tapez le E accent aigu, le E accent aigu majuscule, le E accent grave, le A accent grave, le A accent grave majuscule, le U accent grave, le C cédille, le C cédille majuscule, le A accent circonflexe, le E accent circonflexe, le I accent circonflexe, le O accent circonflexe, le U accent circonflexe, le A tréma, le E tréma, le I tréma, le O tréma, puis le U tréma.", modeLecture: .lireNaturellement)
        ],
        resumeFinal:
            "Bravo. Vous avez terminé le module 11 consacré aux lettres accentuées. "
            + "Dans le module 12, vous utiliserez ces caractères dans de vrais mots."
    )

    // MARK: - Module 12 — Les mots accentués

    static let module12Lecon1 = LessonDefinition(
        id: 66,
        titre: "Leçon 1",
        sousTitre: "Objets du quotidien et fournitures",
        introduction:
            "Bienvenue dans le module 12, Les mots accentués.",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Pour commencer",
                texte:
                    "Dans cette première leçon, vous allez saisir des mots qui désignent des objets du quotidien ou des fournitures."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Des accents dans les mots",
                texte:
                    "Les caractères accentués peuvent se trouver au début, au milieu ou à la fin d’un mot. "
                    + "Prenez le temps de retrouver le bon caractère lorsque vous en rencontrez un."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "Objectif de la leçon",
                texte:
                    "Vous allez commencer par des mots qui désignent des objets du quotidien ou des fournitures. "
                    + "Chaque exercice contient un seul mot."
            )
        ],
        exercices: [
            TypingExerciseDefinition(id: 1, texteAttendu: "règle", instruction: "Tapez règle.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 2, texteAttendu: "équerre", instruction: "Tapez le mot équerre.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 3, texteAttendu: "étagère", instruction: "Tapez le mot étagère.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 4, texteAttendu: "téléphone", instruction: "Tapez téléphone.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 5, texteAttendu: "clé", instruction: "Tapez clé.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 6, texteAttendu: "poupée", instruction: "Tapez poupée.", modeLecture: .lireNaturellement)
        ],
        resumeFinal:
            "Très bien. Vous avez utilisé des lettres accentuées dans plusieurs noms d’objets et de fournitures."
    )

    static let module12Lecon2 = LessonDefinition(
        id: 67,
        titre: "Leçon 2",
        sousTitre: "Les métiers",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Les métiers",
                texte:
                    "Place maintenant aux noms de métiers."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Objectif de la leçon",
                texte:
                    "Les mots deviennent un peu plus longs. "
                    + "Concentrez-vous sur leur saisie complète et sur les accents qu’ils contiennent."
            )
        ],
        exercices: [
            TypingExerciseDefinition(id: 1, texteAttendu: "médecin", instruction: "Tapez médecin.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 2, texteAttendu: "ingénieur", instruction: "Tapez le mot ingénieur.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 3, texteAttendu: "électricien", instruction: "Tapez le mot électricien.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 4, texteAttendu: "mécanicien", instruction: "Tapez mécanicien.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 5, texteAttendu: "infirmière", instruction: "Tapez le mot infirmière.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 6, texteAttendu: "vétérinaire", instruction: "Tapez vétérinaire.", modeLecture: .lireNaturellement)
        ],
        resumeFinal:
            "Bravo. Vous savez maintenant retrouver les lettres accentuées dans des noms de métiers plus longs."
    )

    static let module12Lecon3 = LessonDefinition(
        id: 68,
        titre: "Leçon 3",
        sousTitre: "Les prénoms",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Les prénoms",
                texte:
                    "Cette fois-ci, place aux prénoms."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Objectif de la leçon",
                texte:
                    "Vous allez saisir plusieurs prénoms comportant des lettres accentuées ou un tréma."
            )
        ],
        exercices: [
            TypingExerciseDefinition(id: 1, texteAttendu: "Élodie", instruction: "Tapez le mot Élodie.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 2, texteAttendu: "Aurélien", instruction: "Tapez le mot Aurélien.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 3, texteAttendu: "Hélène", instruction: "Tapez Hélène.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 4, texteAttendu: "Loïc", instruction: "Tapez Loïc.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 5, texteAttendu: "Thérèse", instruction: "Tapez Thérèse.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 6, texteAttendu: "Anaïs", instruction: "Tapez le mot Anaïs.", modeLecture: .lireNaturellement)
        ],
        resumeFinal:
            "Très bien. Vous avez utilisé les majuscules avec plusieurs types d’accents et de trémas dans des prénoms."
    )

    static let module12Lecon4 = LessonDefinition(
        id: 69,
        titre: "Leçon 4",
        sousTitre: "La vie quotidienne",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "La vie quotidienne",
                texte:
                    "Passons maintenant aux mots de la vie quotidienne."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Objectif de la leçon",
                texte:
                    "Les accents sont maintenant intégrés naturellement aux mots. "
                    + "Essayez de les saisir sans interrompre votre rythme de frappe."
            )
        ],
        exercices: [
            TypingExerciseDefinition(id: 1, texteAttendu: "café", instruction: "Tapez café.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 2, texteAttendu: "journée", instruction: "Tapez journée.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 3, texteAttendu: "fenêtre", instruction: "Tapez fenêtre.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 4, texteAttendu: "lumière", instruction: "Tapez lumière.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 5, texteAttendu: "vêtement", instruction: "Tapez vêtement.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 6, texteAttendu: "télévision", instruction: "Tapez télévision.", modeLecture: .lireNaturellement)
        ],
        resumeFinal:
            "Bravo. Vous savez maintenant saisir naturellement des lettres accentuées dans des mots de la vie quotidienne."
    )

    static let module12Lecon5 = LessonDefinition(
        id: 70,
        titre: "Leçon 5",
        sousTitre: "Nature et animaux",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Nature et animaux",
                texte:
                    "Terminons cette progression avec des mots liés à la nature et aux animaux."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Objectif de la leçon",
                texte:
                    "Vous allez retrouver plusieurs accents différents, ainsi que le tréma, dans des mots variés."
            )
        ],
        exercices: [
            TypingExerciseDefinition(id: 1, texteAttendu: "forêt", instruction: "Tapez forêt.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 2, texteAttendu: "hérisson", instruction: "Tapez hérisson.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 3, texteAttendu: "écureuil", instruction: "Tapez le mot écureuil.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 4, texteAttendu: "araignée", instruction: "Tapez le mot araignée.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 5, texteAttendu: "guêpe", instruction: "Tapez guêpe.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 6, texteAttendu: "maïs", instruction: "Tapez maïs.", modeLecture: .lireNaturellement)
        ],
        resumeFinal:
            "Très bien. Vous avez utilisé des accents et un tréma dans différents mots liés à la nature et aux animaux."
    )

    static let module12Lecon6 = LessonDefinition(
        id: 71,
        titre: "Leçon 6",
        sousTitre: "Consolidation",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Consolidation",
                texte:
                    "Dans cette dernière leçon, vous allez retrouver les différents caractères accentués du module dans de nouveaux mots."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Objectif de la leçon",
                texte:
                    "Chaque exercice contient un mot différent. "
                    + "Utilisez les gestes appris dans le module précédent pour saisir les accents sans aide supplémentaire."
            )
        ],
        exercices: [
            TypingExerciseDefinition(id: 1, texteAttendu: "élève", instruction: "Tapez le mot élève.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 2, texteAttendu: "château", instruction: "Tapez château.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 3, texteAttendu: "français", instruction: "Tapez français.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 4, texteAttendu: "mûre", instruction: "Tapez mûre.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 5, texteAttendu: "noël", instruction: "Tapez noël.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 6, texteAttendu: "naïf", instruction: "Tapez naïf.", modeLecture: .lireNaturellement)
        ],
        resumeFinal:
            "Bravo. Vous avez terminé le module 12 consacré aux mots accentués. "
            + "Vous savez maintenant utiliser les lettres accentuées et le C cédille à l’intérieur de vrais mots. "
            + "Dans le prochain module, vous découvrirez les principaux signes de ponctuation et apprendrez à les saisir au clavier."
    )



    // MARK: - Module 13 — La ponctuation

    static let module13Lecon1 = LessonDefinition(
        id: 72,
        titre: "Leçon 1",
        sousTitre: "La virgule et le point d’interrogation",
        introduction:
            "Bienvenue dans le module 13, La ponctuation.",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "La virgule et le point d’interrogation",
                texte:
                    "Dans cette première leçon, vous allez découvrir deux signes qui partagent la même touche."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Trouver la touche",
                texte:
                    "Depuis sa position de repos, déplacez légèrement l’index de la main droite en diagonale vers le bas et vers la droite. "
                    + "Vous atteignez la touche située juste à droite de la lettre N. "
                    + "Appuyez sur cette touche pour saisir une virgule. "
                    + "Pour saisir un point d’interrogation, maintenez la touche Majuscule et appuyez sur cette même touche."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "Objectif de la leçon",
                texte:
                    "Vous allez vous entraîner à saisir la virgule et le point d’interrogation."
            )
        ],
        exercices: [
            TypingExerciseDefinition(id: 1, texteAttendu: ",", instruction: "Tapez une virgule. Déplacez légèrement l’index de la main droite en diagonale vers le bas et vers la droite, puis appuyez sur la touche.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 2, texteAttendu: "?", instruction: "Tapez un point d’interrogation. Effectuez le même déplacement avec l’index de la main droite, puis maintenez la touche Majuscule et appuyez sur la touche.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 3, texteAttendu: ", ?", instruction: "Tapez une virgule, puis un point d’interrogation.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 4, texteAttendu: "? ,", instruction: "Tapez un point d’interrogation, puis une virgule.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 5, texteAttendu: ", ? ,", instruction: "Tapez une virgule, un point d’interrogation, puis une virgule.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 6, texteAttendu: "? , ?", instruction: "Tapez un point d’interrogation, une virgule, puis un point d’interrogation.", modeLecture: .lireNaturellement)
        ],
        resumeFinal:
            "Bravo. Vous savez maintenant saisir la virgule et le point d’interrogation."
    )

    static let module13Lecon2 = LessonDefinition(
        id: 73,
        titre: "Leçon 2",
        sousTitre: "Le point-virgule et le point",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Le point-virgule et le point",
                texte:
                    "Deux nouveaux signes vous attendent : ils partagent eux aussi la même touche."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Trouver la touche",
                texte:
                    "Depuis sa position de repos, déplacez légèrement le majeur de la main droite en diagonale vers le bas et vers la droite. "
                    + "Appuyez sur cette touche pour saisir un point-virgule. "
                    + "Pour saisir un point, maintenez la touche Majuscule et appuyez sur cette même touche."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "Objectif de la leçon",
                texte:
                    "Vous allez alterner le point-virgule et le point afin de mémoriser leur touche commune."
            )
        ],
        exercices: [
            TypingExerciseDefinition(id: 1, texteAttendu: ";", instruction: "Tapez un point-virgule. Déplacez légèrement le majeur de la main droite en diagonale vers le bas et vers la droite, puis appuyez sur la touche.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 2, texteAttendu: ".", instruction: "Tapez un point. Effectuez le même déplacement avec le majeur de la main droite, puis maintenez la touche Majuscule et appuyez sur la touche.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 3, texteAttendu: "; .", instruction: "Tapez un point-virgule, puis un point.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 4, texteAttendu: ". ;", instruction: "Tapez un point, puis un point-virgule.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 5, texteAttendu: "; . ;", instruction: "Tapez un point-virgule, un point, puis un point-virgule.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 6, texteAttendu: ". ; .", instruction: "Tapez un point, un point-virgule, puis un point.", modeLecture: .lireNaturellement)
        ],
        resumeFinal:
            "Très bien. Vous savez maintenant saisir le point-virgule et le point."
    )

    static let module13Lecon3 = LessonDefinition(
        id: 74,
        titre: "Leçon 3",
        sousTitre: "Les deux-points et le point d’exclamation",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Les deux-points et le point d’exclamation",
                texte:
                    "Cette fois-ci, vous allez découvrir deux signes réalisés avec la main droite."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Les deux-points",
                texte:
                    "Depuis sa position de repos, déplacez légèrement l’annulaire de la main droite en diagonale vers le bas et vers la droite. "
                    + "Appuyez sur cette touche pour saisir les deux-points."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "Le point d’exclamation",
                texte:
                    "Depuis la lettre J, déplacez légèrement l’index de la main droite vers le haut et vers la gauche pour atteindre la lettre U. "
                    + "Depuis la lettre U, poursuivez légèrement vers le haut et vers la droite pour atteindre la touche du point d’exclamation. "
                    + "Ce mouvement forme un petit demi-cercle."
            ),
            LessonStepDefinition(
                id: 4,
                titre: "Objectif de la leçon",
                texte:
                    "Vous allez vous entraîner à saisir les deux-points et le point d’exclamation."
            )
        ],
        exercices: [
            TypingExerciseDefinition(id: 1, texteAttendu: ":", instruction: "Tapez les deux-points. Déplacez légèrement l’annulaire de la main droite en diagonale vers le bas et vers la droite, puis appuyez sur la touche.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 2, texteAttendu: "!", instruction: "Tapez un point d’exclamation. Depuis J, déplacez légèrement l’index de la main droite vers le haut et vers la gauche jusqu’à U, puis poursuivez légèrement vers le haut et vers la droite jusqu’au point d’exclamation.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 3, texteAttendu: ": !", instruction: "Tapez les deux-points, puis un point d’exclamation.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 4, texteAttendu: "! :", instruction: "Tapez un point d’exclamation, puis les deux-points.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 5, texteAttendu: ": ! :", instruction: "Tapez les deux-points, un point d’exclamation, puis les deux-points.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 6, texteAttendu: "! : !", instruction: "Tapez un point d’exclamation, les deux-points, puis un point d’exclamation.", modeLecture: .lireNaturellement)
        ],
        resumeFinal:
            "Bravo. Vous savez maintenant saisir les deux-points et le point d’exclamation."
    )

    static let module13Lecon4 = LessonDefinition(
        id: 75,
        titre: "Leçon 4",
        sousTitre: "L’apostrophe et le trait d’union",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "L’apostrophe et le trait d’union",
                texte:
                    "Place maintenant à deux nouveaux signes de ponctuation."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Trouver l’apostrophe",
                texte:
                    "Depuis la lettre D, déplacez le majeur de la main gauche verticalement vers le haut, en survolant la rangée supérieure. "
                    + "Vous atteignez alors la touche de l’apostrophe."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "Trouver le trait d’union",
                texte:
                    "Depuis la lettre M, déplacez l’auriculaire de la main droite légèrement vers le haut et vers la droite pour atteindre la touche de l’accent circonflexe. "
                    + "Poursuivez ensuite dans la même direction jusqu’à atteindre la touche du trait d’union."
            ),
            LessonStepDefinition(
                id: 4,
                titre: "Objectif de la leçon",
                texte:
                    "Vous allez apprendre à distinguer l’apostrophe et le trait d’union, puis à les enchaîner."
            )
        ],
        exercices: [
            TypingExerciseDefinition(id: 1, texteAttendu: "'", instruction: "Tapez une apostrophe. Depuis la lettre D, déplacez le majeur de la main gauche verticalement vers le haut, en survolant la rangée supérieure, puis appuyez sur la touche.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 2, texteAttendu: "-", instruction: "Tapez un trait d’union. Depuis la lettre M, déplacez l’auriculaire de la main droite légèrement vers le haut et vers la droite jusqu’à la touche de l’accent circonflexe, puis poursuivez dans la même direction jusqu’au trait d’union.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 3, texteAttendu: "' -", instruction: "Tapez une apostrophe, puis un trait d’union.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 4, texteAttendu: "- '", instruction: "Tapez un trait d’union, puis une apostrophe.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 5, texteAttendu: "' - '", instruction: "Tapez une apostrophe, un trait d’union, puis une apostrophe.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 6, texteAttendu: "- ' -", instruction: "Tapez un trait d’union, une apostrophe, puis un trait d’union.", modeLecture: .lireNaturellement)
        ],
        resumeFinal:
            "Bravo. Vous savez maintenant retrouver et saisir l’apostrophe et le trait d’union."
    )

    static let module13Lecon5 = LessonDefinition(
        id: 76,
        titre: "Leçon 5",
        sousTitre: "Consolidation",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Consolidation",
                texte:
                    "Dans cette dernière leçon, vous allez retrouver tous les signes de ponctuation appris dans le module."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Objectif de la leçon",
                texte:
                    "Les exercices mélangent maintenant les différents signes. "
                    + "Retrouvez leur touche sans aide de déplacement."
            )
        ],
        exercices: [
            TypingExerciseDefinition(id: 1, texteAttendu: ", .", instruction: "Tapez une virgule, puis un point.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 2, texteAttendu: "? !", instruction: "Tapez un point d’interrogation, puis un point d’exclamation.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 3, texteAttendu: "; :", instruction: "Tapez un point-virgule, puis les deux-points.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 4, texteAttendu: "' -", instruction: "Tapez une apostrophe, puis un trait d’union.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 5, texteAttendu: ", ; : ?", instruction: "Tapez une virgule, un point-virgule, les deux-points, puis un point d’interrogation.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 6, texteAttendu: "! . ' -", instruction: "Tapez un point d’exclamation, un point, une apostrophe, puis un trait d’union.", modeLecture: .lireNaturellement)
        ],
        resumeFinal:
            "Bravo. Vous avez terminé le module 13 consacré à la ponctuation. "
            + "Vous savez maintenant saisir la virgule, le point, le point-virgule, les deux-points, le point d’interrogation, le point d’exclamation, l’apostrophe et le trait d’union. "
            + "Dans le prochain module, vous utiliserez tous vos acquis pour taper des phrases complètes."
    )



    // MARK: - Module 14 — Les phrases

    static let module14Lecon1 = LessonDefinition(
        id: 77,
        titre: "Leçon 1",
        sousTitre: "Balade en forêt",
        introduction:
            "Bienvenue dans le module 14, Les phrases.",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Balade en forêt",
                texte:
                    "Pour commencer ce dernier module pédagogique, partons nous promener en forêt."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Des phrases complètes",
                texte:
                    "Vous allez maintenant mettre en pratique tout ce que vous avez appris : les mots, les espaces, les majuscules, les lettres accentuées et la ponctuation."
            ),
            LessonStepDefinition(
                id: 3,
                titre: "Objectif de la leçon",
                texte:
                    "Les premières phrases restent courtes, puis elles deviennent progressivement un peu plus riches."
            )
        ],
        exercices: [
            TypingExerciseDefinition(id: 1, texteAttendu: "Où allons-nous aujourd'hui ?", instruction: "Tapez la phrase Où allons-nous aujourd’hui ?", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 2, texteAttendu: "Nous partons en forêt.", instruction: "Tapez la phrase Nous partons en forêt.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 3, texteAttendu: "Le chemin traverse les arbres.", instruction: "Tapez la phrase Le chemin traverse les arbres.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 4, texteAttendu: "Je cueille des champignons.", instruction: "Tapez la phrase Je cueille des champignons.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 5, texteAttendu: "Écoute, un oiseau chante !", instruction: "Tapez la phrase Écoute, un oiseau chante !", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 6, texteAttendu: "Après la balade, nous rentrons tranquillement.", instruction: "Tapez la phrase Après la balade, nous rentrons tranquillement.", modeLecture: .lireNaturellement)
        ],
        resumeFinal:
            "Bien joué ! Votre balade en forêt est terminée."
    )

    static let module14Lecon2 = LessonDefinition(
        id: 78,
        titre: "Leçon 2",
        sousTitre: "Une journée à la mer",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Une journée à la mer",
                texte:
                    "Changeons de décor et passons une journée au bord de la mer."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Objectif de la leçon",
                texte:
                    "Vous allez continuer à enchaîner des phrases complètes avec différentes ponctuations."
            )
        ],
        exercices: [
            TypingExerciseDefinition(id: 1, texteAttendu: "As-tu pris ton maillot ?", instruction: "Tapez la phrase As-tu pris ton maillot ?", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 2, texteAttendu: "Oui, il est dans mon sac.", instruction: "Tapez la phrase Oui, il est dans mon sac.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 3, texteAttendu: "La mer est calme aujourd'hui.", instruction: "Tapez la phrase La mer est calme aujourd’hui.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 4, texteAttendu: "Regarde, un bateau passe au loin !", instruction: "Tapez la phrase Regarde, un bateau passe au loin !", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 5, texteAttendu: "Nous ramassons de jolis coquillages.", instruction: "Tapez la phrase Nous ramassons de jolis coquillages.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 6, texteAttendu: "Après la baignade, nous rentrons heureux.", instruction: "Tapez la phrase Après la baignade, nous rentrons heureux.", modeLecture: .lireNaturellement)
        ],
        resumeFinal:
            "Très bien ! Cette belle journée à la mer se termine."
    )

    static let module14Lecon3 = LessonDefinition(
        id: 79,
        titre: "Leçon 3",
        sousTitre: "Une soirée entre amis",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Une soirée entre amis",
                texte:
                    "Cette fois-ci, retrouvons quelques amis pour une soirée conviviale."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Objectif de la leçon",
                texte:
                    "Les phrases mélangent maintenant davantage de majuscules, d’apostrophes, de traits d’union et de ponctuation."
            )
        ],
        exercices: [
            TypingExerciseDefinition(id: 1, texteAttendu: "Qui arrive ce soir ?", instruction: "Tapez la phrase Qui arrive ce soir ?", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 2, texteAttendu: "Jean-Baptiste arrive bientôt.", instruction: "Tapez la phrase Jean-Baptiste arrive bientôt.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 3, texteAttendu: "J'aime beaucoup cette musique.", instruction: "Tapez la phrase J’aime beaucoup cette musique.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 4, texteAttendu: "Le repas est prêt, venez à table !", instruction: "Tapez la phrase Le repas est prêt, venez à table !", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 5, texteAttendu: "Peut-être jouerons-nous après le repas.", instruction: "Tapez la phrase Peut-être jouerons-nous après le repas.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 6, texteAttendu: "Quelle belle soirée entre amis !", instruction: "Tapez la phrase Quelle belle soirée entre amis !", modeLecture: .lireNaturellement)
        ],
        resumeFinal:
            "Bien joué ! La soirée entre amis se termine dans la bonne humeur."
    )

    static let module14Lecon4 = LessonDefinition(
        id: 80,
        titre: "Leçon 4",
        sousTitre: "Un voyage en train",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Un voyage en train",
                texte:
                    "C’est parti ! Prenons le train pour une nouvelle destination."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Objectif de la leçon",
                texte:
                    "Restez attentif aux majuscules, aux espaces et aux différents signes de ponctuation."
            )
        ],
        exercices: [
            TypingExerciseDefinition(id: 1, texteAttendu: "À quelle heure part le train ?", instruction: "Tapez la phrase À quelle heure part le train ?", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 2, texteAttendu: "Le départ est prévu à dix heures.", instruction: "Tapez la phrase Le départ est prévu à dix heures.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 3, texteAttendu: "Ma valise est prête, mon billet aussi.", instruction: "Tapez la phrase Ma valise est prête, mon billet aussi.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 4, texteAttendu: "Ça y est, le train arrive !", instruction: "Tapez la phrase Ça y est, le train arrive !", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 5, texteAttendu: "Nous montons à bord ; le voyage commence.", instruction: "Tapez la phrase Nous montons à bord ; le voyage commence.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 6, texteAttendu: "Après quelques heures, nous arrivons à destination.", instruction: "Tapez la phrase Après quelques heures, nous arrivons à destination.", modeLecture: .lireNaturellement)
        ],
        resumeFinal:
            "Bravo ! Vous êtes arrivé à destination."
    )

    static let module14Lecon5 = LessonDefinition(
        id: 81,
        titre: "Leçon 5",
        sousTitre: "Une sortie au cirque",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Une sortie au cirque",
                texte:
                    "Une surprise vous attend."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Objectif de la leçon",
                texte:
                    "Suivez cette petite histoire et saisissez chaque phrase en respectant sa ponctuation."
            )
        ],
        exercices: [
            TypingExerciseDefinition(id: 1, texteAttendu: "Je t'emmène quelque part aujourd'hui !", instruction: "Tapez la phrase Je t’emmène quelque part aujourd’hui !", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 2, texteAttendu: "Où est-ce que tu m'emmènes ?", instruction: "Tapez la phrase Où est-ce que tu m’emmènes ?", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 3, texteAttendu: "Nous allons voir le cirque.", instruction: "Tapez la phrase Nous allons voir le cirque.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 4, texteAttendu: "J'aime beaucoup les clowns !", instruction: "Tapez la phrase J’aime beaucoup les clowns !", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 5, texteAttendu: "Regarde : les artistes entrent en piste.", instruction: "Tapez la phrase Regarde : les artistes entrent en piste.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 6, texteAttendu: "Le spectacle se termine, quel beau moment !", instruction: "Tapez la phrase Le spectacle se termine, quel beau moment !", modeLecture: .lireNaturellement)
        ],
        resumeFinal:
            "Bravo ! Il est temps de quitter le chapiteau."
    )

    static let module14Lecon6 = LessonDefinition(
        id: 82,
        titre: "Leçon 6",
        sousTitre: "Consolidation finale",
        introduction:
            "",
        etapes: [
            LessonStepDefinition(
                id: 1,
                titre: "Consolidation finale",
                texte:
                    "Vous voici arrivé à la dernière leçon pédagogique d’Apprenti Clavier."
            ),
            LessonStepDefinition(
                id: 2,
                titre: "Objectif de la leçon",
                texte:
                    "Ces derniers exercices rassemblent tout ce que vous avez appris pour écrire au clavier avec confiance."
            )
        ],
        exercices: [
            TypingExerciseDefinition(id: 1, texteAttendu: "Je trouve les lettres plus facilement.", instruction: "Tapez la phrase Je trouve les lettres plus facilement.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 2, texteAttendu: "Je sais écrire des mots et des phrases.", instruction: "Tapez la phrase Je sais écrire des mots et des phrases.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 3, texteAttendu: "Accents, majuscules et ponctuation : je progresse !", instruction: "Tapez la phrase Accents, majuscules et ponctuation : je progresse !", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 4, texteAttendu: "J'utilise maintenant mon clavier avec plus d'aisance.", instruction: "Tapez la phrase J’utilise maintenant mon clavier avec plus d’aisance.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 5, texteAttendu: "Avec de la pratique, je continuerai à progresser.", instruction: "Tapez la phrase Avec de la pratique, je continuerai à progresser.", modeLecture: .lireNaturellement),
            TypingExerciseDefinition(id: 6, texteAttendu: "Je suis prêt à écrire seul !", instruction: "Tapez la phrase Je suis prêt à écrire seul !", modeLecture: .lireNaturellement)
        ],
        resumeFinal:
            "Feu d’artifice ! Félicitations ! Vous avez terminé tous les modules pédagogiques d’Apprenti Clavier. "
            + "Vous avez appris à trouver les touches, à saisir des mots, à utiliser les majuscules, les lettres accentuées et la ponctuation, puis à écrire des phrases complètes. "
            + "Vous avez maintenant toutes les clés en main pour continuer à écrire et à progresser au clavier. "
            + "Si vous souhaitez poursuivre votre entraînement de manière ludique, vous pouvez maintenant utiliser l’application Apprenti Clavier - Le Parc d’attractions. "
            + "Votre profil Apprenti Clavier terminé vous servira de billet d’entrée : exportez-le depuis le menu Fichier, puis importez-le dans le Parc. Les portes du parc d’attractions vous sont ouvertes !"
    )
}

