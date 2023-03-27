CREATE DATABASE aula_udf
GO
USE aula_udf

CREATE TABLE funcionario(
codigo				 INT            NOT NULL,
nome				 VARCHAR(50)    NOT NULL,
salario				 DECIMAL(7,2)   NOT NULL
PRIMARY KEY(codigo)
)

CREATE TABLE dependente(
codigo_funcionario   INT		    NOT NULL,
nome                 VARCHAR(50)    NOT NULL,
salario              DECIMAL(7,2)   NOT NULL
PRIMARY KEY(codigo_funcionario)
FOREIGN KEY(codigo_funcionario) REFERENCES funcionario(codigo)
)
INSERT INTO funcionario VALUES
(1, 'Fulano', 4.000),
(2, 'Beltrano', 6.000)

INSERT INTO dependente VALUES
(1, 'Cicrano', 2.000),
(2, 'José', 1.000)


--1.Código de uma Function que Retorne uma tabela:
--(Nome_Funcionário, Nome_Dependente, Salário_Funcionário, Salário_Dependente)

CREATE FUNCTION fn_geral()
RETURNS @table TABLE(
nome_funcionario VARCHAR(50), 
salario_funcionario DECIMAL(7,2),
nome_dependente VARCHAR(50),
salario_dependente DECIMAL(7,2)
)
AS
BEGIN
	INSERT INTO @table(nome_funcionario,salario_funcionario, nome_dependente,salario_dependente)
			SELECT f.nome AS nome_funcionario, 
			       f.salario AS salario_funcionario,
				   d.nome AS nome_dependente,
				   d.salario AS salario_dependente
		    FROM funcionario f, dependente d
			WHERE f.codigo = d.codigo_funcionario
	RETURN
END

SELECT * FROM fn_geral()

--2.Código de uma Scalar Function que Retorne a soma dos Salários dos dependentes, mais a do funcionário.
CREATE FUNCTION fn_soma_salarios(@codigo_funcionario INT)
RETURNS DECIMAL(7,1)
AS
BEGIN
	DECLARE @salario_funcionario DECIMAL(7,2),
			@salario_dependente DECIMAL(7,2),
			@soma DECIMAL(7,1)
	
	SELECT @salario_funcionario = f.salario, @salario_dependente =  d.salario
			FROM dependente d, funcionario f
			WHERE codigo_funcionario = @codigo_funcionario

	SET @soma = @salario_funcionario + @salario_dependente 
	RETURN @soma
END

SELECT dbo.fn_soma_salarios(1) as soma

SELECT * FROM funcionario
SELECT *FROM dependente