CREATE TABLE `bot_requests` (
  `id` int(11) NOT NULL,
  `requests` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;