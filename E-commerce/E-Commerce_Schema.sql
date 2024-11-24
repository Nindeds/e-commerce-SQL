-- Création de la table Utilisateur
CREATE TABLE Utilisateur (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    mot_de_passe VARCHAR(255) NOT NULL,
    telephone VARCHAR(15)
);

-- Création de la table Adresse
CREATE TABLE Adresse (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    rue VARCHAR(255) NOT NULL,
    ville VARCHAR(100) NOT NULL,
    code_postal VARCHAR(10) NOT NULL,
    pays VARCHAR(100) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Utilisateur(user_id) ON DELETE CASCADE
);

-- Création de la table Produit
CREATE TABLE Produit (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    description TEXT,
    prix DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL
);

-- Création de la table Panier
CREATE TABLE Panier (
    cart_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Utilisateur(user_id) ON DELETE CASCADE
);

-- Création de la table Panier_Produit 
CREATE TABLE Panier_Produit (
    cart_id INT NOT NULL,
    product_id INT NOT NULL,
    quantite INT NOT NULL,
    PRIMARY KEY (cart_id, product_id),
    FOREIGN KEY (cart_id) REFERENCES Panier(cart_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Produit(product_id) ON DELETE CASCADE
);

-- Création de la table Commande
CREATE TABLE Commande (
    command_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    total DECIMAL(10, 2) NOT NULL,
    statut VARCHAR(50) NOT NULL,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Utilisateur(user_id) ON DELETE CASCADE
);

-- Création de la table Commande_Produit 
CREATE TABLE Commande_Produit (
    command_id INT NOT NULL,
    product_id INT NOT NULL,
    quantite INT NOT NULL,
    PRIMARY KEY (command_id, product_id),
    FOREIGN KEY (command_id) REFERENCES Commande(command_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Produit(product_id) ON DELETE CASCADE
);

-- Création de la table Facture
CREATE TABLE Facture (
    invoice_id INT AUTO_INCREMENT PRIMARY KEY,
    command_id INT NOT NULL,
    total DECIMAL(10, 2) NOT NULL,
    date_emission TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (command_id) REFERENCES Commande(command_id) ON DELETE CASCADE
);

-- Création de la table Photo (optionnelle)
CREATE TABLE Photo (
    photo_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    product_id INT,
    url VARCHAR(255) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Utilisateur(user_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Produit(product_id) ON DELETE CASCADE
);

-- Création de la table Évaluation (optionnelle)
CREATE TABLE Evaluation (
    rate_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    note INT CHECK (note BETWEEN 1 AND 5),
    commentaire TEXT,
    FOREIGN KEY (user_id) REFERENCES Utilisateur(user_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Produit(product_id) ON DELETE CASCADE
);

--Création de la table Paiement (optionnelle)
CREATE TABLE Paiement (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    numero_carte VARCHAR(16) NOT NULL,
    iban VARCHAR(34),
    date_expiration DATE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Utilisateur(user_id) ON DELETE CASCADE
);
