#!/bin/bash

# this bash code was made by ATOUI Rayane to automate the operation of creating Linux from scratch with the help of LFS book v12 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

SAVE="
###Language
#msgs:
export CURRENT_USER=\"${PROCESS} L'utilisateur actuel est : \$(whoami)\n${NO_STYLE}\"

export DO_YOU_WANNA_KEEP_DEBUG_FILES=\"Voulez-vous conserver les fichiers de débogage ? [y/n]\"
export YEP_KEEP_DEBUG_FILES=\"${OK}Vous avez indiqué vouloir les conserver\n${NO_STYLE}\"
export YEP_KEEP_DEBUG_FILES=\"${OK}Vous avez indiqué que vous ne souhaitiez pas les conserver\n${NO_STYLE}\"

export INPUT_POSI_NUMBER=\"Saisissez un nombre positif (>0):\"
export NO_VALID_NUMBER=\"${ERROR}Erreur:${NO_STYLE} Le paramètre n'est pas un nombre valide\"

export DO_YOU_WANT_TO_EXE_OPTIONNAL_TESTS=\"Voulez-vous exécuter des testicules recommandés et facultatifs ? [y/n]\"
export DO_ALL_TESTS=\"${OK}Vous avez indiqué que vous souhaitiez que tous les tests soient effectués\n${NO_STYLE}\"
export DONT_DO_ALL_TESTS=\"${OK}Vous avez indiqué que vous ne souhaitez pas que tous les tests soient effectués (ne faites que les nécessaires)\n${NO_STYLE}\"

export DO_YOU_WANT_TO_ADD_OPTIONNAL_DOCS=\"Voulez-vous ajouter de la documentation pour tous les paquets utilisés ? [y/n]\"
export ADD_ALL_DOCS=\"${OK}Vous avez indiqué que vous souhaitez ajouter toute la documentation de tous les packages utilisés \n${NO_STYLE}\"
export DONT_ADD_ALL_DOCS=\"${OK}Vous avez indiqué que vous ne souhaitez pas ajouter toute la documentation de tous les packages utilisés (uniquement ceux nécessaires) \n${NO_STYLE}\"

export RUNING_WITH_FULL_CPU_POWER_FOR_LONG_TIME_HARM_PC=\"${ERROR}IMPORTANT : ${NO_STYLE} Utiliser 100 % de votre CPU pendant très longtemps pourrait endommager votre CPU !!\"
export HOW_MATCH_TIME_SLEEP_IN_SECONDS=\"Pendant combien de temps (en secondes) vous souhaitez suspendre le processus après chaque période (5SBU -aprox) ?\"
export EACH_5_SBU_SLEEP=\"Chaque période pendant laquelle le processus dormira :\"
export SLEEPPING_AFTER=\"Dormir après\"
export WAKINNG=\"Se réveiller ...\"

export IS_YOUR_TARGET_UEFI=\"Votre cible possède-t-elle un bios UEFI ? [y/n]\"
export YOUR_TARGET_IS_UEFI=\"${OK}Vous avez indiqué que votre cible possède un bios UEFI \n${NO_STYLE}\"
export YOUR_TARGET_IS_NOT_UEFI=\"${OK}Vous avez indiqué que votre cible n'a pas de bios UEFI \n${NO_STYLE}\"

