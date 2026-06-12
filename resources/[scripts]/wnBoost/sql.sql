-- =============================================
-- SQL para wnBoost - Sistema de Otimização FPS
-- =============================================

-- Criar tabela de feedbacks (caso não seja criada automaticamente)
CREATE TABLE IF NOT EXISTS `wnBoost_feedbacks` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL,
    `nome` VARCHAR(100) NOT NULL,
    `imagem` TEXT,
    `estrelas` INT NOT NULL DEFAULT 5,
    `status` VARCHAR(20) DEFAULT 'ONLINE',
    `data` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Índice para melhor performance
CREATE INDEX idx_user_id ON wnBoost_feedbacks(user_id);
CREATE INDEX idx_data ON wnBoost_feedbacks(data);

