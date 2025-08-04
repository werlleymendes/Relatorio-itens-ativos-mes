SELECT COUNT(DISTINCT a.seqproduto) "ITENS CADASTRADOS", 
       (SELECT COUNT (DISTINCT b.seqproduto)
               FROM consinco.mrl_produtoempresa b
               where b.nroempresa = 1 AND
                     b.estqloja > 0) "ITENS EM ESTOQUE" ,
        (SELECT COUNT (DISTINCT c.seqproduto)
               FROM consinco.mrl_produtoempresa c
               where c.nroempresa = 1 AND
                     TRUNC(c.dtaultvenda) >= '01-jul-2025' ) "ITENS VENDIDOS"        
       FROM consinco.mrl_prodempseg a
WHERE a.nroempresa = 1 AND
      a.statusvenda = 'A' AND
      a.nrosegmento = 1
GROUP BY 1, 2 
ORDER BY 1;
      
      



SELECT * FROM consinco.mrl_produtoempresa a

SELECT * FROM consinco.MAXV_ABCDISTRIBBASE a

