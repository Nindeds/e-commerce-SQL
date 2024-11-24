
<?php
require_once 'vendor/autoload.php';

$host = 'localhost';
$dbname = 'e-commerce';
$username = 'root';
$password = '';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Connexion échouée : " . $e->getMessage());
}


$faker = Faker\Factory::create('fr_FR');


echo "Insertion des utilisateurs...\n";
for ($i = 0; $i < 50; $i++) {
    $nom = $faker->name;
    $email = $faker->unique()->email;
    $mot_de_passe = password_hash('password123', PASSWORD_BCRYPT);
    $telephone = $faker->phoneNumber;

    $stmt = $pdo->prepare("INSERT INTO Utilisateur (nom, email, mot_de_passe, telephone) VALUES (?, ?, ?, ?)");
    $stmt->execute([$nom, $email, $mot_de_passe, $telephone]);
}


echo "Insertion des adresses...\n";
for ($i = 1; $i <= 50; $i++) {
    for ($j = 0; $j < rand(1, 3); $j++) {
        $rue = $faker->streetAddress;
        $ville = $faker->city;
        $code_postal = $faker->postcode;
        $pays = $faker->country;

        $stmt = $pdo->prepare("INSERT INTO Adresse (user_id, rue, ville, code_postal, pays) VALUES (?, ?, ?, ?, ?)");
        $stmt->execute([$i, $rue, $ville, $code_postal, $pays]);
    }
}

echo "Insertion des produits...\n";
for ($i = 0; $i < 100; $i++) {
    $nom = $faker->word;
    $description = $faker->sentence;
    $prix = $faker->randomFloat(2, 5, 500);
    $stock = $faker->numberBetween(0, 1000);

    $stmt = $pdo->prepare("INSERT INTO Produit (nom, description, prix, stock) VALUES (?, ?, ?, ?)");
    $stmt->execute([$nom, $description, $prix, $stock]);
}


echo "Insertion des paniers...\n";
for ($i = 1; $i <= 50; $i++) {
    $stmt = $pdo->prepare("INSERT INTO Panier (user_id) VALUES (?)");
    $stmt->execute([$i]);

    $cart_id = $pdo->lastInsertId();
    for ($j = 0; $j < rand(1, 5); $j++) {
        $product_id = $faker->numberBetween(1, 100);
        $quantite = $faker->numberBetween(1, 10);

        $stmt = $pdo->prepare("INSERT INTO Panier_Produit (cart_id, product_id, quantite) VALUES (?, ?, ?)");
        $stmt->execute([$cart_id, $product_id, $quantite]);
    }
}

echo "Insertion des commandes et factures...\n";
for ($i = 1; $i <= 50; $i++) {
    $total = $faker->randomFloat(2, 20, 1000);
    $statut = $faker->randomElement(['En cours', 'Livré', 'Annulé']);
    $stmt = $pdo->prepare("INSERT INTO Commande (user_id, total, statut) VALUES (?, ?, ?)");
    $stmt->execute([$i, $total, $statut]);

    $command_id = $pdo->lastInsertId();
    $stmt = $pdo->prepare("INSERT INTO Facture (command_id, total) VALUES (?, ?)");
    $stmt->execute([$command_id, $total]);
}

echo "Données insérées avec succès !\n";
?>
