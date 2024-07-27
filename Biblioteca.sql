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
('Fic��o Cient�fico'), ('Bot�nica'),
('Eletr�nica'), ('Matem�tica'),
('Aventura'), ('Romance'),
('Finan�a'), ('Gastronomia'),
('Terror'), ('Administra��o'),
('Inform�tica'), ('Suspense');

-- Verifica��o....
select * from Assunto;

-- Tabela de Editora...
insert into Editora(NomeEditora)
values
('Prentice Hall'), ('O�Reilly');

-- Verifica��o...
select * from Editora;

-- Mais editoras...
insert into Editora(NomeEditora)
values
('Aleph'), ('Microsoft'),
('Wiley'),('HarperCollins'),
('�rica'), ('Novatec'),
('McGraw-Hill'), ('Apress'),
('Globo'), ('Companhia de Letras'),
('Franscisco Alves'), ('Sybex'),
('Morro branco'), ('Penguins Books'),('Martins Claret'), 
('Oxford'),('Taschen'), ('Ediouro'),('Bookman'),
('Record'), ('Springer'), ('Melhoramentos');

-- Verifica��o...
select * from Editora;

-- Tabela de Autores...
-- 1) Inserir uma linha �nica...
insert into Autor(NomeAutor, SobrenomeAutor)
values ('Umberto', 'Eco');

-- Verifica��o...
select * from Autor;

-- 2) Inserir m�ltiplas linhas distintas (v�rios registros)...
insert into Autor (NomeAutor, SobrenomeAutor)
values 

('Daniel', 'Barret'), ('Gerald', 'Carter'), ('Mark', 'Sobell'),
('Willian', 'Stanek'), ('Christine', 'Bresnahan'), ('William', 'Gibson'),
('James', 'Joyce'), ('John', 'Emsley'), ('Jos�', 'Saramago'),
('Richard', 'Silverman'), ('Robert', 'Byrnes'), ('Jay', 'Ts'),
('Robert', 'Eckstein'), ('Paul', 'Horowitz'), ('Winfield', 'Hill'),
('Joel', 'Murach'), ('Paul', 'scherz'), ('Simon', 'Monk'),
('George', 'Orwell'), ('Italo', 'Calvino'), ('Machado', 'de Assis'),
('Oliver', 'Stacks'), ('Ray', 'Bradbury'), ('Walter', 'Isaacson');

-- Verifica��o...
select * from Autor;

-- Tabela de Livros...
insert into Livro (NomeLivro, ISBN13, DataPub, PrecoLivro,
NumeroPagina, IdAssunto, IdEditora)
values ('A Arte da Eletr�nica', '9788582604342',
'20170308', 30.74, 1160, 3, 24);

select * from Livro;

insert into Livro (NomeLivro, ISBN13, DataPub, PrecoLivro, NumeroPagina, IdAssunto, IdEditora)
values
	('Vinte Mil L�guas Submarinas', '97882850022', '2014-09-16', 24.50, 448, 1, 16), --J�lio Verne...
	('O Investidor Inteligente', '9788595080805','2016-01-05', 79.90, 450, 7, 6); -- Benjamin Graham...

-- Verifica��o...
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

-- Verifica��o...
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

-- Verifica��o...
select * from LivroAutor;

-- Verifica��o...
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

-- Ordena��o de Resultados em Consultas SQL:
-- Cl�usulas ORDER BY....

/* Sintaxe...
select coluna
from tabela 
order by coluna_a_ordenar [ASC | DESC]
*/

-- Exemplos
select * from Livro
order by NomeLivro;

select NomeLivro, IdEditora
from Livro
order by IdEditora;

select NomeLivro, PrecoLivro
from Livro
order by PrecoLivro desc;

select NomeLivro, PrecoLivro
from Livro
order by PrecoLivro asc, IdEditora desc;

-- Restri��o de Resultados: select top...
/*  Sintaxe:
select top (n�mero | PERTENC) colunas 
from tabelas
order by
*/

-- Exemplos
select top (2) NomeLivro
from Livro;
-- order by NomeLivro;
select * from Livro;

-- Exemplo Percentual...
select top (15) percent NomeLivro
from Livro
order by NomeLivro;

select top (3) NomeLivro
from Livro
order by NomeLivro desc;

select top (4) NomeLivro, PrecoLivro
from Livro
order by PrecoLivro desc;

-- sem whith ties - Ver sem os IdAssuntos do livros que est�o relacionados no banco de dados...
select top (3) NomeLivro, IdLivro
from Livro
order by IdAssunto desc;

-- com whith ties - Ver sem os IdAssuntos do livros que est�o relacionados no banco de dados...
select top (3) with ties NomeLivro, IdAssunto
from Livro
order by IdAssunto desc;

-- Filtrar Resultados de Consultas com where...

/* Sintaxe...
select colunas
from tabelas
where coluna [operador] valor
[order by]
*/

select NomeLivro, DataPub
from Livro
where IdEditora = 3;

select IdAutor, NomeAutor
from Autor
where SobrenomeAutor = 'Vernes';

select NomeLivro,PrecoLivro
from Livro
where PrecoLivro > 100.00
order by PrecoLivro;

select NomeLivro, DataPub
from Livro
where IdEditora = (
	 select IdEditora
	 from Editora
	 where NomeEditora = 'Aleph'
)
order by NomeLivro;