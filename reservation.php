<?php
// Démarre la session et charge la connexion à la base de données
session_start();
require_once("config/conf_server.php");

// Vérifie que l'utilisateur est connecté
if (!isset($_SESSION["id"])) {
    header("Location: index.php");
    exit();
}

// Variables pour afficher les messages
$message = "";
$erreur = "";

// Récupération des données du formulaire
$date_repas = trim($_POST["date"] ?? '');
$creneau = trim($_POST["creneau"] ?? '');
$type_repas = trim($_POST["typeRepas"] ?? '');
$mode = trim($_POST["mode"] ?? '');

// Traite le formulaire après envoi
if ($_SERVER["REQUEST_METHOD"] === "POST") {
    // Récupère l'identifiant de l'utilisateur connecté
    $id_utilisateur = $_SESSION["id"];

    // Vérifie que tous les champs sont remplis
    if (!empty($date_repas) && !empty($creneau) && !empty($type_repas) && !empty($mode)) {
        try {
            // Démarre une transaction
            $conn->beginTransaction();

            // Récupère le quota du créneau choisi
            $sqlQuota = "SELECT quota_max
                         FROM creneaux
                         WHERE heure = :creneau
                         LIMIT 1";
            $stmtQuota = $conn->prepare($sqlQuota);
            $stmtQuota->execute([
                ':creneau' => $creneau
            ]);
            $quotaData = $stmtQuota->fetch(PDO::FETCH_ASSOC);

            // Vérifie que le créneau existe
            if (!$quotaData) {
                throw new Exception("Créneau invalide.");
            }

            $quota_max = (int)$quotaData["quota_max"];

            // Vérifie si l'utilisateur a déjà une réservation à cette date
            $sqlDejaReserve = "SELECT COUNT(*)
                               FROM reservations
                               WHERE id_utilisateur = :id_utilisateur
                               AND date_repas = :date_repas";
            $stmtDejaReserve = $conn->prepare($sqlDejaReserve);
            $stmtDejaReserve->execute([
                ':id_utilisateur' => $id_utilisateur,
                ':date_repas' => $date_repas
            ]);

            if ($stmtDejaReserve->fetchColumn() > 0) {
                throw new Exception("Vous avez déjà une réservation pour cette date.");
            }

            // Compte les réservations déjà prises sur ce créneau
            $sqlCount = "SELECT COUNT(*)
                         FROM reservations
                         WHERE date_repas = :date_repas
                         AND creneau = :creneau
                         AND statut IN ('validee', 'en_attente')";
            $stmtCount = $conn->prepare($sqlCount);
            $stmtCount->execute([
                ':date_repas' => $date_repas,
                ':creneau' => $creneau
            ]);
            $nombre_reservations = (int)$stmtCount->fetchColumn();

            // Bloque la réservation si le quota est atteint
            if ($nombre_reservations >= $quota_max) {
                throw new Exception("Ce créneau est complet. Veuillez en choisir un autre.");
            }

            // Enregistre la réservation
            $sqlReservation = "INSERT INTO reservations
                (id_utilisateur, date_repas, creneau, type_repas, mode_consommation, statut, points_attribues, date_creation)
                VALUES (:id_utilisateur, :date_repas, :creneau, :type_repas, :mode_consommation, 'validee', 10, NOW())";

            $stmtReservation = $conn->prepare($sqlReservation);
            $stmtReservation->execute([
                ':id_utilisateur' => $id_utilisateur,
                ':date_repas' => $date_repas,
                ':creneau' => $creneau,
                ':type_repas' => $type_repas,
                ':mode_consommation' => $mode
            ]);

            // Ajoute 10 points de fidélité
            $sqlPoints = "UPDATE utilisateurs
                          SET points_fidelite = points_fidelite + 10
                          WHERE id = :id_utilisateur";
            $stmtPoints = $conn->prepare($sqlPoints);
            $stmtPoints->execute([
                ':id_utilisateur' => $id_utilisateur
            ]);

            // Valide la transaction
            $conn->commit();
            $message = "Réservation effectuée avec succès ! 10 points de fidélité ajoutés.";

            // Réinitialise les champs du formulaire
            $date_repas = '';
            $creneau = '';
            $type_repas = '';
            $mode = '';

        } catch (Exception $e) {
            // Annule la transaction en cas d'erreur
            if ($conn->inTransaction()) {
                $conn->rollBack();
            }
            $erreur = "Erreur lors de la réservation : " . $e->getMessage();
        }
    } else {
        // Message si un champ est vide
        $erreur = "Veuillez remplir tous les champs.";
    }
}
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Réservation - Restaurant PSR EREA</title>
    <link rel="stylesheet" href="reservation.css">
</head>
<body>
    <!-- Bouton de retour vers l'accueil -->
    <div class="button-container">
        <button class="button-9" onclick="window.location.href='accueil.php'" role="button">Accueil</button>
    </div>

    <!-- Conteneur principal -->
    <div class="container">
        <!-- Titre de la page -->
        <h1>Réservation de Repas</h1>

        <!-- Formulaire de réservation -->
        <form method="POST" action="">
            <div class="form-group">
                <label for="date">Date du repas :</label>
                <input
                    type="date"
                    id="date"
                    name="date"
                    value="<?php echo htmlspecialchars($date_repas); ?>"
                    required
                >
            </div>

            <div class="form-group">
                <label for="creneau">Créneau horaire :</label>
                <select
                    id="creneau"
                    name="creneau"
                    required
                    data-selected="<?php echo htmlspecialchars($creneau); ?>"
                >
                    <option value="">Sélectionnez d'abord une date</option>
                </select>
                <small id="creneau-info"></small>
            </div>

            <div class="form-group">
                <label for="typeRepas">Type de repas :</label>
                <select id="typeRepas" name="typeRepas" required>
                    <option value="">Sélectionnez un type</option>
                    <option value="standard" <?php echo ($type_repas === 'standard') ? 'selected' : ''; ?>>
                        Standard
                    </option>
                    <option value="vegetarien" <?php echo ($type_repas === 'vegetarien') ? 'selected' : ''; ?>>
                        Végétarien
                    </option>
                    <option value="sans-porc" <?php echo ($type_repas === 'sans-porc') ? 'selected' : ''; ?>>
                        Sans porc
                    </option>
                </select>
            </div>

            <div class="form-group">
                <label>Mode de consommation :</label>
                <div class="radio-group">
                    <div class="radio-option">
                        <input
                            type="radio"
                            id="sur-place"
                            name="mode"
                            value="sur-place"
                            <?php echo ($mode === 'sur-place') ? 'checked' : ''; ?>
                            required
                        >
                        <label for="sur-place">Sur place</label>
                    </div>

                    <div class="radio-option">
                        <input
                            type="radio"
                            id="emporter"
                            name="mode"
                            value="emporter"
                            <?php echo ($mode === 'emporter') ? 'checked' : ''; ?>
                        >
                        <label for="emporter">À emporter</label>
                    </div>
                </div>
            </div>

            <button type="submit" class="btn-submit">Réserver</button>
        </form>

        <!-- Message de succès -->
        <?php if (!empty($message)) : ?>
            <div class="success-message show">
                <?php echo htmlspecialchars($message); ?>
            </div>
        <?php endif; ?>

        <!-- Message d'erreur -->
        <?php if (!empty($erreur)) : ?>
            <div class="success-message show" style="background-color:#f8d7da; color:#721c24;">
                <?php echo htmlspecialchars($erreur); ?>
            </div>
        <?php endif; ?>
    </div>

    <!-- Script qui charge les créneaux disponibles -->
    <script src="reservation.js"></script>
</body>
</html>