SELECT 
    cp.comprador, 
    COUNT(DISTINCT a.seqproduto) AS "ITENS CADASTRADOS", 

    -- Itens em estoque
    (SELECT COUNT(DISTINCT b.seqproduto)
     FROM consinco.mrl_produtoempresa b
     JOIN consinco.map_produto p2 ON b.seqproduto = p2.seqproduto
     JOIN consinco.map_familia f2 ON p2.seqfamilia = f2.seqfamilia
     JOIN consinco.map_famdivisao fd2 ON p2.seqfamilia = fd2.seqfamilia
     WHERE b.nroempresa = 1 
       AND b.estqloja > 0
       AND fd2.seqcomprador = cp.seqcomprador
    ) AS "ITENS EM ESTOQUE",                     

    -- Itens vendidos
    (SELECT COUNT(DISTINCT c.seqproduto)
     FROM consinco.MAXV_ABCDISTRIBBASE c
     JOIN consinco.map_produto p3 ON c.seqproduto = p3.seqproduto
     JOIN consinco.map_familia f3 ON p3.seqfamilia = f3.seqfamilia
     JOIN consinco.map_famdivisao fd3 ON p3.seqfamilia = fd3.seqfamilia
     WHERE c.dtavda BETWEEN DATE '2025-07-01' AND DATE '2025-07-31'
       AND c.nroempresa = 1
       AND fd3.seqcomprador = cp.seqcomprador
    ) AS "ITENS VENDIDOS",

    -- % itens vendidos em relação ao estoque
    ROUND(
        (
            (SELECT COUNT(DISTINCT c.seqproduto)
             FROM consinco.MAXV_ABCDISTRIBBASE c
             JOIN consinco.map_produto p3 ON c.seqproduto = p3.seqproduto
             JOIN consinco.map_familia f3 ON p3.seqfamilia = f3.seqfamilia
             JOIN consinco.map_famdivisao fd3 ON p3.seqfamilia = fd3.seqfamilia
             WHERE c.dtavda BETWEEN DATE '2025-07-01' AND DATE '2025-07-31'
               AND c.nroempresa = 1
               AND fd3.seqcomprador = cp.seqcomprador
            ) /
            (SELECT COUNT(DISTINCT b.seqproduto)
             FROM consinco.mrl_produtoempresa b
             JOIN consinco.map_produto p2 ON b.seqproduto = p2.seqproduto
             JOIN consinco.map_familia f2 ON p2.seqfamilia = f2.seqfamilia
             JOIN consinco.map_famdivisao fd2 ON p2.seqfamilia = fd2.seqfamilia
             WHERE b.nroempresa = 1 
               AND b.estqloja > 0
               AND fd2.seqcomprador = cp.seqcomprador
            ) * 100
        ), 2
    ) AS "% ITENS VENDIDOS EM RELACAO AO ESTOQUE",

    -- Itens cadastrados sem estoque
    (COUNT(DISTINCT a.seqproduto) -
        (SELECT COUNT(DISTINCT b.seqproduto)
         FROM consinco.mrl_produtoempresa b
         JOIN consinco.map_produto p2 ON b.seqproduto = p2.seqproduto
         JOIN consinco.map_familia f2 ON p2.seqfamilia = f2.seqfamilia
         JOIN consinco.map_famdivisao fd2 ON p2.seqfamilia = fd2.seqfamilia
         WHERE b.nroempresa = 1 
           AND b.estqloja > 0
           AND fd2.seqcomprador = cp.seqcomprador
        )
    ) AS "ITENS CADASTRADOS SEM ESTOQUE",

    -- % itens inexistentes em relação ao cadastro
    ROUND(
        (
            (COUNT(DISTINCT a.seqproduto) -
                (SELECT COUNT(DISTINCT b.seqproduto)
                 FROM consinco.mrl_produtoempresa b
                 JOIN consinco.map_produto p2 ON b.seqproduto = p2.seqproduto
                 JOIN consinco.map_familia f2 ON p2.seqfamilia = f2.seqfamilia
                 JOIN consinco.map_famdivisao fd2 ON p2.seqfamilia = fd2.seqfamilia
                 WHERE b.nroempresa = 1 
                   AND b.estqloja > 0
                   AND fd2.seqcomprador = cp.seqcomprador
                )
            ) / COUNT(DISTINCT a.seqproduto)
        ) * 100
    , 2) AS "% ITENS INEXISTENTES EM RELACAO AO CADASTRO",

    -- Itens em estoque sem venda
    (
        (SELECT COUNT(DISTINCT b.seqproduto)
         FROM consinco.mrl_produtoempresa b
         JOIN consinco.map_produto p2 ON b.seqproduto = p2.seqproduto
         JOIN consinco.map_familia f2 ON p2.seqfamilia = f2.seqfamilia
         JOIN consinco.map_famdivisao fd2 ON p2.seqfamilia = fd2.seqfamilia
         WHERE b.nroempresa = 1 
           AND b.estqloja > 0
           AND fd2.seqcomprador = cp.seqcomprador
        ) -  
        (SELECT COUNT(DISTINCT c.seqproduto)
         FROM consinco.MAXV_ABCDISTRIBBASE c
         JOIN consinco.map_produto p3 ON c.seqproduto = p3.seqproduto
         JOIN consinco.map_familia f3 ON p3.seqfamilia = f3.seqfamilia
         JOIN consinco.map_famdivisao fd3 ON p3.seqfamilia = fd3.seqfamilia
         WHERE c.dtavda BETWEEN DATE '2025-07-01' AND DATE '2025-07-31'
           AND c.nroempresa = 1
           AND fd3.seqcomprador = cp.seqcomprador
        )
    ) AS "ITENS EM ESTOQUE SEM VENDA NO MES",

    -- % itens em estoque sem venda
    ROUND(
        (
            (
                (SELECT COUNT(DISTINCT b.seqproduto)
                 FROM consinco.mrl_produtoempresa b
                 JOIN consinco.map_produto p2 ON b.seqproduto = p2.seqproduto
                 JOIN consinco.map_familia f2 ON p2.seqfamilia = f2.seqfamilia
                 JOIN consinco.map_famdivisao fd2 ON p2.seqfamilia = fd2.seqfamilia
                 WHERE b.nroempresa = 1 
                   AND b.estqloja > 0
                   AND fd2.seqcomprador = cp.seqcomprador
                ) -  
                (SELECT COUNT(DISTINCT c.seqproduto)
                 FROM consinco.MAXV_ABCDISTRIBBASE c
                 JOIN consinco.map_produto p3 ON c.seqproduto = p3.seqproduto
                 JOIN consinco.map_familia f3 ON p3.seqfamilia = f3.seqfamilia
                 JOIN consinco.map_famdivisao fd3 ON p3.seqfamilia = fd3.seqfamilia
                 WHERE c.dtavda BETWEEN DATE '2025-07-01' AND DATE '2025-07-31'
                   AND c.nroempresa = 1
                   AND fd3.seqcomprador = cp.seqcomprador
                )
            ) /
            (SELECT COUNT(DISTINCT b.seqproduto)
             FROM consinco.mrl_produtoempresa b
             JOIN consinco.map_produto p2 ON b.seqproduto = p2.seqproduto
             JOIN consinco.map_familia f2 ON p2.seqfamilia = f2.seqfamilia
             JOIN consinco.map_famdivisao fd2 ON p2.seqfamilia = fd2.seqfamilia
             WHERE b.nroempresa = 1 
               AND b.estqloja > 0
               AND fd2.seqcomprador = cp.seqcomprador
            )
        ) * 100
    , 2) AS "% ITENS EM ESTOQUE SEM VENDA NO MES"

FROM consinco.mrl_prodempseg a
JOIN consinco.map_produto p
    ON a.seqproduto = p.seqproduto
JOIN consinco.map_familia f
    ON p.seqfamilia = f.seqfamilia
JOIN consinco.map_famdivisao fd
    ON p.seqfamilia = fd.seqfamilia
JOIN consinco.max_comprador cp
    ON fd.seqcomprador = cp.seqcomprador                    
WHERE a.nroempresa = 1 
  AND a.statusvenda = 'A' 
  AND a.nrosegmento = 1
GROUP BY cp.comprador, cp.seqcomprador
ORDER BY 1;

      
      



SELECT * FROM consinco.max_comprador

SELECT COUNT(DISTINCT A.SEQPRODUTO)
       FROM consinco.MAXV_ABCDISTRIBBASE a
       WHERE a.dtavda BETWEEN '01/jul/2025' and '31/jul/2025'
             and a.nroempresa = 1;
SELECT * FROM consinco.map_famdivcateg;
