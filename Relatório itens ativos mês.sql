SELECT COUNT(DISTINCT a.seqproduto) "ITENS CADASTRADOS", 
       (SELECT COUNT (DISTINCT b.seqproduto)
               FROM consinco.mrl_produtoempresa b
               where b.nroempresa = 1 AND
                     b.estqloja > 0) "ITENS EM ESTOQUE" ,                     
        (SELECT COUNT(DISTINCT c.SEQPRODUTO)
                FROM consinco.MAXV_ABCDISTRIBBASE c
                WHERE c.dtavda BETWEEN '01/jul/2025' and '31/jul/2025'
                and c.nroempresa = 1) "ITENS VENDIDOS",
        ROUND(((SELECT COUNT(DISTINCT c.SEQPRODUTO)
                FROM consinco.MAXV_ABCDISTRIBBASE c
                WHERE c.dtavda BETWEEN '01/jul/2025' and '31/jul/2025'
                and c.nroempresa = 1) / (SELECT COUNT (DISTINCT b.seqproduto)
               FROM consinco.mrl_produtoempresa b
               where b.nroempresa = 1 AND
                     b.estqloja > 0 )* 100),2) "% ITENS VENDIDOS EM RELACAO AO ESTOQUE",
        (COUNT(DISTINCT A.SEQPRODUTO) -
                     (SELECT COUNT (DISTINCT b.seqproduto)
                             FROM consinco.mrl_produtoempresa b
                             where b.nroempresa = 1 AND
                             b.estqloja > 0)) "ITENS CADASTRADOS SEM ESTOQUE",
         ROUND(((COUNT(DISTINCT A.SEQPRODUTO) -
                     (SELECT COUNT (DISTINCT b.seqproduto)
                             FROM consinco.mrl_produtoempresa b
                             where b.nroempresa = 1 AND
                             b.estqloja > 0)) /  COUNT(DISTINCT A.SEQPRODUTO)) * 100, 2)                             
                             "% ITENS INEXISTENTES EM RELACAO AO CADSTRO",
         (SELECT COUNT (DISTINCT b.seqproduto)
               FROM consinco.mrl_produtoempresa b
               where b.nroempresa = 1 AND
                     b.estqloja > 0) -  
                     (SELECT COUNT(DISTINCT c.SEQPRODUTO)
                FROM consinco.MAXV_ABCDISTRIBBASE c
                WHERE c.dtavda BETWEEN '01/jul/2025' and '31/jul/2025'
                and c.nroempresa = 1) "ITENS EM ESTOQUE SEM VENDA NO MES",
           ROUND(((((SELECT COUNT (DISTINCT b.seqproduto)
               FROM consinco.mrl_produtoempresa b
               where b.nroempresa = 1 AND
                     b.estqloja > 0) -  
                     (SELECT COUNT(DISTINCT c.SEQPRODUTO)
                FROM consinco.MAXV_ABCDISTRIBBASE c
                WHERE c.dtavda BETWEEN '01/jul/2025' and '31/jul/2025'
                and c.nroempresa = 1))/(SELECT COUNT (DISTINCT b.seqproduto)
               FROM consinco.mrl_produtoempresa b
               where b.nroempresa = 1 AND
                     b.estqloja > 0))*100),2) "% ITENS EM ESTOQUE SEM VENDA NO MES"
           FROM consinco.mrl_prodempseg a
WHERE a.nroempresa = 1 AND
      a.statusvenda = 'A' AND
      a.nrosegmento = 1
GROUP BY 1, 2 
ORDER BY 1;
      
      



SELECT * FROM consinco.mrl_produtoempresa a;

SELECT COUNT(DISTINCT A.SEQPRODUTO)
       FROM consinco.MAXV_ABCDISTRIBBASE a
       WHERE a.dtavda BETWEEN '01/jul/2025' and '31/jul/2025'
             and a.nroempresa = 1;

