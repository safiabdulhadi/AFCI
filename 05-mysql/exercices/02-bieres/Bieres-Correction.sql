-- Récupérer la BDD dans les ressources.
--  1. Quels sont les tickets qui comportent l’article d’ID 500, afficher le numéro de  ticket uniquement ?
select NUMERO_TICKET
from ventes
where ID_ARTICLE = 500;

--  2. Afficher les tickets du 15/01/2014.
select *
from ticket
where DATE_VENTE = '2014/01/15';

--  3. Afficher les tickets émis du 15/01/2014 au 17/01/2014.
select *
from ticket
where DATE_VENTE between '2014/01/15' and '2014/01/17';

--  4. Afficher la liste des articles apparaissant à 50 et plus exemplaires sur un ticket.
select ID_ARTICLE
from ventes
where QUANTITE >= 50;

--  5. Quelles sont les tickets émis au mois de mars 2014.
select *
from ticket
where month(DATE_VENTE) = '03'
  and annee = 2014;

--  6. Quelles sont les tickets émis entre les mois de mars et avril 2014 ?
select *
from ticket
where month(DATE_VENTE) between '03' and '04'
  and annee = 2014;

--  7. Quelles sont les tickets émis au mois de mars et juin 2014 ?
select *
from ticket
where month(DATE_VENTE) = '03'
   or month(DATE_VENTE) = '06'
    and annee = 2014;

--  8. Afficher la liste des bières classée par couleur. (afficher l’id et le nom)
select a.id_article, a.nom_article
from article a
order by a.id_couleur;

--  9. Afficher la liste des bières n’ayant pas de couleur. (afficher l’id et le nom)
select a.id_article, a.nom_article
from article a
where a.id_couleur is null;

--  10. Lister pour chaque ticket la quantité totale d’articles vendus. (classer par quantité décroissante)
SELECT numero_ticket, sum(quantite) as total
FROM ventes
group by numero_ticket 
ORDER BY total DESC;

--  11. Lister chaque ticket pour lequel la quantité totale d’articles vendus est supérieure
--  à 500. (classer par quantité décroissante)
SELECT ANNEE, NUMERO_TICKET, sum(quantite) as total
FROM ventes
group by NUMERO_TICKET
having total > 500
ORDER BY total DESC;

--  12. Lister chaque ticket pour lequel la quantité totale d’articles vendus est supérieure
--  à 500. On exclura du total, les ventes ayant une quantité supérieure à 50 (classer
--  par quantité décroissante)
SELECT ANNEE, NUMERO_TICKET, sum(quantite) as total
FROM ventes
where QUANTITE <= 50
group by NUMERO_TICKET
having total > 500
order by total desc;

--  13. Lister les bières de type ‘Trappiste’. (id, nom de la bière, volume et titrage)
SELECT a.ID_ARTICLE, a.NOM_ARTICLE, a.VOLUME, a.TITRAGE
FROM article a
         left join type t on t.ID_TYPE = a.ID_TYPE
where t.NOM_TYPE = 'Trappiste';

--  14. Lister les marques de bières du continent ‘Afrique’
select m.NOM_MARQUE
from marque m
         left join pays p on p.ID_PAYS = m.ID_PAYS
         left join continent c on c.ID_CONTINENT = p.ID_CONTINENT
where c.NOM_CONTINENT = 'Afrique';

--  15. Lister les bières du continent ‘Afrique’
select a.NOM_ARTICLE
from article a
         left join marque m on m.ID_MARQUE = a.ID_MARQUE
         left join pays p on p.ID_PAYS = m.ID_PAYS
         left join continent c on c.ID_CONTINENT = p.ID_CONTINENT
where c.NOM_CONTINENT = 'Afrique';

--  16. Lister les tickets (année, numéro de ticket, montant total payé). En sachant que le
--  prix de vente est égal au prix d’achat augmenté de 15% et que l’on n’est pas
--  assujetti à la TVA.
select v.ANNEE, v.NUMERO_TICKET, round(sum((v.QUANTITE * a.PRIX_ACHAT)) * 1.15, 2) as total
from ventes v
         left join article a on a.ID_ARTICLE = v.ID_ARTICLE
group by v.NUMERO_TICKET;

--  17. Donner le C.A. par année.
select v.ANNEE, sum(round((v.QUANTITE * a.PRIX_ACHAT) * 1.15, 2)) as total
from ventes v
         left join article a on a.ID_ARTICLE = v.ID_ARTICLE
group by v.ANNEE;

--  18. Lister les quantités vendues de chaque article pour l’année 2016.
select NOM_ARTICLE, sum(QUANTITE) as total
from ventes v
         left join article a on a.ID_ARTICLE = v.ID_ARTICLE
where ANNEE = 2016
group by a.ID_ARTICLE
order by NOM_ARTICLE;

