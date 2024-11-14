-- criação do banco de dados para o cenário de e-commerce
create database ecommerce;
use ecommerce;

-- criar tabela cliente
CREATE TABLE clients (
    idClient INT AUTO_INCREMENT PRIMARY KEY,
    Fname VARCHAR(15),
    Minit CHAR(3),
    Lname VARCHAR(20),
    CPF CHAR(11) NOT NULL,
    CONSTRAINT unique_cpf_client UNIQUE (CPF),
    Address VARCHAR(30)
);

CREATE TABLE clientsPJ (
  idClientPJ INT AUTO_INCREMENT PRIMARY KEY,
    Fname VARCHAR(15),
    Minit CHAR(3),
    Lname VARCHAR(20),
    CPF CHAR(11) NOT NULL,
    CONSTRAINT unique_cpf_client UNIQUE (CPF),
    Address VARCHAR(30)

);
-- criar tabela produto
CREATE TABLE product (
    idProduct INT AUTO_INCREMENT PRIMARY KEY,
    Pname VARCHAR(15) NOT NULL,
    Classification_kids BOOL DEFAULT FALSE,
    Category ENUM('eletronico', 'moda', 'casa', 'alimentos') NOT NULL,
    Avaliation FLOAT DEFAULT 0,
    Size VARCHAR(10)
);

-- criar tabela pedido
CREATE TABLE orders (
    idOrder INT AUTO_INCREMENT PRIMARY KEY,
    idOrderClient INT,
    orderStatus ENUM('cancelado', 'confirmado', 'processando') NOT NULL DEFAULT 'processando',
    orderDescription VARCHAR(255),
    shipping FLOAT DEFAULT 10,
    paymentCash BOOL DEFAULT FALSE,
    CONSTRAINT fk_orders_client FOREIGN KEY (idOrderClient)
        REFERENCES Clients (idClient)
        ON UPDATE CASCADE
);

-- criar tabela estoque
CREATE TABLE productStorage (
    idProdStore INT AUTO_INCREMENT PRIMARY KEY,
    quantity INT DEFAULT 0,
    location VARCHAR(255)
);
-- criar tabela fornecedor
CREATE TABLE supplier (
    idSupplier INT AUTO_INCREMENT PRIMARY KEY,
    SocialName VARCHAR(255) NOT NULL,
    CNPJ CHAR(15) NOT NULL,
    contact VARCHAR(15) NOT NULL,
    CONSTRAINT unique_supplier UNIQUE (CNPJ)
);

-- criar tabela vendedor
CREATE TABLE seller (
    idSeller INT AUTO_INCREMENT PRIMARY KEY,
    SocialName VARCHAR(255) NOT NULL,
    AbstName VARCHAR(255),
    CNPJ CHAR(15) NOT NULL,
    CPF CHAR(9) NOT NULL,
    location VARCHAR(255),
    contact CHAR(11) NOT NULL,
    CONSTRAINT unique_cnpj_seller UNIQUE (CNPJ),
    CONSTRAINT unique_cpf_seller UNIQUE (CPF)
);

CREATE TABLE productSeller (
    idPseller INT,
    idPproduct INT,
    prodQuantity INT DEFAULT 1,
    PRIMARY KEY (idPseller , idProduct),
    CONSTRAINT fk_product_seller FOREIGN KEY (idPseller)
        REFERENCES seller (idSeller),
    CONSTRAINT fk_product_product FOREIGN KEY (idPproduct)
        REFERENCES product (idProduct)
);

CREATE TABLE productOrder (
    idPOproduct INT,
    idPOorder INT,
    poQuantity INT DEFAULT 1,
    poStatus ENUM('disponivel', 'sem estoque') DEFAULT 'disponivel',
    PRIMARY KEY (idPOproduct , idPOorder),
    CONSTRAINT fk_PO_seller FOREIGN KEY (idPOproduct)
        REFERENCES product (idProduct),
    CONSTRAINT fk_PO_product FOREIGN KEY (idPOorder)
        REFERENCES orders (idOrder)
);


CREATE TABLE storageLocation (
    idLproduct INT,
    idLstorage INT,
    location VARCHAR(255) NOT NULL,
    PRIMARY KEY (idLproduct , idLstorage),
    CONSTRAINT fk_storage_seller FOREIGN KEY (idLproduct)
        REFERENCES product (idProduct),
    CONSTRAINT fk_storage_product FOREIGN KEY (idLstorage)
        REFERENCES productStorage (idProdStorage)
);

CREATE TABLE productSupplier (
    idSPupplier INT,
    idPsProduct INT,
    quantity INT NOT NULL,
    CONSTRAINT fk_pSupplier_seller FOREIGN KEY (idSPupplier)
        REFERENCES supplier (idSupplier),
    CONSTRAINT fk_pSupplier_product FOREIGN KEY (idPsProduct)
        REFERENCES product (idProduct)
);

CREATE TABLE payment (
    idPayment INT,
    total FLOAT,
    PaymentStatus ENUM("Pago", "Pendente"),
    PayentSelected ENUM("Crédito", "Boleto")
);

CREATE TABLE shipping (
    idShipping int AUTO_INCREMENT PRIMARY KEY,
    idClient int,
    idClientPJ int,
    idPayment int,
    arrival DATE,
    
     CONSTRAINT fk_shipping_client FOREIGN KEY (idClient)
        REFERENCES clients (idClient),
    CONSTRAINT fk_shipping_ClientPJ FOREIGN KEY (idClientPJ)
        REFERENCES clientsPJ (idClientPJ),
	CONSTRAINT fk_shipping_payment FOREIGN KEY (idPayment)
        REFERENCES payment (idPayment)
);

SELECT c.idClient, c.Fname, c.Lname, COUNT(o.idOrder) AS totalOrders
FROM clients AS c
LEFT JOIN orders AS o ON c.idClient = o.idOrderClient
GROUP BY c.idClient;

SELECT s.SocialName AS SellerName, sp.SocialName AS SupplierName
FROM seller AS s
INNER JOIN supplier AS sp ON s.CNPJ = sp.CNPJ;

SELECT p.Pname AS ProductName, sp.SocialName AS SupplierName, ps.quantity AS StockQuantity
FROM product AS p
JOIN productSupplier AS ps ON p.idProduct = ps.idPsProduct
JOIN supplier AS sp ON ps.idSPupplier = sp.idSupplier;

SELECT sp.SocialName AS SupplierName, p.Pname AS ProductName
FROM supplier AS sp
JOIN productSupplier AS ps ON sp.idSupplier = ps.idSPupplier
JOIN product AS p ON ps.idPsProduct = p.idProduct;



show tables;

show databases;

use information_schema;

show tables;
desc referential_constraints;

select * from referential_constraints where constraint_schema = 'ecommerce';