export LFS_IS_NOT_SET=\"${ERROR}ERREUR : ${NO_STYLE}La variable \$LFS n'est pas définie !!\"
export DO_YOU_WANT_HAVING_ONLY_STATIC=\"Voulez-vous que nous utilisions uniquement des bibliothèques statiques ? (sinon, nous utiliserons des bibliothèques dynamiques chaque fois que cela sera possible) [y/n]\"
export CHOOSE_CPU_ARCHI=\"Choisissez votre CPU cible-archi \n\"
export ONLY_STATIC=\"${OK}Vous avez indiqué que vous souhaitiez que nous utilisions uniquement des bibliothèques statiques.\n${NO_STYLE}\"
export NOT_ONLY_STATIC=\"${OK}Vous avez indiqué que vous souhaitiez que nous utilisions des bibliothèques dynamiques chaque fois que nous le pouvons.\n${NO_STYLE}\"
export DO_YOU_HAVE_CODE_SOURCES=\"Avez-vous les paquets requis ? [y/n]\"
export DO_YOU_WANT_BACKUP_OS_REC=\"Avant les dernières étapes, ${OK}il est recommandé${NO_STYLE} d'avoir une sauvegarde de la progression [nécessite environ 5 Go]\"
export DO_YOU_WANT_BACKUP_OS=\"Voulez-vous sauvegarder la progression? [y/n]\"
export YES_BACK_UP_OS=\"${OK}Vous avez indiqué que vous souhaitez que nous sauvegardions la progression \n${NO_STYLE}\"
export NO_BACK_UP_OS=\"${OK}Vous avez indiqué que vous ne souhaitez pas que nous sauvegardions la progression\n${NO_STYLE}\"
export YOU_HAVE_CODE_SOURCES=\"${OK}Vous avez indiqué que vous disposez des sources du code. \n${NO_STYLE}\"
export YOU_DONNOT_HAVE_CODE_SOURCES=\"${OK}Vous avez indiqué que vous ne disposez pas des sources du code.\n${NO_STYLE}\"
export UPDATE_DOWNLOAD_NEEDED_PKGS=\"${PROCESS}Téléchargement et mise à jour des packages requis ...${NO_STYLE}\"
export PLEASE_Y_OR_N=\"${ERROR}Erreur:${NO_STYLE} Entrée invalide. Veuillez saisir y ou n.\"
export STARTING_DOWNLOADS=\"${PROCESS}Démarrage du téléchargement...${NO_STYLE}\"
export CANNOT_INSTALL_PAKAGES=\"${ERROR}Erreur:${NO_STYLE} Impossible de télécharger les packages nécessaires\"
export MISSING_PARAM=\"${ERROR}Erreur:${NO_STYLE} Paramètres manquants\"
export START_DOWNLOAD_CODE_SOURCES=\"${PROCESS}Téléchargement des sources du code ...${NO_STYLE}\"
export START_DOWNLOAD_CODE_SOURCES_OTHER=\"${PROCESS}Téléchargement des sources de code à partir d'autres liens...${NO_STYLE}\"
export SELECT_TARGET_ARCHI=\"Saisissez le numéro correspondant à votre CPU-archi cible : \"
export NOT_VALID_NUMBER=\"${ERROR}Erreur:${NO_STYLE} Le paramètre n'est pas un nombre valide.\"
export SELECTED_ARCHI_IS=\"Votre CPU-archi cible est : \"
export INPUT_NEW_USER_NAME_msg=\"Saisissez le nouveau nom d'utilisateur : \"
export NO_MATCH_ERROR=\"${ERROR}Erreur:${NO_STYLE} pas de correspondance :\"
export INPUT_THE_NAME_OF_THE_NEW_DISTRO_msg=\"Saisissez le nom de votre nouvelle distribution: \"
export WELCOME=\"Bienvenue dans notre programme\"
export LOGO=\"Créez facilement LFS !!\"
#**************
export START_STEP0=\"${TITLE}  START 0 - Obtenir des données de l'utilisateur - ${NO_STYLE}\"
export END_STEP0=\"${TITLE}  END 0 - Obtenir des données de l'utilisateur - ${NO_STYLE}\"
#**************
export START_STEP1=\"${TITLE} START 1 - Créer un utilisateur et une partition - ${NO_STYLE}\"
export INPUT_NAME_OF_PARTITION=\"Saisissez le nom de la partition : \"
export CANNOT_GET_UUID=\"${ERROR}Erreur:${NO_STYLE} Impossible d'obtenir l'UUID pour \"
export SUCCESS_MOUNT=\"${OK}Disque monté avec succès et fstab mis à jour.${NO_STYLE}\"
export ERROR_MOUNT=\"${ERROR}Erreur:${NO_STYLE} Le disque n'a pas pu être monté. Vérifiez /etc/fstab et réessayez.\"
export CREATE_DIR_TO_PUT_RESULTS_OF_COMPILE=\"${PROCESS}Création de répertoires pour y mettre les résultats de la compilation...${NO_STYLE}\"
export ADD_USER_AND_GROUPE=\"${PROCESS}Ajout d'un nouvel utilisateur et d'un groupe d'utilisateurs...${NO_STYLE}\"
export RUN_CMD_TO_START_NEXT_STEP=\"Exécutez cette commande pour démarrer l'étape suivante : \"
export END_STEP1=\"${TITLE} END 1 - Créer un utilisateur et une partition - ${NO_STYLE}\"
#**************
export START_STEP2=\"${TITLE}  START 2 - Extraction et compilation - ${NO_STYLE}\"
export SWICH_TO_ROOT=\"${PROCESS} Passage à l'utilisateur root de l'hôte...${NO_STYLE}\"
export SWICH_TO_LFS=\"${PROCESS} Passage à l'utilisateur \$DEV_NAME... ${NO_STYLE}\"
export START_EXTRACTION=\"${PROCESS}Extraction de fichiers... ${NO_STYLE}\"
export N_THREADS=\"${OK}#nombre de fils:${NO_STYLE} \"
export START_TEST=\" ${TEST} Test de démarrage... ${NO_STYLE}\"
export EXPECT_OUTPUT=\" ${TEST}Résultat attendu : ${NO_STYLE}\"
export REAL_OUTPUT=\" ${TEST}Le vrai résultat : ${NO_STYLE}\"
export TEST_PASS=\" ${TEST}Test réussi ! ${NO_STYLE}\"
export TEST_FAIL=\" ${ERROR}Le test a échoué !! ${NO_STYLE}\"
export BUILD_FAILED=\"${ERROR}La construction a échoué. !!${NO_STYLE}\"
export BUILD_SUCCEEDED=\"${OK}Construction réussie. !!${NO_STYLE}\"
export TOOL_READY=\"${OK}L'outil est prêt :) \n\n${NO_STYLE}\"
export END_STEP2=\"${TITLE}  END 2 - Extraction et compilation - ${NO_STYLE}\"
#**************
export START_STEP3=\"${TITLE}  START 3 -  Passe à Chroot - ${NO_STYLE}\"
export END_STEP3=\"${TITLE}  END 3 - Passe à Chroot - ${NO_STYLE}\"
#**************
export START_STEP4=\"${TITLE}  START 4 - Ajout des répertoires nécessaires - ${NO_STYLE}\"
export BACKING_UP_PROGRESS_TO_TARBALL=\"${PROCESS}Sauvegarder les progrès ...${NO_STYLE}\"
export RESTORE_PROGRESS_TO_TARBALL=\"${PROCESS}Restaurer le progrès ...${NO_STYLE}\"