--  19. Lister les quantités vendues de chaque article pour les années 2014,2015 ,2016.
select NOM_ARTICLE, ANNEE, sum(QUANTITE) as total
from ventes v
         left join article a on a.ID_ARTICLE = v.ID_ARTICLE
where ANNEE in (2014, 2015, 2016)
group by a.ID_ARTICLE, ANNEE
order by NOM_ARTICLE, ANNEE;

--  20. Lister les articles qui n’ont fait l’objet d’aucune vente en 2014.
select a.ID_ARTICLE, a.NOM_ARTICLE from article a 
right join ventes v on a.ID_ARTICLE = v.ID_ARTICLE 
where a.ID_ARTICLE 
  not in (select ID_ARTICLE from ventes where v.ANNEE = 2014) 
group by ID_ARTICLE

--  21. Coder de 3 manières différentes la requête suivante :
--  Lister les pays qui fabriquent des bières de type ‘Trappiste’.
select NOM_PAYS
from pays p
         left join marque m on p.ID_PAYS = m.ID_PAYS
         left join article a on m.ID_MARQUE = a.ID_MARQUE
         left join type t on t.ID_TYPE = a.ID_TYPE
where t.NOM_TYPE = 'Trappiste'
group by NOM_PAYS;

select NOM_PAYS
from pays p
         left join marque m on p.ID_PAYS = m.ID_PAYS
         left join article a on m.ID_MARQUE = a.ID_MARQUE
where a.ID_TYPE = (select ID_TYPE
                   from type
                   where NOM_TYPE = 'Trappiste')
group by NOM_PAYS;

select distinct NOM_PAYS
from pays p
         left join marque m on p.ID_PAYS = m.ID_PAYS
         left join article a on m.ID_MARQUE = a.ID_MARQUE
         left join type t on t.ID_TYPE = a.ID_TYPE
where t.NOM_TYPE = 'Trappiste';

--  22. Lister les tickets sur lesquels apparaissent un des articles apparaissant aussi sur
--  le ticket 2014-856.
select concat(ANNEE, '-', NUMERO_TICKET) as idTicket
from ventes
where ID_ARTICLE in (select ID_ARTICLE
                     from ventes
                     where ANNEE = 2014
                       and NUMERO_TICKET = 856);

--  23. Lister les articles ayant un degré d’alcool plus élevé que la plus forte des
--  trappistes.
select NOM_ARTICLE, TITRAGE, VOLUME
from article
where TITRAGE > (select max(TITRAGE)
                 from article
                          left join type t on t.ID_TYPE = article.ID_TYPE
                 where NOM_TYPE = 'Trappiste')
order by TITRAGE desc;

--  24. Afficher les quantités vendues pour chaque couleur en 2014.
select c.NOM_COULEUR, sum(v.QUANTITE) as total
from ventes v
         left join article a on a.ID_ARTICLE = v.ID_ARTICLE
         left join couleur c on c.ID_Couleur = a.ID_Couleur
where ANNEE = 2014
group by c.NOM_COULEUR
order by total desc;

select c.NOM_COULEUR, sum(v.QUANTITE) as total
from ventes v
         NATURAL join article a
         NATURAL join couleur c
where ANNEE = 2014
group by c.NOM_COULEUR
order by total desc;
--  25. Donner pour chaque fabricant, le nombre de tickets sur lesquels apparait un de
--  ses produits en 2014.
select count(t.NUMERO_TICKET) as total, f.NOM_FABRICANT
from ticket t
         left join ventes v on t.ANNEE = v.ANNEE and t.NUMERO_TICKET = v.NUMERO_TICKET
         left join article a on a.ID_ARTICLE = v.ID_ARTICLE
         left join marque m on m.ID_MARQUE = a.ID_MARQUE
         left join fabricant f on f.ID_FABRICANT = m.ID_FABRICANT
where t.ANNEE = 2014
group by f.NOM_FABRICANT
order by f.NOM_FABRICANT;

-- 26. Donner l’ID, le nom, le volume et la quantité vendue des 20 bières les plus  vendus en 2016.
select a.ID_ARTICLE, a.NOM_ARTICLE, a.VOLUME, sum(v.QUANTITE) total
from article a
         left join ventes v on a.ID_ARTICLE = v.ID_ARTICLE
where v.annee = 2016
group by  a.NOM_ARTICLE
order by total desc
limit 20;

--  27. Donner l’ID, le nom, le volume et la quantité vendue des 5 ‘Trappistes’ les plus vendus en 2016.
select a.ID_ARTICLE, a.NOM_ARTICLE, a.VOLUME, sum(v.QUANTITE) total
from article a
         left join ventes v on a.ID_ARTICLE = v.ID_ARTICLE
         NATURAL JOIN type t
where v.annee = 2016 AND t.NOM_TYPE = 'Trappiste'
group by  a.NOM_ARTICLE
order by total desc
limit 5;

