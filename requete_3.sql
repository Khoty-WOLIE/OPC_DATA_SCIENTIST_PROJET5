# REQUETE 3: Qui sont les nouveaux vendeurs (moins de 3 mois d'ancienneté) quisont déjà très engagés 
            # avec la plateforme (ayant déjà vendu plus de 30 produits) ?

# Calculer l'ancienneté de chaque vendeur.
# Identifier les nouveaux vendeurs (moins de 3 mois d'ancienneté).
# Compter le nombre de produits vendus par ces nouveaux vendeurs.
# Sélectionner ceux qui ont vendu plus de 30 produits.

-- Étape 1 : Convertir le format de date dans la table commandes
DROP TEMPORARY TABLE IF EXISTS commandes_converted;
CREATE TEMPORARY TABLE commandes_converted AS
SELECT 
    *,
    STR_TO_DATE(order_date, '%d/%m/%Y') AS converted_order_date
FROM 
    commandes;

-- Étape 2 : Fusionner les tables commandes et produits pour obtenir les données des vendeurs et calculer la date de première vente et l'ancienneté en mois
DROP TEMPORARY TABLE IF EXISTS seller_with_seniority;
CREATE TEMPORARY TABLE seller_with_seniority AS
SELECT 
    p.seller_id, 
    p.product_id, 
    cc.converted_order_date AS order_date,
    MIN(cc.converted_order_date) OVER (PARTITION BY p.seller_id) AS first_sale_date,
    TIMESTAMPDIFF(MONTH, MIN(cc.converted_order_date) OVER (PARTITION BY p.seller_id), cc.converted_order_date) AS seniority_months
FROM 
    commandes_converted cc
JOIN 
    produits p ON cc.order_id = p.order_id;

-- Étape 3 : Identifier les nouveaux vendeurs (moins de 3 mois d'ancienneté) et compter le nombre de produits vendus par eux
DROP TEMPORARY TABLE IF EXISTS new_sellers;
CREATE TEMPORARY TABLE new_sellers AS
SELECT 
    seller_id,
    COUNT(product_id) AS product_count
FROM 
    seller_with_seniority
WHERE 
    seniority_months < 3
GROUP BY 
    seller_id
HAVING 
    COUNT(product_id) > 30;

-- Étape 4 : Sélectionner les nouveaux vendeurs engagés
SELECT * FROM new_sellers;