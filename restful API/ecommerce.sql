-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 08, 2020 at 04:11 AM
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
-- Database: `ecommerce`
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
(3, 'Canned Food', 1, '2020-06-01 00:00:00'),
(4, 'Cooking Oil', 1, '2020-06-01 00:00:00'),
(5, 'Noodles', 1, '2020-06-02 00:00:00'),
(6, 'Cereal', 1, '2020-06-02 00:00:00');

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
-- Table structure for table `list`
--

CREATE TABLE `list` (
  `id` int(11) NOT NULL,
  `noList` text DEFAULT NULL,
  `createdDate` datetime DEFAULT NULL,
  `idUsers` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `list`
--

INSERT INTO `list` (`id`, `noList`, `createdDate`, `idUsers`, `status`) VALUES
(15, '20200608123422', '2020-06-08 06:34:22', 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `listdetail`
--

CREATE TABLE `listdetail` (
  `id` int(11) NOT NULL,
  `noList` text DEFAULT NULL,
  `idProduct` int(11) DEFAULT NULL,
  `qty` int(11) DEFAULT NULL,
  `price` bigint(20) DEFAULT NULL,
  `discount` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `listdetail`
--

INSERT INTO `listdetail` (`id`, `noList`, `idProduct`, `qty`, `price`, `discount`) VALUES
(5, '20200608123422', 4, 2, 8, 0),
(6, '20200608123422', 3, 1, 2, 0),
(7, '20200608123422', 2, 2, 5, 0);

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `id` int(11) NOT NULL,
  `idCategory` int(11) NOT NULL,
  `productName` text DEFAULT NULL,
  `productPrice` int(11) NOT NULL,
  `createdDate` datetime DEFAULT NULL,
  `pic` text DEFAULT NULL,
  `status` text NOT NULL,
  `description` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`id`, `idCategory`, `productName`, `productPrice`, `createdDate`, `pic`, `status`, `description`) VALUES
(2, 3, 'Canned food 1', 5, '2020-06-07 04:03:33', '06062020220333image_picker-736668986.jpg', '1', 'des Canned food 1'),
(3, 3, 'Canned food 2', 2, '2020-06-08 05:10:20', '07062020231020image_picker-1318080179.jpg', '1', 'des canned food 2'),
(4, 3, 'Canned food3', 8, '2020-06-08 05:54:55', '07062020235455image_picker-1318080179.jpg', '1', 'des canned food3'),
(6, 4, 'cooking oil 1', 10, '2020-06-08 08:58:26', '08062020025826image_picker1310530434.jpg', '1', 'des cooking oil 1'),
(7, 4, 'cooking oil 2', 6, '2020-06-08 08:59:21', '08062020025921image_picker-1164553724.jpg', '1', 'des cooking oil 2');

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

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `email` text DEFAULT NULL,
  `phone` text DEFAULT NULL,
  `name` text NOT NULL,
  `createdDate` datetime DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `level` int(11) DEFAULT NULL,
  `kode` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `email`, `phone`, `name`, `createdDate`, `status`, `level`, `kode`) VALUES
(1, 'inaabdul06@gmail.com', '016994665', 'ina', '2020-06-07 22:23:35', 1, 1, 'd-csOJx2_Pc:APA91bHgp3sjr6nm1arvy88iqQFYJM5-H2XSnx-FgrNIwLlo7Yo_8G0JBowevDPOZBY-EQPtcAXlM29YSKU9z3VdpL7SqfiYj4FePjtfYcC8Ht_mmA-POzcULu0tnEYC2gSgs7jrh3Lz'),
(2, 'ishukor51@gmail.com', '9768846691', 'alia', '2020-06-08 01:11:38', 1, 1, 'fAh3PQ5mM9w:APA91bH4j_TpEuUrSCoKzJEiYQv-gksfE__GBbNMzrPx13GGowa4BJXnCZiJdCWHI8L6b50k9VIK-hjvycV7VzVu8js8cL65R_wOxLCeNqV8GIW0b0Cu_oouvl9cnhmITVwMW9dhKKy9');

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
-- Indexes for table `list`
--
ALTER TABLE `list`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idUsers` (`idUsers`);

--
-- Indexes for table `listdetail`
--
ALTER TABLE `listdetail`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idProduct` (`idProduct`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idCategory` (`idCategory`);

--
-- Indexes for table `tmpcart`
--
ALTER TABLE `tmpcart`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idProduct` (`idProduct`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `categoryproduct`
--
ALTER TABLE `categoryproduct`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `favoritewithoutlogin`
--
ALTER TABLE `favoritewithoutlogin`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `list`
--
ALTER TABLE `list`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `listdetail`
--
ALTER TABLE `listdetail`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `product`
--
ALTER TABLE `product`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `tmpcart`
--
ALTER TABLE `tmpcart`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `favoritewithoutlogin`
--
ALTER TABLE `favoritewithoutlogin`
  ADD CONSTRAINT `favoritewithoutlogin_ibfk_1` FOREIGN KEY (`idProduct`) REFERENCES `product` (`id`);

--
-- Constraints for table `list`
--
ALTER TABLE `list`
  ADD CONSTRAINT `list_ibfk_1` FOREIGN KEY (`idUsers`) REFERENCES `users` (`id`);

--
-- Constraints for table `listdetail`
--
ALTER TABLE `listdetail`
  ADD CONSTRAINT `listdetail_ibfk_1` FOREIGN KEY (`idProduct`) REFERENCES `product` (`id`);

--
-- Constraints for table `product`
--
ALTER TABLE `product`
  ADD CONSTRAINT `product_ibfk_1` FOREIGN KEY (`idCategory`) REFERENCES `categoryproduct` (`id`);

--
-- Constraints for table `tmpcart`
--
ALTER TABLE `tmpcart`
  ADD CONSTRAINT `tmpcart_ibfk_1` FOREIGN KEY (`idProduct`) REFERENCES `product` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
