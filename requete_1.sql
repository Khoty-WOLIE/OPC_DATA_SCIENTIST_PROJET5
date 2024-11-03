# REQUETE 1 : En excluant les commandes annulées, quelles sont les commandesrécentes de moins de 3 mois 
            # que les clients ont reçues avec au moins 3jours de retard ?

-- Exclut les commandes annulées.
-- Sélectionne les commandes avec au moins 3 jours de retard.
-- Filtre les commandes récentes (moins de 3 mois avant le 29 août 2018).

SELECT * FROM commandes
WHERE order_status != 'canceled'
AND retard_livraison_jours >= 3
AND STR_TO_DATE(order_date, '%d/%m/%Y') >= DATE_SUB('2018-08-29', INTERVAL 3 MONTH);