export DO_YOU_WANNA_EXIT_AFTER_BACKUP=\"Voulez-vous quitter maintenant que la sauvegarde est terminée ?  [y/n] \"
export SELECTED_EXIT_AFTER_BACKUP=\"${PROCESS}Vous avez indiqué que vous souhaitiez quitter ... ${NO_STYLE}\"
export SELECTED_DONNT_EXIT_AFTER_BACKUP=\"${PROCESS}Vous avez indiqué que vous souhaitez quitter, en complétant le travail ... ${NO_STYLE}\"

export END_STEP4=\"${TITLE}  END 4 - Ajout des répertoires nécessaires - ${NO_STYLE}\"
#**************
export START_STEP5=\"${TITLE}  START 5 - Construire des outils temporaires - ${NO_STYLE}\"
export INPUT_TZ_VALUE=\"Saisissez le résultat de la commande précédente (valeur TZ) :\"
export VALID_TZ=\"${OK}Fuseau horaire valide: ${NO_STYLE}\n\"
export NOT_VALID_TZ=\"${ERROR}Erreur: Fuseau horaire invalide. Veuillez réessayer.${NO_STYLE}\n\"
export END_STEP5=\"${TITLE}  END 5 - Construire des outils temporaires - ${NO_STYLE}\"
#**************
export START_STEP6=\"${TITLE}  START 6 - Suppression des fichiers de débogage - ${NO_STYLE}\"
export END_STEP6=\"${TITLE}  END 6 - Suppression des fichiers de débogage - ${NO_STYLE}\"
#**************
export START_STEP7=\"${TITLE}  START 7 - Construction de nettoyage -   ${NO_STYLE}\"
export END_STEP7=\"${TITLE}  END 7 - Construction de nettoyage -   ${NO_STYLE}\"
#**************
export START_STEP8=\"${TITLE}  START 8 - System config -   ${NO_STYLE}\"
export INPUT_NETWORK_INTERFACE_NAME=\"Entrez le nom de votre interface réseau (par exemple, eth0, wlan0) ou tapez « exit » pour terminer: \"
export FINISHED_ADDING_NW_I_N=\"Fini l'ajout d'interfaces réseau.\"
export INPUT_HOST_NAME=\"Entrez votre nom d'hôte (le nom apparaît après le @ ex: \\\"root@HOSTNAME:\\\" ): \"
export EMPTY_NW_I_N=\"${ERROR}Erreur: Le nom de l'interface réseau ne peut pas être vide.${NO_STYLE} Veuillez réessayer.\"
export CHOOSE_SYS_LOCAL=\"Choisissez le système local dans la liste ci-dessous : \"
export INPUT_SYS_L_VALUE=\"Saisissez la valeur choisie : \"
export NOT_VALID_SYS_L=\"${ERROR}Erreur: Local non valide !!${NO_STYLE}\"
export VALID_SYS_L=\"${OK}Votre local choisi est : ${NO_STYLE}\"
export INPUT_ANY_CHAR_TO_CONTINUE=\"${OK}(saisissez n'importe quel caractère pour continuer ...) ${NO_STYLE} \"

