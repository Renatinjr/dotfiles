delete from cliente;
;-- -. . -..- - / . -. - .-. -.--
select * from cliente where descricao_categoria is not null;
;-- -. . -..- - / . -. - .-. -.--
select * from sync_control;
;-- -. . -..- - / . -. - .-. -.--
select * from venda where serie_nota is not null;
;-- -. . -..- - / . -. - .-. -.--
select * from produto;
;-- -. . -..- - / . -. - .-. -.--
select * from estoque;
;-- -. . -..- - / . -. - .-. -.--
select quantidade_disponivel, p.descricao_completa from estoque inner join public.produto p on p.id = estoque.id_produto;
;-- -. . -..- - / . -. - .-. -.--
select * from cliente;
;-- -. . -..- - / . -. - .-. -.--
select * from venda;
;-- -. . -..- - / . -. - .-. -.--
select * from venda order by data_emissao desc;