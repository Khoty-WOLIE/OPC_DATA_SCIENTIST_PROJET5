# REQUETE 4: Quels sont les 5 codes postaux, enregistrant plus de 30 reviews, avec le pire review score moyen sur 
             # les 12 derniers mois ?
             
-- Étape 1 : Filtrer les reviews pour les 12 derniers mois disponibles dans les données
WITH LastYearReviews AS (
    SELECT 
        customer_zip_code_prefix,  -- Code postal du client
        review_score,  -- Score de la review
        STR_TO_DATE(review_creation_date, '%d/%m/%Y') AS review_date  -- Conversion de la date de création de la review
    FROM 
        merge_client_commande_review
    WHERE 
        -- Filtrer les dates entre le 31 août 2017 et le 31 août 2018
        STR_TO_DATE(review_creation_date, '%d/%m/%Y') BETWEEN '2017-08-31' AND '2018-08-31'
)

-- Étape 2 : Grouper par code postal pour obtenir le nombre de reviews et le score moyen
, ReviewsSummary AS (
    SELECT 
        customer_zip_code_prefix,  -- Code postal du client
        COUNT(review_score) AS review_count,  -- Nombre de reviews
        AVG(review_score) AS avg_review_score  -- Score moyen des reviews
    FROM 
        LastYearReviews
    GROUP BY 
        customer_zip_code_prefix  -- Grouper par code postal
)

-- Étape 3 : Filtrer les codes postaux avec plus de 10 reviews et sélectionner les 5 pires scores moyens
SELECT 
    customer_zip_code_prefix,  -- Code postal du client
    review_count,  -- Nombre de reviews
    avg_review_score  -- Score moyen des reviews
FROM 
    ReviewsSummary
WHERE 
    review_count > 10  -- Filtrer pour obtenir les codes postaux avec plus de 10 reviews
ORDER BY 
    avg_review_score ASC  -- Trier par score moyen croissant
LIMIT 5;  -- Sélectionner les 5 premiers résultats
