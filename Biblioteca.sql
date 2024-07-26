create database Biblioteca;

create table Autor(
IdAutor smallint identity,
NomeAutor varchar(50) not null,
SobrenomeAutor varchar(60) not null,
constraint pk_id_autor primary key(IdAutor));

sp_help Autor;

create table Editora(
IdEditora smallint primary key identity,
NomeEditora varchar(50) not null);

create table Assunto(
IdAssunto tinyint primary key identity,
NomeAssunto varchar(25) not null);

create table Livro(
IdLivro smallint not null primary key identity(100,1),
NomeLivro varchar(70) not null,
ISBN13 char(13) unique not null,
DataPub date,
PrecoLivro money not null,
NumeroPagina smallint not null,
IdEditora smallint not null,
IdAssunto tinyint not null,
constraint fk_id_editora foreign key (IdEditora)
  references Editora(IdEditora) on delete cascade,
constraint fk_id_assunto foreign key (IdAssunto)
  references Assunto(IdAssunto) on delete cascade,
constraint verificar_preco check(PrecoLivro >= 0));

create table LivroAutor(
IdLivro smallint not null,
IdAutor smallint not null,
constraint fk_id_livros foreign key(IdLivro) references Livro(IdLivro),
constraint fk_id_autores foreign key(IdAutor) references Autor(IdAutor),
constraint fk_autor primary key(IdLivro, IdAutor));

select name from Biblioteca.sys.tables;

-- Inserir Registro...
-- Tabela de Assuntos...
insert into Assunto (NomeAssunto)
values
('Ficção Científico'), ('Botânica'),
('Eletrônica'), ('Matemática'),
('Aventura'), ('Romance'),
('Finança'), ('Gastronomia'),
('Terror'), ('Administração'),
('Informática'), ('Suspense');

-- Verificação....
select * from Assunto;

-- Tabela de Editora...
insert into Editora(NomeEditora)
values
('Prentice Hall'), ('O´Reilly');

-- Verificação...
select * from Editora;

-- Mais editoras...
insert into Editora(NomeEditora)
values
('Aleph'), ('Microsoft'),
('Wiley'),('HarperCollins'),
('Érica'), ('Novatec'),
('McGraw-Hill'), ('Apress'),
('Globo'), ('Companhia de Letras'),
('Franscisco Alves'), ('Sybex'),
('Morro branco'), ('Penguins Books'),('Martins Claret'), 
('Oxford'),('Taschen'), ('Ediouro'),('Bookman'),
('Record'), ('Springer'), ('Melhoramentos');

-- Verificação...
select * from Editora;

-- Tabela de Autores...
-- 1) Inserir uma linha única...
insert into Autor(NomeAutor, SobrenomeAutor)
values ('Umberto', 'Eco');

-- Verificação...
select * from Autor;

-- 2) Inserir múltiplas linhas distintas (vários registros)...
insert into Autor (NomeAutor, SobrenomeAutor)
values 

('Daniel', 'Barret'), ('Gerald', 'Carter'), ('Mark', 'Sobell'),
('Willian', 'Stanek'), ('Christine', 'Bresnahan'), ('William', 'Gibson'),
('James', 'Joyce'), ('John', 'Emsley'), ('José', 'Saramago'),
('Richard', 'Silverman'), ('Robert', 'Byrnes'), ('Jay', 'Ts'),
('Robert', 'Eckstein'), ('Paul', 'Horowitz'), ('Winfield', 'Hill'),
('Joel', 'Murach'), ('Paul', 'scherz'), ('Simon', 'Monk'),
('George', 'Orwell'), ('Italo', 'Calvino'), ('Machado', 'de Assis'),
('Oliver', 'Stacks'), ('Ray', 'Bradbury'), ('Walter', 'Isaacson');

-- Verificação...
select * from Autor;

-- Tabela de Livros...
insert into Livro (NomeLivro, ISBN13, DataPub, PrecoLivro,
NumeroPagina, IdAssunto, IdEditora)
values ('A Arte da Eletrônica', '9788582604342',
'20170308', 30.74, 1160, 3, 24);

select * from Livro;

insert into Livro (NomeLivro, ISBN13, DataPub, PrecoLivro, NumeroPagina, IdAssunto, IdEditora)
values
	('Vinte Mil Léguas Submarinas', '97882850022', '2014-09-16', 24.50, 448, 1, 16), --Júlio Verne...
	('O Investidor Inteligente', '9788595080805','2016-01-05', 79.90, 450, 7, 6); -- Benjamin Graham...

-- Verificação...
select * from Livro;

--Inserir em lote (bulk) a partir de arquivos CSV...
insert into Livro (NomeLivro, ISBN13, DataPub, PrecoLivro,
NumeroPagina, IdAssunto, IdEditora)
select 
	NomeLivro, ISBN13, DataPub, PrecoLivro, NumeroPagina, 
	IdAssunto, IdEditora
from openrowset(
	bulk 'Desktop\SQL\Livros.CSV',
	formatfile = 'Desktop\SQL\Formato.xml',
	codepage = '65001', -- UTF-8
	firstrow = 2
) as LivrosCSV;

-- Verificação...
select * from Livro;

-- Tabela LivroAutor...
insert into LivroAutor(IdLivro, IdAutor)
values
(100,15),
(100,16),
(101,27),
(102,26),
(103,41),
(104,24),
(105,32),
(106,20),
(107,27),
(108,1),
(109,22),
(110,10),
(111,21),
(112,5),
(113,10),
(114,8),
(115,18),
(116,31),
(117,22);

-- Verificação...
select * from LivroAutor;

-- Verificação...
select NomeLivro, NomeAutor, SobrenomeAutor
from Livro
inner join LivroAutor
  on Livro.IdLivro = LivroAutor.IdAutor
inner join Autor
   on Autor.IdAutor = LivroAutor.IdAutor
order by NomeLivro;

-- Consulta Simples com Select...

/* Sintaxe: Select coluna(s) from tabelas; */
select NomeLivro from Livro;

select SobrenomeAutor from Autor;

select * from Autor;

select NomeLivro, PrecoLivro, ISBN13
from Livro;

select distinct IdEditora
from Livro;

-- Select into: criar uma tabela com dados de outras...
/* 
select coluna(s)
into nova_tabela
from tabela_atual 
*/

select NomeLivro, ISBN13
into LivroISBN
from Livro;

select * from LivroISBN;

drop table LivroISBN;

select NomeLivro, PrecoLivro, DataPub
from Livro;

select SobrenomeAutor
from Autor;

select NomeAssunto
from Assunto;

select NomeEditora, IdEditora
from Editora;

select distinct IdAssunto
from Livro;

select *
into LivrosFiccao
from Livro
where IdAssunto = 1;

select * from LivrosFiccao;
drop table LivrosFiccao;

-- Ordenação de Resultados em Consultas SQL:
-- Cláusulas ORDER BY....