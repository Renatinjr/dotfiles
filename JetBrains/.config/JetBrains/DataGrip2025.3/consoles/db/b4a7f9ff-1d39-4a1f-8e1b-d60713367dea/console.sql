select quantidade_disponivel, p.descricao_completa from estoque inner join public.produto p on p.id = estoque.id_produto
