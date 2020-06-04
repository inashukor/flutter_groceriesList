-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 04, 2020 at 05:23 PM
-- Server version: 10.4.6-MariaDB
-- PHP Version: 7.3.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `mylist`
--

-- --------------------------------------------------------

--
-- Table structure for table `categoryproduct`
--

CREATE TABLE `categoryproduct` (
  `id` int(11) NOT NULL,
  `categoryName` text DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `createdDate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `categoryproduct`
--

INSERT INTO `categoryproduct` (`id`, `categoryName`, `status`, `createdDate`) VALUES
(1, 'cooking oil', 1, '2020-06-01 00:00:00'),
(3, 'Canned Food', 1, '2020-06-03 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `favoritewithoutlogin`
--

CREATE TABLE `favoritewithoutlogin` (
  `id` int(11) NOT NULL,
  `deviceID` text DEFAULT NULL,
  `idProduct` int(11) DEFAULT NULL,
  `createdDate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `id` int(11) NOT NULL,
  `idCategory` int(11) NOT NULL,
  `productName` text DEFAULT NULL,
  `createdDate` datetime DEFAULT NULL,
  `pic` text DEFAULT NULL,
  `status` text NOT NULL,
  `description` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`id`, `idCategory`, `productName`, `createdDate`, `pic`, `status`, `description`) VALUES
(2, 1, 'cooking oil1', '2020-06-02 00:00:00', NULL, '1', 'des cooking oil 1'),
(3, 1, 'cooking oil 2', '2020-06-03 00:00:00', NULL, '1', 'des cooking oil 2');

-- --------------------------------------------------------

--
-- Table structure for table `product_retailer`
--

CREATE TABLE `product_retailer` (
  `id` int(11) NOT NULL,
  `idProduct` int(11) NOT NULL,
  `idRetailer` int(11) NOT NULL,
  `productPrice` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `product_retailer`
--

INSERT INTO `product_retailer` (`id`, `idProduct`, `idRetailer`, `productPrice`) VALUES
(1, 2, 3, 12),
(2, 2, 1, 5),
(3, 3, 3, 2);

-- --------------------------------------------------------

--
-- Table structure for table `retailer`
--

CREATE TABLE `retailer` (
  `id` int(11) NOT NULL,
  `retailerName` text DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `createdDate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `retailer`
--

INSERT INTO `retailer` (`id`, `retailerName`, `status`, `createdDate`) VALUES
(1, 'tesco', 1, '2020-06-01 00:00:00'),
(3, 'Mydin', 1, '2020-06-02 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `tmpcart`
--

CREATE TABLE `tmpcart` (
  `id` int(11) NOT NULL,
  `unikID` text DEFAULT NULL,
  `idProduct` int(11) DEFAULT NULL,
  `qty` int(11) DEFAULT NULL,
  `price` bigint(20) DEFAULT NULL,
  `createdDate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `categoryproduct`
--
ALTER TABLE `categoryproduct`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `favoritewithoutlogin`
--
ALTER TABLE `favoritewithoutlogin`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idProduct` (`idProduct`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idCategory` (`idCategory`);

--
-- Indexes for table `product_retailer`
--
ALTER TABLE `product_retailer`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idProduct` (`idProduct`),
  ADD KEY `idRetailer` (`idRetailer`);

--
-- Indexes for table `retailer`
--
ALTER TABLE `retailer`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tmpcart`
--
ALTER TABLE `tmpcart`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idProduct` (`idProduct`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `categoryproduct`
--
ALTER TABLE `categoryproduct`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `favoritewithoutlogin`
--
ALTER TABLE `favoritewithoutlogin`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `product`
--
ALTER TABLE `product`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `product_retailer`
--
ALTER TABLE `product_retailer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `retailer`
--
ALTER TABLE `retailer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `tmpcart`
--
ALTER TABLE `tmpcart`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `favoritewithoutlogin`
--
ALTER TABLE `favoritewithoutlogin`
  ADD CONSTRAINT `favoritewithoutlogin_ibfk_1` FOREIGN KEY (`idProduct`) REFERENCES `product` (`id`);

--
-- Constraints for table `product`
--
ALTER TABLE `product`
  ADD CONSTRAINT `product_ibfk_1` FOREIGN KEY (`idCategory`) REFERENCES `categoryproduct` (`id`);

--
-- Constraints for table `product_retailer`
--
ALTER TABLE `product_retailer`
  ADD CONSTRAINT `product_retailer_ibfk_1` FOREIGN KEY (`idProduct`) REFERENCES `product` (`id`),
  ADD CONSTRAINT `product_retailer_ibfk_2` FOREIGN KEY (`idRetailer`) REFERENCES `retailer` (`id`);

--
-- Constraints for table `tmpcart`
--
ALTER TABLE `tmpcart`
  ADD CONSTRAINT `tmpcart_ibfk_1` FOREIGN KEY (`idProduct`) REFERENCES `product` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