export INPUT_EFI_System_Partition_NAME=\"Saisissez le nom de la partition que vous souhaitez utiliser comme partition de démarrage efi (Remarque : son type doit être FAT32) : \"
export INPUT_swp_Partition_NAME=\"Saisissez le nom de la partition que vous souhaitez utiliser comme partition de swap (Remarque : le nom n'est pas nécessaire, pas le chemin complet) : \"
export INPUT_boot_Partition_NAME=\"Saisissez le nom de la partition que vous souhaitez utiliser comme partition de démarrage (Remarque : le nom n'est pas nécessaire, pas le chemin complet) : \"
export INPUT_boot_partition_root_NAME=\"Saisissez le nom de la partition de démarrage (Remarque : la valeur nécessaire doit être sous la forme de (hd<n>,<m>) où n : N° du disque && m : N° de partition qu'il contient ex : (hd0, 6)) : \"


export MAKING_EM_BOOT_DISK=\"${PROCESS}Créer un disque de démarrage d'urgence ...${NO_STYLE}\"
export MAKING_EM_BOOT_DISK=\"${PROCESS}Création de la partition du système EFI ...${NO_STYLE}\"
export END_STEP8=\"${TITLE}  END 8 - System config -   ${NO_STYLE}\"
#**************


#actions:
export START_JOB=\"${PROCESS}Fabrication ...${NO_STYLE}\"
export START_CLEANING_JOB=\"${PROCESS} Nettoyage ...${NO_STYLE}\"
export DONE=\"${OK}Terminé${NO_STYLE}\n\"
export STOP_MSG_ERROR=\"${ERROR}ERREUR${NO_STYLE}\n\"
export EMPTY_INPUT_IS_NOT_ALLOWED=\"${ERROR}ERREUR : UNE SAISIE VIDE N'EST PAS AUTORISÉE !!${NO_STYLE}\n\"



export END_OF_BASH_WORK=\"Ce script bash a été réalisé par ATOUI Rayane le leader de l'équipe chroot du hackathon (premier Linux from scratch en Algérie) \n merci d'utiliser cet outil !! \n la prochaine chose que vous devez faire est de redémarrer votre système\"
"

echo "$SAVE" >> $SHARED_FILE

