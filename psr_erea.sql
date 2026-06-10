-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : mer. 10 juin 2026 à 11:35
-- Version du serveur : 8.2.0
-- Version de PHP : 8.2.13

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `psr_erea`
--

-- --------------------------------------------------------

--
-- Structure de la table `avis`
--

DROP TABLE IF EXISTS `avis`;
CREATE TABLE IF NOT EXISTS `avis` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_utilisateur` int NOT NULL,
  `id_reservation` int NOT NULL,
  `note` tinyint NOT NULL,
  `commentaire` text,
  `date_creation` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_avis_utilisateur` (`id_utilisateur`),
  KEY `idx_avis_reservation` (`id_reservation`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `creneaux`
--

DROP TABLE IF EXISTS `creneaux`;
CREATE TABLE IF NOT EXISTS `creneaux` (
  `id` int NOT NULL AUTO_INCREMENT,
  `heure` time NOT NULL,
  `quota_max` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `heure` (`heure`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `creneaux`
--

INSERT INTO `creneaux` (`id`, `heure`, `quota_max`) VALUES
(1, '11:00:00', 10),
(2, '11:30:00', 20),
(3, '12:30:00', 15);

-- --------------------------------------------------------

--
-- Structure de la table `logs_admin`
--

DROP TABLE IF EXISTS `logs_admin`;
CREATE TABLE IF NOT EXISTS `logs_admin` (
  `id` int NOT NULL AUTO_INCREMENT,
  `admin_id` int NOT NULL,
  `action` varchar(150) NOT NULL,
  `utilisateur_cible` varchar(100) NOT NULL,
  `date_action` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `admin_id` (`admin_id`)
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `logs_admin`
--

INSERT INTO `logs_admin` (`id`, `admin_id`, `action`, `utilisateur_cible`, `date_action`) VALUES
(1, 1, 'Réinitialisation mot de passe', 'yaubry', '2026-05-11 21:52:33'),
(2, 1, 'Ajout utilisateur', 'lburri', '2026-05-11 23:54:36'),
(3, 1, 'Réinitialisation mot de passe', 'lburri', '2026-05-12 00:08:38'),
(4, 1, 'Désactivation compte', 'yaubry', '2026-05-12 00:33:34'),
(5, 2, 'Modification utilisateur', 'admin', '2026-05-12 12:20:19'),
(6, 2, 'Suppression utilisateur', 'lburri', '2026-05-12 12:21:46'),
(7, 2, 'Suppression utilisateur', 'jburri', '2026-05-12 12:22:01'),
(8, 2, 'Ajout utilisateur', 'jburri', '2026-05-12 12:22:20'),
(9, 1, 'Désactivation compte', 'jburri', '2026-05-25 14:38:15'),
(10, 1, 'Réactivation compte', 'jburri', '2026-05-25 14:38:19');

-- --------------------------------------------------------

--
-- Structure de la table `menus_hebdo`
--

DROP TABLE IF EXISTS `menus_hebdo`;
CREATE TABLE IF NOT EXISTS `menus_hebdo` (
  `id` int NOT NULL AUTO_INCREMENT,
  `jour_semaine` varchar(20) NOT NULL,
  `type_repas` enum('standard','vegetarien','sans-porc') NOT NULL,
  `entree` varchar(255) NOT NULL,
  `plat` varchar(255) NOT NULL,
  `dessert` varchar(255) NOT NULL,
  `fromage_yaourt` varchar(255) NOT NULL,
  `pain` varchar(255) NOT NULL,
  `date_creation` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `menus_hebdo`
--

INSERT INTO `menus_hebdo` (`id`, `jour_semaine`, `type_repas`, `entree`, `plat`, `dessert`, `fromage_yaourt`, `pain`, `date_creation`) VALUES
(1, 'Lundi', 'standard', 'Salade Verte', 'Steak haché frites', 'Tarte aux poires', 'Fromage blanc', 'Pain de campagne', '2026-05-09 19:56:19'),
(2, 'Lundi', 'vegetarien', 'Velouté de légumes', 'Lasagnes aux légumes', 'Compote', 'Yaourt aux fruits', 'Pain complet', '2026-05-09 19:56:19'),
(3, 'Lundi', 'sans-porc', 'Carottes râpées', 'Poulet rôti riz', 'Flan vanille', 'Fromage de brebis', 'Pain blanc', '2026-05-09 19:56:19'),
(4, 'Mardi', 'standard', 'Concombre à la crème', 'Escalope de dinde pâtes', 'Mousse au chocolat', 'Camembert', 'Pain de campagne', '2026-05-09 20:34:55'),
(5, 'Mardi', 'vegetarien', 'Betteraves rouges', 'Gratin de légumes', 'Salade de fruits', 'Yaourt nature', 'Pain complet', '2026-05-09 20:34:55'),
(6, 'Mardi', 'sans-porc', 'Tomates vinaigrette', 'Poisson pané riz', 'Crème dessert vanille', 'Fromage frais', 'Pain blanc', '2026-05-09 20:34:55'),
(7, 'Mercredi', 'standard', 'Taboulé', 'Bœuf bourguignon purée', 'Éclair au chocolat', 'Brie', 'Pain de campagne', '2026-05-09 20:34:55'),
(8, 'Mercredi', 'vegetarien', 'Salade de maïs', 'Omelette aux pommes de terre', 'Compote de pommes', 'Yaourt aux fruits', 'Pain complet', '2026-05-09 20:34:55'),
(9, 'Mercredi', 'sans-porc', 'Céleri rémoulade', 'Poulet sauce crème haricots verts', 'Flan caramel', 'Fromage de chèvre', 'Pain blanc', '2026-05-09 20:34:55'),
(10, 'Jeudi', 'standard', 'Œufs mayonnaise', 'Saucisses lentilles', 'Tarte aux pommes', 'Emmental', 'Pain de campagne', '2026-05-09 20:34:55'),
(11, 'Jeudi', 'vegetarien', 'Salade de chou', 'Quiche aux légumes', 'Yaourt sucré', 'Fromage blanc', 'Pain complet', '2026-05-09 20:34:55'),
(12, 'Jeudi', 'sans-porc', 'Carottes râpées', 'Filet de poisson semoule', 'Pudding vanille', 'Carré frais', 'Pain blanc', '2026-05-09 20:34:55'),
(13, 'Vendredi', 'standard', 'Macédoine de légumes', 'Poisson sauce citron riz', 'Brownie', 'Saint-Môret', 'Pain de campagne', '2026-05-09 20:34:55'),
(14, 'Vendredi', 'vegetarien', 'Salade verte', 'Pâtes à la sauce tomate', 'Fruit de saison', 'Yaourt nature', 'Pain complet', '2026-05-09 20:34:55'),
(15, 'Vendredi', 'sans-porc', 'Radis beurre', 'Nuggets de poulet frites', 'Crème caramel', 'Fromage de brebis', 'Pain blanc', '2026-05-09 20:34:55');

-- --------------------------------------------------------

--
-- Structure de la table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
CREATE TABLE IF NOT EXISTS `notifications` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_utilisateur` int NOT NULL,
  `type_notification` enum('confirmation','rappel','annulation','quota_atteint') NOT NULL,
  `canal` enum('email','sms') NOT NULL DEFAULT 'email',
  `sujet` varchar(255) DEFAULT NULL,
  `message` text NOT NULL,
  `statut` enum('en_attente','envoye','echec') NOT NULL DEFAULT 'en_attente',
  `date_creation` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_envoi` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_notifications_utilisateur` (`id_utilisateur`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `notifications`
--

INSERT INTO `notifications` (`id`, `id_utilisateur`, `type_notification`, `canal`, `sujet`, `message`, `statut`, `date_creation`, `date_envoi`) VALUES
(1, 1, 'confirmation', 'email', 'Confirmation de votre réservation - PSR EREA', 'Bonjour Mr. Le Général Administrateur,\n\nVotre réservation a bien été enregistrée.\n- Date : 2026-06-03\n- Créneau : 11:00:00\n- Type de repas : standard\n- Mode : sur-place\n\nMerci.\nRestaurant PSR EREA', 'echec', '2026-06-02 08:05:37', NULL),
(2, 1, 'confirmation', 'email', 'Confirmation de votre réservation - PSR EREA', 'Bonjour Mr. Le Général Administrateur,\n\nVotre réservation a bien été enregistrée.\n- Date : 2026-06-04\n- Créneau : 11:00:00\n- Type de repas : standard\n- Mode : sur-place\n\nMerci.\nRestaurant PSR EREA', 'echec', '2026-06-02 08:10:42', NULL),
(3, 1, 'confirmation', 'email', 'Confirmation de votre réservation - PSR EREA', 'Bonjour Mr. Le Général Administrateur,\n\nVotre réservation a bien été enregistrée.\n- Date : 2026-06-05\n- Créneau : 11:00:00\n- Type de repas : standard\n- Mode : sur-place\n\nMerci.\nRestaurant PSR EREA', 'echec', '2026-06-02 10:20:53', NULL),
(4, 3, 'confirmation', 'email', 'Confirmation de votre réservation - PSR EREA', 'Bonjour Tofirk Soussi,\n\nVotre réservation a bien été enregistrée.\n- Date : 2026-06-09\n- Créneau : 12:30:00\n- Type de repas : standard\n- Mode : sur-place\n\nMerci.\nRestaurant PSR EREA', 'echec', '2026-06-08 15:28:45', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `planning_presence`
--

DROP TABLE IF EXISTS `planning_presence`;
CREATE TABLE IF NOT EXISTS `planning_presence` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_utilisateur` int NOT NULL,
  `date_presence` date NOT NULL,
  `statut_presence` enum('present','absent','indisponible') NOT NULL DEFAULT 'present',
  `commentaire` varchar(255) DEFAULT NULL,
  `date_creation` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uc_planning_presence` (`id_utilisateur`,`date_presence`),
  KEY `idx_planning_utilisateur` (`id_utilisateur`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `planning_presence`
--

INSERT INTO `planning_presence` (`id`, `id_utilisateur`, `date_presence`, `statut_presence`, `commentaire`, `date_creation`) VALUES
(2, 5, '2026-06-01', 'absent', 'Malade', '2026-05-29 09:23:53');

-- --------------------------------------------------------

--
-- Structure de la table `repas_noel`
--

DROP TABLE IF EXISTS `repas_noel`;
CREATE TABLE IF NOT EXISTS `repas_noel` (
  `id` int NOT NULL AUTO_INCREMENT,
  `entree` varchar(255) NOT NULL,
  `plat` varchar(255) NOT NULL,
  `dessert` varchar(255) NOT NULL,
  `boisson` varchar(255) NOT NULL,
  `prix` decimal(5,2) NOT NULL DEFAULT '8.00',
  `actif` tinyint(1) NOT NULL DEFAULT '1',
  `date_creation` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `repas_noel`
--

INSERT INTO `repas_noel` (`id`, `entree`, `plat`, `dessert`, `boisson`, `prix`, `actif`, `date_creation`) VALUES
(1, 'Foie gras maison ou Salade de saison', 'Dinde aux marrons ou Saumon fumé', 'Bûche de Noël ou Tarte aux pommes', 'Jus de fruits', 8.00, 1, '2026-05-11 10:31:50');

-- --------------------------------------------------------

--
-- Structure de la table `reservations`
--

DROP TABLE IF EXISTS `reservations`;
CREATE TABLE IF NOT EXISTS `reservations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_utilisateur` int NOT NULL,
  `date_repas` date NOT NULL,
  `creneau` varchar(10) NOT NULL,
  `type_repas` varchar(50) NOT NULL,
  `mode_consommation` varchar(50) NOT NULL,
  `statut` varchar(50) NOT NULL DEFAULT 'validee',
  `points_attribues` tinyint(1) NOT NULL DEFAULT '1',
  `date_creation` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_reservation_utilisateur` (`id_utilisateur`)
) ENGINE=MyISAM AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `reservations`
--

INSERT INTO `reservations` (`id`, `id_utilisateur`, `date_repas`, `creneau`, `type_repas`, `mode_consommation`, `statut`, `points_attribues`, `date_creation`) VALUES
(37, 3, '2026-06-09', '11:00:00', 'noel', 'emporter', 'validee', 10, '2026-06-08 15:29:45'),
(36, 3, '2026-06-09', '12:30:00', 'standard', 'sur-place', 'validee', 10, '2026-06-08 15:28:43'),
(35, 1, '2026-06-05', '11:00:00', 'standard', 'sur-place', 'validee', 10, '2026-06-02 10:20:51'),
(34, 1, '2026-06-04', '11:00:00', 'standard', 'sur-place', 'validee', 10, '2026-06-02 08:10:40'),
(33, 1, '2026-06-03', '11:00:00', 'standard', 'sur-place', 'validee', 10, '2026-06-02 08:05:35'),
(32, 3, '2026-06-02', '11:30:00', 'vegetarien', 'sur-place', 'validee', 10, '2026-05-29 09:27:49'),
(31, 2, '2026-05-28', '11:30:00', 'standard', 'emporter', 'validee', 10, '2026-05-25 15:18:33'),
(30, 1, '2026-05-28', '11:30:00', 'standard', 'sur-place', 'validee', 10, '2026-05-25 14:57:01');

-- --------------------------------------------------------

--
-- Structure de la table `utilisateurs`
--

DROP TABLE IF EXISTS `utilisateurs`;
CREATE TABLE IF NOT EXISTS `utilisateurs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(100) NOT NULL,
  `prenom` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `login` varchar(100) NOT NULL,
  `mot_de_passe` varchar(255) NOT NULL,
  `role` enum('eleve','personnel','cuisinier','admin') NOT NULL DEFAULT 'eleve',
  `points_fidelite` int DEFAULT '0',
  `actif` tinyint(1) DEFAULT '1',
  `date_creation` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `premiere_connexion` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `login` (`login`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `utilisateurs`
--

INSERT INTO `utilisateurs` (`id`, `nom`, `prenom`, `email`, `login`, `mot_de_passe`, `role`, `points_fidelite`, `actif`, `date_creation`, `premiere_connexion`) VALUES
(1, 'Administrateur', 'Mr. Le Général', 'brayanlegendre45@gmail.com', 'admin', '$2y$10$W59FDqcbmfwYEiBdWc53Zug.0.H/hJAsDa5Mplfcc5sY3tUMt/mZa', 'admin', 1039, 1, '2026-05-06 20:38:43', 0),
(2, 'LEGENDRE', 'Brayan', 'blegendre@test.fr', 'blegendre', '$2y$10$nHKUWz8bYATEmI8EDLWjIeGKT5oBOT4mZr0mZ5uV4KAveugoUNg/G', 'admin', 200, 1, '2026-05-06 21:12:18', 0),
(3, 'Soussi', 'Tofirk', 'tsoussi@test.fr', 'tsoussi', '$2y$10$zo2vkkWvYFG/WrovBlryzejHOHKLBKtr3vfT5ndz.k1.AgUe6mR5S', 'personnel', 230, 1, '2026-05-06 21:14:38', 0),
(7, 'Burri', 'Jerome', 'jburri@test.fr', 'jburri', '$2y$10$HdDmV9OxRuwl30iH9g7V3eaZL/zSBp9NWZd9hKByOUOtPjvnXKaP2', 'cuisinier', 0, 1, '2026-05-12 10:22:20', 0),
(5, 'Aubry', 'Yassine', 'yassine@test.fr', 'yaubry', '$2y$10$BeGDNQn.vHNlon1MqS4r2OIZXBCCEXrBLvthNvS.YVAS.kPJz8ChG', 'eleve', 70, 0, '2026-05-07 09:26:32', 0);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `vue_reservations_utilisateurs`
-- (Voir ci-dessous la vue réelle)
--
DROP VIEW IF EXISTS `vue_reservations_utilisateurs`;
CREATE TABLE IF NOT EXISTS `vue_reservations_utilisateurs` (
`id` int
,`id_utilisateur` int
,`login` varchar(100)
,`nom` varchar(100)
,`prenom` varchar(100)
,`date_repas` date
,`creneau` varchar(10)
,`type_repas` varchar(50)
,`mode_consommation` varchar(50)
,`statut` varchar(50)
,`points_attribues` tinyint(1)
,`date_creation` datetime
);

-- --------------------------------------------------------

--
-- Structure de la vue `vue_reservations_utilisateurs`
--
DROP TABLE IF EXISTS `vue_reservations_utilisateurs`;

DROP VIEW IF EXISTS `vue_reservations_utilisateurs`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vue_reservations_utilisateurs`  AS SELECT `r`.`id` AS `id`, `r`.`id_utilisateur` AS `id_utilisateur`, `u`.`login` AS `login`, `u`.`nom` AS `nom`, `u`.`prenom` AS `prenom`, `r`.`date_repas` AS `date_repas`, `r`.`creneau` AS `creneau`, `r`.`type_repas` AS `type_repas`, `r`.`mode_consommation` AS `mode_consommation`, `r`.`statut` AS `statut`, `r`.`points_attribues` AS `points_attribues`, `r`.`date_creation` AS `date_creation` FROM (`reservations` `r` join `utilisateurs` `u` on((`r`.`id_utilisateur` = `u`.`id`))) ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
