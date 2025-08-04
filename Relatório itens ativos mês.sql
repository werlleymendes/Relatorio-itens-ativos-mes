SELECT COUNT(DISTINCT a.seqproduto) "ITENS CADASTRADOS", 
       (SELECT COUNT (DISTINCT b.seqproduto)
               FROM consinco.mrl_produtoempresa b
               where b.nroempresa = 1 AND
                     b.estqloja > 0) "ITENS EM ESTOQUE" ,
                      
       FROM consinco.mrl_prodempseg a
WHERE a.nroempresa = 1 AND
      a.statusvenda = 'A' AND
      a.nrosegmento = 1
GROUP BY 1, 2 
ORDER BY 1;
      
      



SELECT * FROM consinco.mrl_prodempseg a 