--  28. Donner l’ID, le nom, le volume et les quantité vendues en 2015 et 2016, des
--  bières dont les ventes ont été stables. (moins de 1% de variation)
select ID_ARTICLE, NOM_ARTICLE,VOLUME,
       (select sum(quantite) from ventes where ID_ARTICLE = A.ID_ARTICLE and ANNEE = 2015) as '2015',
       (select sum(quantite) from ventes where ID_ARTICLE = A.ID_ARTICLE and ANNEE = 2016) as '2016'
from article as A
where cast((select sum(quantite) from ventes where ID_ARTICLE = A.ID_ARTICLE and ANNEE = 2016) -
           (select sum(quantite) from ventes where ID_ARTICLE = A.ID_ARTICLE and ANNEE = 2015) as float) /
      (select sum(quantite) from ventes where ID_ARTICLE = A.ID_ARTICLE and ANNEE = 2015) * 100 between -1 and 1
order by A.ID_ARTICLE;

--  29. Lister les types de bières suivant l’évolution de leurs ventes entre 2015 et 2016.
--  Classer le résultat par ordre décroissant des performances.
select ID_TYPE, NOM_TYPE,
       (ROUND(cast((select sum(quantite)
                from ventes where annee = 2016
                  and ID_article in (select ID_article
                                    from article where ID_TYPE = t.id_type))
              - (select sum(quantite) from ventes
                where annee = 2015
                  and ID_article in (select ID_article
                                  from article where ID_TYPE = t.id_type))
          as float) / (select sum(quantite)
          from ventes where annee = 2015
          and ID_article in (select ID_article
                              from article where ID_TYPE = t.id_type))
      * 100,2)) as evolution
from type t
order by evolution desc

--  30. Existe-t-il des tickets sans vente ?
select ANNEE, NUMERO_TICKET
from ticket
where concat(ANNEE, NUMERO_TICKET) not in
    (select concat(ANNEE, NUMERO_TICKET) from ventes);

--  31. Lister les produits vendus en 2016 dans des quantités jusqu’à -15% des quantités
--  de l’article le plus vendu.
select a.ID_ARTICLE,
    NOM_ARTICLE,
    (select sum(QUANTITE) from ventes where ANNEE = 2016 and ID_ARTICLE = a.ID_ARTICLE) as qte
from article a
where (select sum(QUANTITE) from ventes where ANNEE = 2016 and ID_ARTICLE = a.ID_ARTICLE)
        >=
      (select sum(QUANTITE)as q from ventes where ANNEE = 2016 group by ID_ARTICLE order by q desc limit 1) * 0.85
order by qte desc;

--  IV LES BESOINS DE MISE A JOUR
--  32. Appliquer une augmentation de tarif de 10% pour toutes les bières ‘Trappistes’ de couleur ‘Blonde’
update article
set PRIX_ACHAT = PRIX_ACHAT * 1.1
where ID_Couleur = (select ID_Couleur
                    from couleur
                    where NOM_COULEUR = 'Blonde')
AND ID_TYPE = (select type.ID_TYPE from type where NOM_TYPE = 'Trappistes');

--  33. Mettre à jour le degré d’alcool des toutes les bières n’ayant pas cette information.
--  On y mettra le degré d’alcool de la moins forte des bières du même type et de même couleur.
UPDATE article a SET TITRAGE = (SELECT MIN(TITRAGE) FROM article WHERE a.ID_Couleur = ID_Couleur AND a.ID_TYPE = ID_TYPE) 
WHERE TITRAGE IS NULL;
-- VERSION compliqué qui prend en compte couleur et type séparé :
UPDATE article a SET TITRAGE = 
IF((SELECT MIN(TITRAGE) FROM article WHERE a.ID_Couleur = ID_Couleur AND a.ID_TYPE = ID_TYPE) IS NOT NULL,
  	(SELECT MIN(TITRAGE) FROM article WHERE a.ID_Couleur = ID_Couleur AND a.ID_TYPE = ID_TYPE),
  IF((SELECT MIN(TITRAGE) FROM article WHERE a.ID_TYPE = ID_TYPE) IS NOT NULL,
    (SELECT MIN(TITRAGE) FROM article WHERE a.ID_TYPE = ID_TYPE),
    IF((SELECT MIN(TITRAGE) FROM article WHERE a.ID_Couleur = ID_Couleur) IS NOT NULL,
      (SELECT MIN(TITRAGE) FROM article WHERE a.ID_Couleur = ID_Couleur),
      (SELECT MIN(TITRAGE) FROM article)))) 
WHERE TITRAGE IS NULL;

--  34. Suppression des bières qui ne sont pas des bières ! (type ‘Bière Aromatisée’)
delete
from article
where ID_TYPE = (select ID_TYPE from type where NOM_TYPE = 'Bière Aromatisée')

--  35. Supprimer les tickets qui n’ont pas de ventes.
delete
from ticket
where NUMERO_TICKET not in (select NUMERO_TICKET from ventes);
