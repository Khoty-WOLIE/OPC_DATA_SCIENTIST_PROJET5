# REQUETE 2: Qui sont les vendeurs ayant généré un chiffre d'affaires de plus de 100000 Real sur 
           # des commandes livrées via Olist ?

-- Étape 1: Joindre les tables commandes et produits sur order_id
-- Étape 2: Filtrer les commandes livrées
-- Étape 3: Calculer le chiffre d'affaires pour chaque vendeur
-- Étape 4: Filtrer les vendeurs ayant généré plus de 100 000 Real

SELECT 
    p.seller_id,
    SUM(p.price) AS total_revenue
FROM 
    commandes c
JOIN 
    produits p ON c.order_id = p.order_id
WHERE 
    c.order_status = 'delivered'
GROUP BY 
    p.seller_id
HAVING 
    total_revenue > 100000;
